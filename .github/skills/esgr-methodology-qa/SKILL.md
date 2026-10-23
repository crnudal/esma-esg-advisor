---
name: esgr-methodology-qa
description: "Guides methodology and model QA for ESG ratings and scores against ESGR. It explains what Art 15, Art 18, Art 23-24, Annex III and RTS 2026/871 require of methodologies, data quality, change control, AI use and replicability, maps each requirement to the QA evidence to keep, and compares a published methodology with its code or pipeline without changing either. Use for model/methodology QA, data-quality control design, methodology-change impact reviews, or checking that documentation matches implementation."
metadata:
  version: "0.3.1"
  adapted_from: "Method draws on Trail of Bits spec-to-code-compliance (CC BY-SA 4.0): per-requirement verdicts and a reverse pass. See NOTICE.md."
---

# ESGR Methodology & Model QA (guidance)

ESMA does not judge whether a score is "right" (Art 28: no interference "with the content of ESG ratings or methodologies"). It supervises **how** methodologies are built, applied, reviewed, documented and disclosed. Explain what evidence a QA function should hold. **Read-only**: never edit the user's methodology, code or data. Offer changes as text in a `Suggested change` block.

## What the rules require

Quote from the library text when answering (`../../library/text/<ID>.txt`, or the knowledge file `<ID>.txt` in Copilot Studio).
| Topic | Requirement | Source |
|---|---|---|
| Method quality | "rigorous, systematic, independent and capable of justification", applied "continuously and in a transparent manner" | ESGR Art 15(7) |
| Review | "on an ongoing basis and at least annually" | Art 15(8) |
| Data | sufficient quality, reliable sources | Art 15(11) |
| Changes | ratings changed only per the published methodology | Art 15(14) |
| Records | kept "at least five years" so ratings can be replicated and "fully understood" (incl. "changes in, or deviations from" methodologies) | Art 18(2); Annex II 1(h) |
| E/S/G | separate ratings, or an aggregate with disclosed weights | Art 23(2)-(3); Annex III 1(h) |
| Public disclosure | methodology, data sources and processes, estimation, update frequency, scientific basis, **AI use with limitations and risks**, limitations | Annex III 1; RTS 871 Arts 3-6 |
| User disclosure | KPIs and weights; shortcomings and fixes; revision policy; **reasons when a rating moved because of methodology, model, assumption or data changes**; data update and revision policies; **"data quality controls, their frequency and the remediation process"**; AI methodology | Annex III 2; RTS 871 Arts 7-8 |
| Change control | revision process, triggers, impact on existing ratings, **material-change criteria**, version number, data-revision steps | RTS 871 Art 8 |
| After a material change | re-notify affected rated items for fact-check; notify ESMA of material changes | Q&A 2719; Q&A 2856; Art 6(5) |

## How to help
1. **Map** each requirement to the QA evidence using [disclosure-to-evidence-map.md](references/disclosure-to-evidence-map.md), as a table: requirement (quote) · what to evidence · example artefact.
2. **Methodology vs implementation** (when the user supplies both): split the methodology into checkable statements; for each one, find and **read** the code that enforces it and give a verdict (`met / partial / contradicted / stronger-than-required / absent / undecidable`; rubric in [verdict-rubric.md](../esgr-compliance-review/references/verdict-rubric.md)). Then do the **reverse pass**: list logic the code applies that the methodology does not describe (overrides, hard-coded exclusions, silent imputation, undocumented caps). Under Art 15(14) these are the highest-risk items.
3. **Disclosure accuracy**: check that what is (or will be) disclosed about data quality, estimation, limitations and AI matches the controls that actually run.
4. **Change impact**: suggest a cross-version comparison (distribution shifts, band migrations, rank correlation, largest movers with reasons) as the evidence for RTS 871 Art 8(1) and Annex III 2(a)(vi).
5. **Replicability**: suggest re-running sampled historical ratings from the retained data, code and methodology version (Art 18(2)).

## Notes
- Back-testing is not required by the texts. Present it as good practice, not law.
- A data-quality check that inspects zero rows must fail, not pass. Recommend that safeguard.
- Gate findings through [evidence-gates.md](../esgr-compliance-review/references/evidence-gates.md) before calling anything compliant.
- Follow [answer-format.md](../esma-rulebook/references/answer-format.md) (short answer, quote table, sources, short paragraphs).
