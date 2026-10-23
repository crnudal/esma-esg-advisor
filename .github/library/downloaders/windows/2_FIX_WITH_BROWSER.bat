@echo off
title ESMA source downloader - step 2 (browser)
cd /d "%~dp0"
where py >nul 2>nul
if %errorlevel%==0 (set PY=py) else (set PY=python)
%PY% --version >nul 2>nul
if not %errorlevel%==0 (
  echo Python was not found. Install it with:  winget install Python.Python.3.12
  echo or from https://www.python.org/downloads/  ^(tick "Add python.exe to PATH"^), then run this again.
  echo.
  pause
  exit /b 1
)
echo Step 2: fetching leftovers with Microsoft Edge and saving web pages as PDF...
echo.
%PY% "%~dp0browser_fetch.py" %*
echo.
echo Send esma_library.zip (in this folder) back to Claude.
echo.
pause
