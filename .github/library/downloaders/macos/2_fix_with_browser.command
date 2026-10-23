#!/bin/bash
# 2_fix_with_browser.command  -  OPTIONAL step 2 for macOS (Playwright + a real browser)
# Re-tries anything step 1 could not get (e.g. EUR-Lex robot checks) and saves ESMA web pages as PDFs.
# Needs Python 3.9+. Playwright is installed into a private folder (.venv) here, not into your system.
#
# Options are passed through to browser_fetch.py:  --show  (visible browser, to tick "I'm not a robot")
#                                                   --all   (fetch everything via the browser)

cd "$(dirname "$0")" || exit 1

finish() {
  if [ -t 0 ]; then echo; read -n 1 -s -r -p "Press any key to close this window..."; echo; fi
  exit "$1"
}

PY=""
for cand in python3.13 python3.12 python3.11 python3.10 python3; do
  if command -v "$cand" >/dev/null 2>&1 && "$cand" -c 'import sys; sys.exit(0 if sys.version_info >= (3, 9) else 1)' >/dev/null 2>&1; then
    PY="$cand"; break
  fi
done
if [ -z "$PY" ]; then
  echo "Python 3.9 or newer is needed for this optional step."
  echo "Install it from https://www.python.org/downloads/macos/  or with Homebrew:  brew install python"
  echo "(On a new Mac, typing  python3  in Terminal also offers to install Apple's Command Line Tools, which include Python.)"
  finish 1
fi

if [ ! -x ".venv/bin/python" ]; then
  echo "Setting up a private Python environment (one-time)..."
  "$PY" -m venv .venv || { echo "Could not create the Python environment."; finish 1; }
fi
if ! .venv/bin/python -c "import playwright" >/dev/null 2>&1; then
  echo "Installing Playwright (one-time, about 40 MB)..."
  .venv/bin/python -m pip install --disable-pip-version-check -q --upgrade pip >/dev/null 2>&1
  .venv/bin/python -m pip install --disable-pip-version-check -q playwright || { echo "Playwright install failed."; finish 1; }
fi

echo "Step 2: fetching leftovers with a real browser and saving web pages as PDF..."
echo
.venv/bin/python browser_fetch.py "$@"
rc=$?
echo
echo "Send esma_library.zip (in this folder) back to Claude."
finish $rc
