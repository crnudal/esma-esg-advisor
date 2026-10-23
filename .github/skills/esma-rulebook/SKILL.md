---
name: esma-rulebook
description: "Explains the EU ESG Ratings Regulation (2024/3005), its delegated acts, ESMA Q&As, guidelines, statements, registers and ESMA's jurisdiction, quoting the official texts stored in the plugin library. Use when someone asks what a rule says, whether a product or firm is in scope, which deadline or route applies, what ESMA can do, whether a provider is on ESMA's lists, which documents the agent knows, or what it can do."
metadata:
  version: "0.3.1"
---

# ESMA Rulebook (guidance)

Explain the rules clearly, with exact quotes from the stored official texts. **Read-only**: change nothing unless the user explicitly asks (see the house rules).

## Before answering
1. Read [answer-format.md](references/answer-format.md) (house rules: guidance only, layout, quoting, length) and follow it.
2. Find the right source in [document-catalogue.md](references/document-catalogue.md), then search the matching `<ID>.txt` text file for the exact wording. The official texts are in the `library` folder two levels above this skill ([../../library/text/](../../library/text/), one `<ID>.txt` per document). In Copilot Studio they are the agent's knowledge files with the same `<ID>.txt` names. Use the reference digests to know where to look; quote from the library text.

## Where knowledge sits
| Need | File |
|---|---|
| Every article, verified, with key quotes and Annex contents | [article-map.md](references/article-map.md) |
| 70 obligations with IDs (OB-001..OB-070), who they apply to, evidence | [obligations-register.csv](references/obligations-register.csv) |
| RTS 2026/871, 872, 1119; fees 910; fines 904; ESMA final report; July statement; endorsement CP | [delegated-acts.md](references/delegated-acts.md) |
| 16 ESMA Q&As with exact answer wording | [qa-digest.md](references/qa-digest.md) |
| Jurisdiction table, ESMA's wider ESG remit, **dated status tracker**, commentary | [jurisdiction-and-status.md](references/jurisdiction-and-status.md) |
| All 55 documents: IDs, dates, what each covers | [document-catalogue.md](references/document-catalogue.md) |
| Standard prompts for users | [prompt-guide.md](references/prompt-guide.md) |
| Refreshing the library (on request only) | [library-maintenance.md](references/library-maintenance.md) |

## How to handle common questions
- **"What can you do / what do you know?"** Answer with a table of the three skills (purpose, example questions, documents) and the document groups from the catalogue. Offer the standard prompts.
- **Scope.** Walk through Art 2(1) (operating in the Union) → Art 3(1) (methodology **and** defined ranking system; Q&A 2853) → each Art 2(2) exclusion that could apply (quote it) → route (Art 4). Mention ESMA's self-assessment tools (`ESMA-TOOL-SCOPE`, `ESMA-TOOL-PRODUCT`).
- **Obligations.** Give the article quote, then the RTS article that details it, then the Q&A, then the OB-ID. Example chain: Art 15(12) → Q&As 2716, 2717, 2719, 2890, 2891 → OB-019.
- **Routes for non-EU providers.** Compare equivalence, endorsement and recognition in a table. State that recognition is limited to providers below the small-undertaking turnover ceiling (Art 12(1)).
- **Enforcement.** Arts 35-38 with quotes: fines up to 10% of turnover (group consolidated, Art 36(2)); periodic penalties at 3% of daily turnover for up to 6 months. Always add the Art 28 non-interference limit.
- **Status or provider look-ups.** Read the stored lists (`ESMA-LIST-ART51`, `ESMA-LIST-REG`, dated 16 Oct 2026) or run `scripts/check_provider_status.py "<name>"` (read-only). Give the list date. An Art 51 entry means notified, not authorised. Offer a live re-check rather than downloading unasked.

## Facts that are easy to get wrong
- RTS apply from 2 Jul 2026 even though published later. In force since 1 Jan 2025; applies from 2 Jul 2026.
- 2 Aug 2026: notification deadline (non-small). **2 Nov 2026**: application deadline (non-small) and notification deadline (small).
- Small providers face only Art 15(1), (5), (7), 23, 24 and 32-37 while registered under Art 5.
- The marketing-disclosure duty in Art 2(2)(c) and Art 49 is for financial firms that **issue** ratings. For third-party ratings, the provider attaches the link (Art 24(2)).
- Q&As 2806 and 2807 were answered by the Commission.

## Output
Follow [answer-format.md](references/answer-format.md): short answer bullets → key points table with exact quotes → detail if needed → next steps → sources with IDs and dates. Keep every bullet or paragraph short (never more than about 500 words).
