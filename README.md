# ESMA ESG Advisor for GitHub Copilot

A **read-only guidance agent** for the EU ESG Ratings Regulation (Regulation (EU) 2024/3005). It explains the rules with exact quotes from 55 official documents, reviews a provider's position against the obligations, and guides methodology and data-quality QA. It changes nothing unless you explicitly ask.

Version 0.3.1 · knowledge verified 23 Oct 2026 · ESMA registers dated 16 Oct 2026 · works with Claude Opus 5.5 in GitHub Copilot.

## What's in this repository
| Path | What it is |
|---|---|
| `.github/agents/esma-esg-advisor.agent.md` | The advisor agent. Tools: read, search, web only (no edits, no commands) |
| `.github/skills/esma-rulebook/` | What the rules say: scope, routes, obligations, deadlines, ESMA powers, register status, document catalogue, standard prompts |
| `.github/skills/esgr-compliance-review/` | Gap review against 70 obligations, control-test design (21 controls), risk rating, five-gate finding checks |
| `.github/skills/esgr-methodology-qa/` | Methodology, data-quality, change-control, AI-disclosure and replicability QA |
| `.github/library/` | The 55 official documents (originals and searchable text), source manifest, refresh downloaders, licences |
| `INSTALL_macOS.command`, `INSTALL_Windows.bat` | Copy the agent into another project, or into `~/.copilot` for all projects |

## Use it
**In this repository**
1. Clone the repository and open the folder in VS Code.
2. In Copilot Chat, pick **Claude Opus 5.5** in the model picker and **esma-esg-advisor** in the agents dropdown.
3. Ask *"What can you do?"*

**In another project, or in all projects**
- Run `INSTALL_macOS.command` (Mac) or `INSTALL_Windows.bat` (Windows).
- Drag the target project folder into the window, or press Return/Enter to install into `~/.copilot` for all projects.

**Copilot CLI**
- Run `copilot` in the project, then use `/model`, `/agent` and `/skills list`.
- Or start directly with `copilot --agent esma-esg-advisor`.

**Requirements**
- A Copilot Pro+, Max, Business or Enterprise plan. These include Claude Opus 5.5.
- On Business or Enterprise, your admin must not have blocked the model.

## Starter prompts
| Prompt | Goes to |
|---|---|
| "What can you do? Show your skills and when to use each, as a table." | Agent |
| "Which documents do you know? Group them with IDs and dates." | Rulebook |
| "Explain Article 15(12) in plain English with the exact wording and an example." | Rulebook |
| "Can a UK provider serve EU clients? Compare equivalence, endorsement and recognition." | Rulebook |
| "Is Refinitiv France SAS on ESMA's lists? Give the list date." | Rulebook |
| "Do a gap review of [attached policy]. Don't edit it; show findings as a table." | Compliance review |
| "Design a test for the two-day fact-check control." | Compliance review |
| "Map ESMA's methodology requirements to the QA evidence I should keep." | Methodology QA |

More prompts are in `.github/skills/esma-rulebook/references/prompt-guide.md`.

## How it answers
- Short summary bullets first.
- Then a table: point, exact quote, what it means, source.
- Detail only if needed, then up to 3 next steps.
- Sources with document IDs and dates.
- Paragraphs stay short; commentary is labelled; status facts are dated.

## Keeping it current
ESMA's registers and Q&As change. To refresh the library, run the downloaders in `.github/library/downloaders/` on your computer and commit the updated files. EUR-Lex needs the browser step.

## Licences
- Adapted auditing skills: Anthropic knowledge-work-plugins (Apache-2.0), obra/superpowers (MIT), Trail of Bits skills (CC BY-SA 4.0). See `NOTICE.md`; the originals are in `.github/library/third-party/`.
- The regulatory texts are official EU, ESMA, IOSCO and FCA publications.

*Regulatory guidance, not legal advice.*
