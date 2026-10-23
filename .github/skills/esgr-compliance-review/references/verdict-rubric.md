# Verdict and severity rubric for ESGR gap assessments

Licence: CC BY-SA 4.0. Adapted from Trail of Bits, *spec-to-code-compliance* (`DIVERGENCE_RUBRIC.md` and the verdict model in `SKILL.md`), https://github.com/trailofbits/skills, licensed CC BY-SA 4.0. Changes: re-targeted from code-vs-specification to regulation-vs-provider-evidence, renamed verdicts, and replaced the security severity anchors with regulatory consequence anchors.

## Verdicts
| Verdict | Meaning | Typical ESGR example |
|---|---|---|
| `met` | Evidence shows the requirement holds on every relevant path | Website section with all RTS 2026/871 Art 3-6 items, versioned |
| `partial` | Holds on the common path, fails on some path or population | Art 15(12) notices sent for new ratings but not for revised legacy ratings |
| `contradicted` | Evidence shows practice opposite to the requirement | Consulting desk advising rated companies on how to raise their score (Art 16(1)(a)) |
| `stronger-than-required` | Provider does more than required; record it so nobody relies on it silently | 3-day fact-check window instead of 2 |
| `absent` | No evidence after a documented search | No annual methodology review record (Art 15(8)) |
| `undecidable` | Requirement or evidence too vague to judge | Policy says "regular review" with no frequency or records |

## Severity (consequence, not wording distance)
**Critical**: could stop the provider operating in the EU, or invites the heaviest measures (Art 35 suspension or withdrawal, temporary ban, fines up to 10% of turnover). Examples: no application filed by 2 Nov 2026; prohibited activity in the entity (Art 16(1)) with no ESMA decision; conflicts that ESMA could order to cease (Art 25(3)).

**High**: a breach ESMA is likely to find and act on in its 2027 priorities (independence, conflicts, methodology robustness), affecting many ratings or users. Examples: methodology changes not following published methodology (Art 15(14)); no oversight function (Art 15(10)); records that cannot replicate ratings (Art 18(2)).

**Medium**: a real gap whose consequence depends on facts not yet established, or one confined to a population or process. Examples: complaints log lacks independence evidence; 24-month separation review overdue.

**Low**: no behavioural consequence. The documentation is wrong or incomplete while the practice complies; the fix belongs in the document.

Raises severity: affects users or rated items directly; systemic (every rating, every run); mandatory wording; other controls depend on it; repeat finding.
Lowers severity: compensating control enforces the same outcome; affects a population that cannot currently occur (state why); small-provider exemption granted (Art 22).
Neither: how emphatic the wording is. A "shall" satisfied by different means is not a finding.

## Stating the consequence
Spell out who is affected and how (users, rated items, ESMA's ability to supervise). If you cannot show it, state what would have to be true for it to matter. **Never invent a fine amount or a scenario.** One fabricated figure discredits the whole register.
