"""
browser_fetch.py  -  OPTIONAL step 2 of the ESMA source downloader (uses a real browser via Playwright).
Works on macOS and Windows.

What it does
  * Re-tries anything step 1 could not get (failed downloads, or EUR-Lex "robot check" pages
    that came back instead of PDFs) using a real browser, so cookies and JavaScript checks work.
  * Saves every ESMA web page in the list (Q&As, hub page, self-assessment tools...) as a
    printable PDF next to its HTML copy.
  * Re-creates esma_library.zip.

Requirements
  * Python 3.9+. On macOS, 2_fix_with_browser.command installs Playwright into a private .venv folder.
  * Uses Google Chrome or Microsoft Edge if installed; otherwise downloads Playwright's own Chromium once.

Run:  macOS   double-click 2_fix_with_browser.command   (or: .venv/bin/python browser_fetch.py [options])
      Windows double-click 2_FIX_WITH_BROWSER.bat       (or: py browser_fetch.py [options])
  --all       fetch every source through the browser, not just the missing ones
  --show      show the browser window (use this if a site asks you to tick "I'm not a robot")
  --no-print  skip saving web pages as PDF
"""
from __future__ import annotations

import argparse
import csv
import datetime as dt
import hashlib
import importlib
import json
import shutil
import subprocess
import sys
import time
from pathlib import Path
from urllib.parse import urlparse

HERE = Path(__file__).resolve().parent
OUT = HERE / "esma_library"
SRC = OUT / "sources"


def ensure_playwright():
    try:
        return importlib.import_module("playwright.sync_api")
    except ImportError:
        print("Installing Playwright (one-time, about 40 MB)...")
        subprocess.check_call([sys.executable, "-m", "pip", "install", "--disable-pip-version-check", "playwright"])
        import site
        site.addsitedir(site.getusersitepackages())
        importlib.invalidate_caches()
        return importlib.import_module("playwright.sync_api")


def launch(pw, headless: bool):
    errors = []
    channels = ("chrome", "msedge", None) if sys.platform == "darwin" else ("msedge", "chrome", None)
    for channel in channels:
        try:
            kw = {"headless": headless}
            if channel:
                kw["channel"] = channel
            browser = pw.chromium.launch(**kw)
            print(f"Browser: {channel or 'playwright chromium'}")
            return browser
        except Exception as exc:  # noqa: BLE001
            errors.append(f"{channel}: {str(exc).splitlines()[0]}")
    print("Chrome/Edge not found; downloading Playwright's Chromium (one-time)...")
    subprocess.check_call([sys.executable, "-m", "playwright", "install", "chromium"])
    return pw.chromium.launch(headless=headless)


def is_valid(path: Path) -> bool:
    if not path.exists() or path.stat().st_size == 0:
        return False
    if path.suffix.lower() == ".pdf":
        with path.open("rb") as fh:
            return fh.read(4) == b"%PDF"
    return True


def _good(body: bytes, dest: Path) -> bool:
    return bool(body) and (dest.suffix.lower() != ".pdf" or body[:4] == b"%PDF")


IN_PAGE_FETCH = """async (u) => {
  const r = await fetch(u, {credentials: 'include'});
  const b = new Uint8Array(await r.arrayBuffer());
  let s = '';
  for (let i = 0; i < b.length; i += 0x8000) s += String.fromCharCode.apply(null, b.subarray(i, i + 0x8000));
  return {status: r.status, b64: btoa(s)};
}"""


def fetch_binary(page, context, url: str, dest: Path, host: str, show: bool) -> str:
    """Try several ways to get a file past bot checks (EUR-Lex uses an AWS WAF JavaScript challenge).
    Returns the name of the method that worked; raises if none did."""
    import base64

    # 1. plain request using the browser's cookies
    resp = context.request.get(url, timeout=120000, headers={"Accept": "*/*"})
    body = resp.body() if resp.ok else b""
    if resp.status == 200 and _good(body, dest):
        dest.write_bytes(body)
        return "browser-request"

    # 2. open the link in the browser so the challenge script runs; catch the download
    if show:
        print("          a browser window is open - complete any robot check there (waiting up to 2.5 min)")
    try:
        with page.expect_download(timeout=150000 if show else 30000) as dl:
            try:
                page.goto(url, timeout=90000)
            except Exception:  # noqa: BLE001  ("Download is starting" is expected)
                pass
        dl.value.save_as(str(dest))
        if is_valid(dest):
            return "browser-download"
    except Exception:  # noqa: BLE001
        pass

    # 3. the challenge has usually set its token cookie by now; ask again
    page.wait_for_timeout(1500)
    resp = context.request.get(url, timeout=120000, headers={"Accept": "*/*"})
    body = resp.body() if resp.ok else b""
    if resp.status == 200 and _good(body, dest):
        dest.write_bytes(body)
        return "browser-request-after-check"

    # 4. fetch from inside the page itself (same origin, same cookies as a human visitor)
    try:
        if not page.url.startswith(host):
            page.goto(host + "/", wait_until="domcontentloaded", timeout=60000)
            page.wait_for_timeout(3000)
        res = page.evaluate(IN_PAGE_FETCH, url)
        body = base64.b64decode(res.get("b64") or "")
        if res.get("status") == 200 and _good(body, dest):
            dest.write_bytes(body)
            return "in-page-fetch"
    except Exception:  # noqa: BLE001
        pass
    raise RuntimeError("bot check not passed - try again with --show, or download this one by hand")


