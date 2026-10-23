#!/bin/bash
# INSTALL_macOS.command - installs the ESMA ESG Advisor (1 agent, 3 skills, library) for GitHub Copilot.
# Double-click it, or run in Terminal:  bash INSTALL_macOS.command
# Copies files only; it changes nothing else. Re-running it updates the ESMA files.

cd "$(dirname "$0")" || exit 1
SRC="$(pwd)/dot-github"
[ -d "$SRC/skills" ] || SRC="$(pwd)/.github"   # inside the git repo the files live in .github

finish() {
  if [ -t 0 ]; then echo; read -n 1 -s -r -p "Press any key to close this window..."; echo; fi
  exit "$1"
}

if [ ! -d "$SRC/skills" ]; then echo "Cannot find the agent files (dot-github or .github) next to this script."; finish 1; fi

echo "ESMA ESG Advisor - installer for GitHub Copilot"
echo
echo "Choose where to install:"
echo "  1) Into ONE project: drag the project folder into this window, then press Return"
echo "  2) For ALL projects (your personal ~/.copilot folder): just press Return"
echo
printf "Project folder (or Return for all projects): "
read -r TARGET
# tidy a dragged-in path: remove quotes, unescape spaces, trim trailing spaces
TARGET="$(printf '%s' "$TARGET" | sed -e 's/^["'"'"']//' -e 's/["'"'"']$//' -e 's/\\ / /g' -e 's/[[:space:]]*$//')"

if [ -z "$TARGET" ]; then
  DEST="$HOME/.copilot"
  mkdir -p "$DEST/skills" "$DEST/agents" || finish 1
  cp -R "$SRC/skills/." "$DEST/skills/" || finish 1
  rm -rf "$DEST/library" && cp -R "$SRC/library" "$DEST/library" || finish 1
  cp -f "$SRC/agents/esma-esg-advisor.agent.md" "$DEST/agents/" || finish 1
  echo
  echo "Installed for all projects in $DEST:"
  echo "  skills  -> $DEST/skills/ (esma-rulebook, esgr-compliance-review, esgr-methodology-qa)"
  echo "  library -> $DEST/library/"
  echo "  agent   -> $DEST/agents/esma-esg-advisor.agent.md (used by Copilot CLI)"
  echo
  echo "VS Code: the skills load automatically. To get the read-only agent in VS Code too,"
  echo "run 'Chat: New Custom Agent' -> 'User profile' and paste in the contents of the .agent.md file,"
  echo "or run this installer again and choose a project folder."
else
  if [ ! -d "$TARGET" ]; then echo "Folder not found: $TARGET"; finish 1; fi
  DEST="$TARGET/.github"
  mkdir -p "$DEST" || finish 1
  if [ "$(cd "$DEST" && pwd -P)" = "$(cd "$SRC" && pwd -P)" ]; then
    echo "That folder already contains the agent (it is this repository). Nothing to copy."; finish 0
  fi
  cp -R "$SRC/." "$DEST/" || finish 1
  echo
  echo "Installed into $DEST:"
  echo "  .github/agents/esma-esg-advisor.agent.md"
  echo "  .github/skills/ (esma-rulebook, esgr-compliance-review, esgr-methodology-qa)"
  echo "  .github/library/ (55 official documents)"
  echo "(.github is hidden in Finder - press Cmd+Shift+. to show it.)"
fi

echo
echo "Next: open the project in VS Code -> Copilot Chat -> pick 'Claude Opus 5.5' in the model picker"
echo "-> pick 'esma-esg-advisor' in the agents dropdown -> ask: What can you do?"
echo "Copilot CLI: run 'copilot' in the project, then /model, /agent and /skills list."
finish 0
