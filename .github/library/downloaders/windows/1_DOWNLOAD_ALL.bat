@echo off
title ESMA source downloader - step 1
cd /d "%~dp0"
echo Step 1: downloading the ESMA / EUR-Lex source library (no installation needed)...
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0fetch_esma_sources.ps1"
echo.
echo If anything failed or came back as a "robot check", run 2_FIX_WITH_BROWSER.bat next.
echo Otherwise send esma_library.zip (in this folder) back to Claude.
echo.
pause
