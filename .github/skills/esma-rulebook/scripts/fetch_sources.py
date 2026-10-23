#!/usr/bin/env python3
"""Download every source in library/source-manifest.csv and extract searchable text.

Usage:
  python3 fetch_sources.py                     # core + qa + adjacent
  python3 fetch_sources.py --priority core     # only the core rulebook
  python3 fetch_sources.py --only ESMA-LIST-ART51 ESMA-LIST-REG --force

Writes:
  library/sources/<filename>      original files (PDF, XLSX, HTML, PNG)
  library/text/<id>.txt           extracted text for grep / reading
  library/fetch-log.json          one record per item: status, bytes, sha256, fetched_at

Exit codes: 0 all requested items fetched; 2 some failed; 1 nothing fetched
(a run that downloads zero files must never look like success).
Standard library only. Uses pdftotext (poppler) or pypdf for PDF text if available.
"""
import argparse
import csv
import datetime as dt
import hashlib
import html
import html.parser
import json
import os
import re
import shutil
import subprocess
import sys
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]          # plugin root
LIB = ROOT / "library"
UA = "Mozilla/5.0 (compatible; esma-esg-ratings-plugin/0.2; +regulatory-research)"


class _TextExtractor(html.parser.HTMLParser):
    SKIP = {"script", "style", "noscript", "svg", "head"}

    def __init__(self):
        super().__init__()
        self.parts, self._skip = [], 0

    def handle_starttag(self, tag, attrs):
        if tag in self.SKIP:
            self._skip += 1
        if tag in ("p", "div", "br", "li", "tr", "h1", "h2", "h3", "h4", "td", "th"):
            self.parts.append("\n")

    def handle_endtag(self, tag):
        if tag in self.SKIP and self._skip:
            self._skip -= 1

    def handle_data(self, data):
        if not self._skip:
            self.parts.append(data)


def html_to_text(raw: bytes) -> str:
    p = _TextExtractor()
    p.feed(raw.decode("utf-8", errors="replace"))
    text = html.unescape("".join(p.parts))
    return re.sub(r"\n\s*\n+", "\n\n", text).strip()


def pdf_to_text(path: Path) -> str:
    if shutil.which("pdftotext"):
        out = subprocess.run(["pdftotext", "-layout", str(path), "-"], capture_output=True)
        if out.returncode == 0:
            return out.stdout.decode("utf-8", errors="replace")
    try:
        from pypdf import PdfReader  # type: ignore
        return "\n".join((pg.extract_text() or "") for pg in PdfReader(str(path)).pages)
    except Exception as exc:  # noqa: BLE001
        return f"[text extraction unavailable: {exc}]"


def fetch(url: str, timeout: int) -> tuple[int, str, bytes]:
    req = urllib.request.Request(url, headers={"User-Agent": UA, "Accept": "*/*"})
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        return resp.status, resp.headers.get("Content-Type", ""), resp.read()


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--manifest", default=str(LIB / "source-manifest.csv"))
    ap.add_argument("--priority", nargs="*", default=["core", "qa", "adjacent"])
    ap.add_argument("--only", nargs="*", help="manifest ids to fetch")
    ap.add_argument("--force", action="store_true", help="re-download even if present")
    ap.add_argument("--timeout", type=int, default=60)
    args = ap.parse_args()

    rows = list(csv.DictReader(open(args.manifest, newline="", encoding="utf-8")))
    if args.only:
        rows = [r for r in rows if r["id"] in set(args.only)]
    else:
        rows = [r for r in rows if r["priority"] in set(args.priority)]
    if not rows:
        print("No manifest rows matched the filter.", file=sys.stderr)
        return 1

    (LIB / "sources").mkdir(parents=True, exist_ok=True)
    (LIB / "text").mkdir(parents=True, exist_ok=True)
    log_path = LIB / "fetch-log.json"
    log = json.loads(log_path.read_text()) if log_path.exists() else {}

    ok = failed = skipped = 0
    for r in rows:
        dest = LIB / "sources" / r["filename"]
        if dest.exists() and not args.force:
            skipped += 1
            continue
        rec = {"id": r["id"], "url": r["url"], "fetched_at": dt.datetime.now(dt.timezone.utc).isoformat()}
        try:
            status, ctype, body = fetch(r["url"], args.timeout)
            if dest.suffix == ".pdf" and not body.startswith(b"%PDF"):
                # EUR-Lex sometimes answers with an HTML page; keep it, but flag it.
                dest = dest.with_suffix(".html")
                rec["warning"] = "expected PDF, received non-PDF content"
            dest.write_bytes(body)
            rec.update(status="ok", http=status, content_type=ctype, bytes=len(body),
                       sha256=hashlib.sha256(body).hexdigest(), file=str(dest.relative_to(ROOT)))
            if dest.suffix == ".pdf":
                text = pdf_to_text(dest)
            elif dest.suffix in (".html", ".htm"):
                text = html_to_text(body)
            else:
                text = ""
            if text:
                (LIB / "text" / f"{r['id']}.txt").write_text(
                    f"SOURCE: {r['title']}\nURL: {r['url']}\nFETCHED: {rec['fetched_at']}\n\n{text}",
                    encoding="utf-8")
            ok += 1
            print(f"ok      {r['id']:<18} {len(body):>10,} bytes  {dest.name}")
        except Exception as exc:  # noqa: BLE001
            rec.update(status="failed", error=f"{type(exc).__name__}: {exc}")
            failed += 1
            print(f"FAILED  {r['id']:<18} {rec['error']}")
        log[r["id"]] = rec

    log_path.write_text(json.dumps(log, indent=2))
    print(f"\nfetched {ok}, failed {failed}, already present {skipped} (of {len(rows)} requested)")
    if ok == 0 and skipped == 0:
        print("Nothing was downloaded. If every item failed with a proxy or connection error, the "
              "network is blocking these hosts (allow esma.europa.eu, eur-lex.europa.eu, "
              "ec.europa.eu, iosco.org, fca.org.uk) or run this script on a normal internet connection.",
              file=sys.stderr)
        return 1
    return 2 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
