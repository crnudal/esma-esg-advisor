@echo off
rem INSTALL_Windows.bat - installs the ESMA ESG Advisor (1 agent, 3 skills, library) for GitHub Copilot.
rem Copies files only. Re-running it updates the ESMA files.
setlocal
cd /d "%~dp0"
set "SRC=dot-github"
if not exist "%SRC%\skills" set "SRC=.github"
if not exist "%SRC%\skills" (
  echo Cannot find the agent files ^(dot-github or .github^) next to this file.
  pause
  exit /b 1
)
echo ESMA ESG Advisor - installer for GitHub Copilot
echo.
echo Choose where to install:
echo   1^) Into ONE project: drag the project folder into this window, then press Enter
echo   2^) For ALL projects ^(your personal %USERPROFILE%\.copilot folder^): just press Enter
echo.
set "TARGET="
set /p "TARGET=Project folder (or Enter for all projects): "
if not defined TARGET goto personal
set "TARGET=%TARGET:"=%"
if /I "%TARGET%"=="%CD%" (
  echo That folder already contains the agent ^(it is this folder^). Nothing to copy.
  goto done
)
if not exist "%TARGET%\" (
  echo Folder not found: %TARGET%
  pause
  exit /b 1
)
xcopy "%SRC%" "%TARGET%\.github\" /E /I /Y /Q >nul
if errorlevel 1 goto failed
echo.
echo Installed into %TARGET%\.github  (agents, skills, library)
goto done

:personal
set "DEST=%USERPROFILE%\.copilot"
xcopy "%SRC%\skills" "%DEST%\skills\" /E /I /Y /Q >nul
if errorlevel 1 goto failed
if exist "%DEST%\library" rmdir /S /Q "%DEST%\library"
xcopy "%SRC%\library" "%DEST%\library\" /E /I /Y /Q >nul
if errorlevel 1 goto failed
if not exist "%DEST%\agents" mkdir "%DEST%\agents"
copy /Y "%SRC%\agents\esma-esg-advisor.agent.md" "%DEST%\agents\" >nul
if errorlevel 1 goto failed
echo.
echo Installed for all projects in %DEST%  (skills, library, agent for Copilot CLI)
echo VS Code: skills load automatically. For the read-only agent in VS Code, run
echo "Chat: New Custom Agent" - "User profile" and paste the .agent.md contents,
echo or run this installer again and choose a project folder.
goto done

:failed
echo.
echo Copy failed - check the folder path and your permissions.
pause
exit /b 1

:done
echo.
echo Next: open the project in VS Code - Copilot Chat - model picker: Claude Opus 5.5
echo - agents dropdown: esma-esg-advisor - ask: What can you do?
echo Copilot CLI: run copilot in the project, then /model, /agent and /skills list.
echo.
pause
