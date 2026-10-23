#!/bin/bash
# 1_download_all.command  -  ESMA / EU ESG Ratings Regulation source downloader for macOS
#
# Needs nothing installed: uses curl, zip and shasum, which ship with every Mac.
# Works with the bash 3.2 that macOS includes.
#
# Run:  double-click this file in Finder
#  or:  open Terminal in this folder and run   bash 1_download_all.command
# Options (Terminal only):
#   --only L1-ESGR,L2-871   download specific IDs (see sources.csv)
#   --force                 re-download files you already have

cd "$(dirname "$0")" || exit 1
HERE="$(pwd)"
OUT="$HERE/esma_library"
SRC="$OUT/sources"
MANIFEST="$HERE/sources.csv"
LOG="$OUT/fetch-log.jsonl"
UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36"

ONLY=""
FORCE=0
while [ $# -gt 0 ]; do
  case "$1" in
    --only) ONLY=",$2,"; shift 2 ;;
    --force) FORCE=1; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

if [ -t 1 ]; then G=$'\033[32m'; R=$'\033[31m'; Y=$'\033[33m'; C=$'\033[36m'; N=$'\033[0m'; else G=""; R=""; Y=""; C=""; N=""; fi

finish() {
  # keep the Terminal window open when launched by double-click
  if [ -t 0 ]; then echo; read -n 1 -s -r -p "Press any key to close this window..."; echo; fi
  exit "$1"
}

if [ ! -f "$MANIFEST" ]; then echo "${R}sources.csv not found next to this script.${N}"; finish 1; fi
mkdir -p "$SRC"

json_escape() { printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' | tr -d '\r\n'; }
sha256_of() { if command -v shasum >/dev/null 2>&1; then shasum -a 256 "$1" | cut -d' ' -f1; else sha256sum "$1" | cut -d' ' -f1; fi; }
size_of() { wc -c < "$1" | tr -d ' '; }

ok=0; skipped=0; total=0
FAILED_LIST=""; ROBOT_LIST=""

# count selected rows first
while IFS=, read -r id priority category title reference date url filename; do
  [ "$id" = "id" ] && continue
  [ -z "$id" ] && continue
  if [ -n "$ONLY" ]; then case "$ONLY" in *",$id,"*) ;; *) continue ;; esac; fi
  total=$((total + 1))
done < "$MANIFEST"
if [ "$total" -eq 0 ]; then echo "${R}No sources matched.${N}"; finish 1; fi

echo "${C}Downloading $total sources into $OUT${N}"
echo

while IFS=, read -r id priority category title reference date url filename; do
  [ "$id" = "id" ] && continue
  [ -z "$id" ] && continue
  if [ -n "$ONLY" ]; then case "$ONLY" in *",$id,"*) ;; *) continue ;; esac; fi
  filename="$(printf '%s' "$filename" | tr -d '\r')"
  dest="$SRC/$filename"

  if [ -f "$dest" ] && [ "$FORCE" -eq 0 ]; then
    skipped=$((skipped + 1)); printf "  skip    %-18s already downloaded\n" "$id"; continue
  fi

  now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  err="$(curl -fsSL --retry 2 --connect-timeout 30 --max-time 300 \
          -A "$UA" -H "Accept: */*" -H "Accept-Language: en" \
          -o "$dest" "$url" 2>&1)"
  rc=$?

  if [ $rc -eq 0 ] && [ -s "$dest" ]; then
    warn=""
    case "$dest" in
      *.pdf)
        if [ "$(head -c 4 "$dest")" != "%PDF" ]; then
          mv -f "$dest" "${dest%.pdf}.html"; dest="${dest%.pdf}.html"
          warn="expected a PDF but received a web page (possibly a robot check)"
          ROBOT_LIST="$ROBOT_LIST
  $id: $url"
        fi ;;
    esac
    bytes="$(size_of "$dest")"; sha="$(sha256_of "$dest")"
    printf '{"id":"%s","title":"%s","url":"%s","fetched_at":"%s","status":"ok","bytes":%s,"sha256":"%s","file":"sources/%s","warning":"%s"}\n' \
      "$id" "$(json_escape "$title")" "$url" "$now" "$bytes" "$sha" "$(basename "$dest")" "$warn" >> "$LOG"
    ok=$((ok + 1))
    printf "  ${G}ok${N}      %-18s %12s bytes\n" "$id" "$bytes"
  else
    rm -f "$dest"
    if [ -z "$err" ] && [ $rc -eq 0 ]; then err="empty reply from the server (anti-bot check) - step 2 handles this"; fi
    [ -z "$err" ] && err="curl exit code $rc"
    printf '{"id":"%s","title":"%s","url":"%s","fetched_at":"%s","status":"failed","error":"%s"}\n' \
      "$id" "$(json_escape "$title")" "$url" "$now" "$(json_escape "$err")" >> "$LOG"
    FAILED_LIST="$FAILED_LIST
  $id: $url"
    printf "  ${R}FAILED${N}  %-18s %s\n" "$id" "$err"
  fi
  sleep 0.5
done < "$MANIFEST"

cp -f "$MANIFEST" "$OUT/source-manifest.csv"
nfail=$(printf '%s' "$FAILED_LIST" | grep -c ':' )
nrobot=$(printf '%s' "$ROBOT_LIST" | grep -c ':' )

echo
echo "${C}Done: $ok downloaded, $nfail failed, $skipped already present.${N}"
if [ "$nrobot" -gt 0 ]; then
  echo
  echo "${Y}These came back as web pages instead of PDFs (robot check). Run 2_fix_with_browser.command, or open the links and save the PDFs:${N}$ROBOT_LIST"
fi
if [ "$nfail" -gt 0 ]; then
  echo
  echo "${Y}These failed. Run 2_fix_with_browser.command, or download them by hand:${N}$FAILED_LIST"
fi

if [ $((ok + skipped)) -gt 0 ]; then
  rm -f "$HERE/esma_library.zip"
  if command -v zip >/dev/null 2>&1; then
    (cd "$HERE" && zip -qr esma_library.zip esma_library -x "*.DS_Store")
  else
    (cd "$HERE" && ditto -c -k --keepParent esma_library esma_library.zip)
  fi
  echo
  echo "${C}Created $HERE/esma_library.zip  ->  send this file back to Claude.${N}"
  if [ "$nfail" -gt 0 ] || [ "$nrobot" -gt 0 ]; then finish 2; else finish 0; fi
fi
echo
echo "${R}Nothing was downloaded. Check your internet connection (or VPN / proxy) and try again.${N}"
finish 1
