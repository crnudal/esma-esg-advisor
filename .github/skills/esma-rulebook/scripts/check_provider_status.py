#!/usr/bin/env python3
"""Look up ESG rating providers in ESMA's published lists.

Usage:
  python3 check_provider_status.py "MSCI" "Sustainalytics" "Refinitiv"
  python3 check_provider_status.py --refresh "ISS"     # re-download both lists first

Reads the extracted text of:
  ESMA-LIST-ART51  firms that notified ESMA under Article 51 (transitional, applications pending)
  ESMA-LIST-REG    Article 14 register (authorised / recognised / registered small providers)

Exit codes: 0 lookup ran; 1 a list is missing or empty (never report "not listed"
when the list itself was not read).
"""
import argparse
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
TEXT = ROOT / "library" / "text"
LISTS = {
    "ESMA-LIST-ART51": "Article 51 notification list (transitional; may keep operating while application pending)",
    "ESMA-LIST-REG": "Article 14 register (authorised / recognised / registered)",
}


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("names", nargs="+")
    ap.add_argument("--refresh", action="store_true")
    args = ap.parse_args()

    if args.refresh:
        subprocess.run([sys.executable, str(Path(__file__).with_name("fetch_sources.py")),
                        "--only", *LISTS.keys(), "--force"], check=False)

    texts = {}
    for lid in LISTS:
        p = TEXT / f"{lid}.txt"
        if not p.exists() or p.stat().st_size < 200:
            print(f"ERROR: {lid} text not available at {p}. Run fetch_sources.py first.", file=sys.stderr)
            return 1
        texts[lid] = p.read_text(encoding="utf-8", errors="replace")

    for lid, body in texts.items():
        m = re.search(r"Last updated:?\s*([0-9]{1,2}\s+\w+\s+20[0-9]{2}|[0-9/.-]{8,10})", body, re.I)
        print(f"{lid}: {LISTS[lid]} | last updated: {m.group(1) if m else 'not found in text'}")
    print()

    for name in args.names:
        pat = re.compile(re.escape(name), re.I)
        print(f"== {name}")
        found = False
        for lid, body in texts.items():
            for line in body.splitlines():
                if pat.search(line):
                    found = True
                    print(f"   [{lid}] {line.strip()}")
        if not found:
            print("   not found in either list (check spelling, legal-entity name, or group entities)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
