# Evidence gates: verify findings and completion claims

Licence: CC BY-SA 4.0. Part A is adapted from Trail of Bits *fp-check* gate reviews (https://github.com/trailofbits/skills, CC BY-SA 4.0). Part B is adapted from obra/superpowers *verification-before-completion* (MIT, © 2025 Jesse Vincent). Changes: re-targeted from security bugs and code verification to regulatory findings and audit conclusions.

**Core rule: evidence before claims.** A compliance conclusion without a cited quote and cited evidence is an opinion.

## Part A: five gates for every finding
Restate the finding in one sentence first. Weak findings often fall apart at this step.

| Gate | Question | Pass | If it fails |
|---|---|---|---|
| 1. Claim | Can it be stated as "Provider X does / does not do Y, contrary to Z"? | Precise, testable | Rewrite, or drop |
| 2. Provision | Which article, paragraph, RTS article or Q&A? **Quote it** from `library/text/` | Exact quote + citation | Not a finding yet |
| 3. Applicability | Does it apply to this entity, product and period? Check Art 2(2) exclusions, Art 5 small regime, Art 22 exemptions, Art 51 and Q&A 2719 timing, and group context | Applies, with reasons | NOT A FINDING (say why) |
| 4. Evidence | What exactly was read or tested (document, section, date; log extract; sample IDs)? Is it current? | Listed and re-checkable | NEEDS EVIDENCE |
| 5. Refutation | Devil's advocate: is there an alternative means of compliance, a compensating control, evidence elsewhere, or a Q&A reading that resolves it? | Refutation tried and failed | Downgrade or drop |

Report all three outcomes with counts: `CONFIRMED FINDING`, `NOT A FINDING`, `NEEDS EVIDENCE`. Never drop one silently.

## Part B: gate before saying "compliant", "complete" or "no gaps"
1. Identify what proves the claim (e.g. every in-scope OB-ID has a verdict with evidence).
2. Re-check it now: count the verdicts, open the evidence references, and list anything not checked.
3. Claim only what the evidence supports, with counts, e.g. "58 of 61 obligations assessed; 3 not checked (reasons)".

| Claim | Needs | Not enough |
|---|---|---|
| "Compliant with Art X" | Evidence of design **and** operation for the period | A policy exists |
| "Disclosures complete" | Item-by-item check against Annex III and RTS 871 Arts 3-8 | A website section exists |
| "Provider is authorised" | Art 14 register entry, with date | Art 51 list entry; press release; vendor's claim |
| "No new ESMA guidance" | A check of ESMA's site today | Memory; an old check |

## Rationalizations to reject
| Thought | Reality |
|---|---|
| "Clearly a breach" | Severity bias is real. Pass the gates first. |
| "The policy covers it" | Design is not operation. |
| "I'm sure of the law" | Quote it or it isn't cited. |
| "Looks compliant" / "should be fine" | Those words mean the gate wasn't run. |
| "Commentary says ESMA expects…" | Find the ESMA source or label it commentary. |
