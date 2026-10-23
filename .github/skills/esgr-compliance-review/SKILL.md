---
name: esgr-compliance-review
description: "Reviews an ESG rating provider's readiness against the ESG Ratings Regulation as guidance. It checks policies, procedures or evidence obligation by obligation, designs control tests, rates the risk of findings and verifies findings through evidence gates. Results are delivered as tables in the reply without editing the user's files. Use for gap reviews, ESMA application readiness, internal-audit or compliance-monitoring plans, control testing, risk scoring, or checking whether a finding is real."
metadata:
  version: "0.3.1"
  adapted_from: "Anthropic knowledge-work-plugins: compliance-check, audit-support, sox-testing, legal-risk-assessment (Apache-2.0); Trail of Bits: spec-to-code-compliance, fp-check (CC BY-SA 4.0); obra/superpowers: verification-before-completion (MIT). See NOTICE.md."
---

# ESGR Compliance Review (guidance)

Compare what the regulation requires with what the provider's evidence shows, and explain the gaps clearly. **Read-only**: findings go in the reply. Never edit the user's documents. Offer suggested wording as text, and only save files if asked.

## Four modes (pick what the user needs; combine where useful)
| Mode | Use when | Output |
|---|---|---|
| **A. Gap review** | "Are we compliant / ready?", or "check this policy against ESGR" | Gap table |
| **B. Control test design** | "How do we test control X?" | Test plan / workpaper outline |
| **C. Risk rating** | "Which findings matter most?" | Risk table with escalation |
| **D. Finding check** | "Is this finding real?" | Gate-by-gate verdict |

## A. Gap review
1. **Profile first**: EU or non-EU, small or non-small, any benchmark or investment-service activity in the entity or group, and the route (authorisation, Art 5, endorsement, recognition). Applicability depends on it, e.g. small providers face only Art 15(1), (5), (7), 23, 24, 32-37.
2. **Select obligations** from [obligations-register.csv](../esma-rulebook/references/obligations-register.csv) by `applies_to`.
3. **For each obligation**: quote the provision from the library text (`../../library/text/<ID>.txt`, or the knowledge file `<ID>.txt` in Copilot Studio), find where the user's evidence addresses it, and **read that part**; a heading is not evidence. Then give a verdict from [verdict-rubric.md](references/verdict-rubric.md): `met`, `partial`, `contradicted`, `stronger-than-required`, `absent` or `undecidable`.
4. **Reverse pass**: note practices in the evidence that create risk but that no obligation covers (e.g. advice on how to improve a rating, Art 16(1)(a) and Q&A 2889).
5. **Gate every negative verdict** ([evidence-gates.md](references/evidence-gates.md)) before reporting it.
6. **Report** as a table: OB-ID · Provision (short quote) · Evidence read · Verdict · Why · Severity · Suggested fix. Add "Not checked" and "Sources" lines.

## B. Control test design
Use [control-library.md](references/control-library.md) (C01-C21, mapped to OB-IDs). For each control give the objective, population, sample size and method (sample-size table in the library file), test steps, evidence that counts and evidence that doesn't, and the conclusion categories (`effective`, `control deficiency`, `significant deficiency`, `potential regulatory breach`). Use [templates.md](references/templates.md) for the layout.

## C. Risk rating
Use [risk-matrix.md](references/risk-matrix.md): severity anchored to ESMA's actual measures (Arts 35-37) × likelihood, giving scores 1-25 with GREEN, YELLOW, ORANGE or RED. Give a one-line reason per rating, never an invented fine amount, and escalation advice.

## D. Finding check
Run the five gates in [evidence-gates.md](references/evidence-gates.md): claim, provision, applicability, evidence, refutation. Return `CONFIRMED FINDING`, `NOT A FINDING` or `NEEDS EVIDENCE`, with reasons.

## Rules
- Follow [answer-format.md](../esma-rulebook/references/answer-format.md) (layout, exact quotes, length limits, guidance only).
- Severity measures consequence, not how far the wording differs.
- "Policy exists" is design, not operation. Say which one you assessed.
- Never claim "compliant" or "no gaps" without the completion gate in `evidence-gates.md`.
