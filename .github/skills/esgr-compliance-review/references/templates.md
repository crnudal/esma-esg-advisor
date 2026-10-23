# Output templates (fill in the reply; save as a file only if the user asks)

## Gap review table
| OB-ID | Provision (short exact quote) | Evidence read (doc, section, date) | Verdict | Why | Severity | Suggested fix |
|---|---|---|---|---|---|---|

Follow it with three short lines:
- **Not checked**: obligations out of scope or without evidence, and why.
- **Counts**: met / partial / contradicted / absent / undecidable / stronger-than-required.
- **Sources**: library IDs and dates.

## Control test plan (adapted from Anthropic `sox-testing`, Apache-2.0)
| Field | Content |
|---|---|
| Control | C-ID, what, who, when; OB-IDs |
| Objective | "Determine whether [control] operated effectively to meet [provision] from [date] to [date]" |
| Population | Definition, source system, completeness check |
| Sample | Size, method (random / systematic / targeted + reason) |
| Steps | 1…n |
| Evidence that counts | e.g. timestamped system logs, dated approvals, re-performance, replication from records |
| Evidence that doesn't | verbal assurance alone, undated documents, reports without timestamps |
| Conclusion options | effective · effective with isolated exceptions · control deficiency · significant deficiency · potential regulatory breach (escalate) |

## Risk register
| Risk ID | OB-ID / provision | Description | Severity | Likelihood | Score | Level | Owner | Mitigation | Next review |
|---|---|---|---|---|---|---|---|---|---|

## Finding check
`FINDING #n: CONFIRMED / NOT A FINDING / NEEDS EVIDENCE`, then the gate that decided it and why (one line each).