def record(log: dict, row: dict, dest: Path, method: str, note: str = "") -> None:
    data = dest.read_bytes()
    log[row["id"]] = {
        "id": row["id"], "title": row["title"], "url": row["url"], "status": "ok",
        "fetched_at": dt.datetime.now(dt.timezone.utc).isoformat(), "bytes": len(data),
        "sha256": hashlib.sha256(data).hexdigest(), "file": f"sources/{dest.name}", "method": method,
        **({"note": note} if note else {}),
    }


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--all", action="store_true")
    ap.add_argument("--show", action="store_true")
    ap.add_argument("--no-print", action="store_true")
    ap.add_argument("--only", nargs="*", help="only these IDs, e.g. --only L1-ESGR L2-871 (commas also work)")
    ap.add_argument("--manifest", default=str(HERE / "sources.csv"))
    args = ap.parse_args()
    only = {x.strip() for item in (args.only or []) for x in item.split(",") if x.strip()}
    printing = not args.no_print and not args.show   # Chromium can only print to PDF when headless
    if args.show and not args.no_print:
        print("Note: web pages are saved as HTML only in --show mode (PDF printing needs the hidden browser).")

    rows = list(csv.DictReader(open(args.manifest, newline="", encoding="utf-8")))
    if only:
        rows = [r for r in rows if r["id"] in only]
        if not rows:
            print("No sources matched --only.")
            return 1
    SRC.mkdir(parents=True, exist_ok=True)
    log_path = OUT / "fetch-log.json"
    log = json.loads(log_path.read_text(encoding="utf-8-sig")) if log_path.exists() else {}

    sync_api = ensure_playwright()
    done, failed, printed = [], [], []
    warmed = set()

    with sync_api.sync_playwright() as pw:
        browser = launch(pw, headless=not args.show)
        context = browser.new_context(accept_downloads=True, locale="en-GB")
        page = context.new_page()

        for row in rows:
            dest = SRC / row["filename"]
            is_page = dest.suffix.lower() in (".html", ".htm")
            need_fetch = args.all or not is_valid(dest)
            need_print = printing and is_page and not dest.with_suffix(".pdf").exists()
            if not (need_fetch or need_print):
                continue

            host = urlparse(row["url"]).scheme + "://" + urlparse(row["url"]).netloc
            if host not in warmed:   # visit the site once so cookies / JavaScript checks are in place
                try:
                    page.goto(host + "/", wait_until="domcontentloaded", timeout=60000)
                    page.wait_for_timeout(2500 if args.show else 1500)
                except Exception:  # noqa: BLE001
                    pass
                warmed.add(host)

            try:
                if is_page:
                    page.goto(row["url"], wait_until="networkidle", timeout=90000)
                    if need_fetch:
                        dest.write_text(page.content(), encoding="utf-8")
                        record(log, row, dest, "browser-page")
                        done.append(row["id"])
                    if need_print:
                        pdf_path = dest.with_suffix(".pdf")
                        page.pdf(path=str(pdf_path), format="A4", print_background=True,
                                 margin={"top": "12mm", "bottom": "12mm", "left": "10mm", "right": "10mm"})
                        printed.append(row["id"])
                    print(f"  ok      {row['id']:<18} page{' + PDF' if need_print else ''}")
                else:
                    method = fetch_binary(page, context, row["url"], dest, host, args.show)
                    stale = dest.with_suffix(".html")
                    if dest.suffix.lower() == ".pdf" and stale.exists():
                        stale.unlink()   # remove the robot-check page saved by step 1
                    record(log, row, dest, method)
                    done.append(row["id"])
                    print(f"  ok      {row['id']:<18} {dest.stat().st_size:>12,} bytes  ({method})")
            except Exception as exc:  # noqa: BLE001
                failed.append(row)
                print(f"  FAILED  {row['id']:<18} {str(exc).splitlines()[0][:120]}")
            time.sleep(0.5)

        browser.close()

    log_path.write_text(json.dumps(log, indent=2), encoding="utf-8")
    shutil.copyfile(args.manifest, OUT / "source-manifest.csv")
    print(f"\nDone: {len(done)} fetched with the browser, {len(printed)} web pages saved as PDF, {len(failed)} failed.")
    if failed:
        print(f"\nStill failing; open these in your browser and save them into {SRC}:")
        for r in failed:
            print(f"  {r['id']}: {r['url']}")
        print("Tip: run again with --show and complete any 'I'm not a robot' check in the window.")

    zip_base = HERE / "esma_library"
    shutil.make_archive(str(zip_base), "zip", root_dir=HERE, base_dir="esma_library")
    print(f"\nCreated {zip_base}.zip  ->  send this file back to Claude.")
    return 2 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
