ESMA / EU ESG Ratings Regulation - source downloader for Windows
================================================================

STEP 1  (nothing to install)
  Double-click  1_DOWNLOAD_ALL.bat
  - Downloads all 55 sources (EUR-Lex laws, ESMA reports, registers, templates, Q&A pages,
    related regimes) into the folder  esma_library\
  - Uses the PowerShell that is built into Windows 10/11.
  - At the end it creates  esma_library.zip  and lists anything that failed.

STEP 2  (optional - only if step 1 reports failures or "robot check" pages)
  Double-click  2_FIX_WITH_BROWSER.bat
  - Needs Python 3.9+  (winget install Python.Python.3.12, or python.org with "Add to PATH").
  - Installs Playwright automatically the first time and drives Microsoft Edge, which is
    already on your PC, so no extra browser download.
  - Re-tries the leftovers through a real browser and also saves every ESMA web page
    (Q&As, hub page, tools) as a PDF.
  - If a site shows "I'm not a robot":  open a Command Prompt in this folder and run
        py browser_fetch.py --show
    then tick the box in the browser window that opens.

THEN
  Send  esma_library.zip  back to Claude.

TIPS
  - Windows may say "Windows protected your PC" for the .bat files because they came from
    the internet: click "More info" -> "Run anyway". (Or right-click the downloaded zip ->
    Properties -> tick "Unblock" before extracting.)
  - Corporate networks can block scripted downloads. Your home network usually works best.
  - Re-running is safe: files already downloaded are skipped. Use -Force / --all to refresh.
  - The ESMA registers (Art 51 list, Art 14 register) change over time; re-run to get the latest.

FILES
  1_DOWNLOAD_ALL.bat        step 1 launcher
  fetch_esma_sources.ps1    step 1 script (PowerShell)
  2_FIX_WITH_BROWSER.bat    step 2 launcher
  browser_fetch.py          step 2 script (Python + Playwright + Edge)
  sources.csv               the 55 sources: ID, title, date, official URL, file name
