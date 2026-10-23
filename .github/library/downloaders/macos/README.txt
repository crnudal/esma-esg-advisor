ESMA / EU ESG Ratings Regulation - source downloader for macOS
==============================================================

STEP 1  (nothing to install)
  Double-click  1_download_all.command
  - Downloads all 55 sources (EUR-Lex laws, ESMA reports, registers, templates, Q&A pages,
    related regimes) into the folder  esma_library/
  - Uses curl, zip and shasum, which come with every Mac.
  - At the end it creates  esma_library.zip  and lists anything that failed.

STEP 2  (optional - only if step 1 reports failures or "robot check" pages)
  Double-click  2_fix_with_browser.command
  - Needs Python 3.9+ (python.org installer, or  brew install python , or Apple's
    Command Line Tools - typing python3 in Terminal offers to install them).
  - Installs Playwright into a private .venv folder inside this folder (nothing system-wide)
    and uses Google Chrome or Microsoft Edge if you have them; otherwise it downloads
    Playwright's own Chromium once.
  - Re-tries the leftovers through a real browser and saves every ESMA web page
    (Q&As, hub page, tools) as a PDF.
  - If a site shows "I'm not a robot": in Terminal, in this folder, run
        bash 2_fix_with_browser.command --show
    and tick the box in the browser window that opens.

THEN
  Send  esma_library.zip  back to Claude.

IF macOS BLOCKS THE DOUBLE-CLICK
  Files downloaded from the internet are quarantined, so macOS may say the file
  "cannot be opened" or "Apple could not verify" it. Any one of these fixes it:
   a) Easiest: open Terminal, type  cd  and a space, drag this folder into the Terminal
      window, press Return, then run:   bash 1_download_all.command
   b) Right-click the .command file -> Open -> Open.
      (On macOS 15 Sequoia: try to open it once, then System Settings ->
       Privacy & Security -> scroll down -> "Open Anyway".)
   c) Remove the quarantine flag for the whole folder, then double-click as normal:
         xattr -dr com.apple.quarantine /path/to/esma_downloader_macos
  If it says "permission denied", run once:   chmod +x *.command

TIPS
  - Corporate networks/VPNs can block scripted downloads; your home network usually works best.
  - Re-running is safe: files already downloaded are skipped. Use --force (step 1) or --all
    (step 2) in Terminal to refresh everything, e.g.  bash 1_download_all.command --force
  - The ESMA registers (Art 51 list, Art 14 register) change over time; re-run to get the latest.

FILES
  1_download_all.command      step 1 (bash + curl; no install)
  2_fix_with_browser.command  step 2 launcher (sets up Python venv + Playwright)
  browser_fetch.py            step 2 script (Playwright, real browser)
  sources.csv                 the 55 sources: ID, title, date, official URL, file name
