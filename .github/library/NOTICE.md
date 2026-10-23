# Third-party material and licences

This plugin adapts several well-known open-source auditing skills. The originals are kept unmodified under `third-party/` with their licence files, for provenance. They sit outside `skills/`, so they are not loaded as skills.

| Source | Original | Licence | Used in (with changes) |
|---|---|---|---|
| Anthropic, `knowledge-work-plugins` (github.com/anthropics/knowledge-work-plugins), commit 33d3dea, 2026-10-21 | `finance/skills/audit-support`, `finance/skills/sox-testing` | Apache-2.0 | `skills/esgr-compliance-review` (control test design, `references/control-library.md`, `references/templates.md`): SOX 404 method re-targeted to ESGR controls; sample-size table reproduced; deficiency classes renamed; workpaper structure adapted |
| same | `legal/skills/compliance-check` | Apache-2.0 | `skills/esgr-compliance-review` (gap review mode): output structure re-targeted from privacy law to ESGR |
| same | `legal/skills/legal-risk-assessment` | Apache-2.0 | `skills/esgr-compliance-review/references/risk-matrix.md`: 5×5 matrix and colour bands kept; severity anchors and escalation rewritten for ESMA measures |
| Jesse Vincent, `superpowers` (github.com/obra/superpowers), commit 2ce8aa1, 2026-10-21 | `skills/verification-before-completion` | MIT, © 2025 Jesse Vincent | `skills/esgr-compliance-review/references/evidence-gates.md` Part B: gate function and claims table adapted to audit conclusions |
| Trail of Bits, `skills` (github.com/trailofbits/skills), commit 1e0cb77, 2026-10-22 | `plugins/spec-to-code-compliance` (SKILL.md, DIVERGENCE_RUBRIC.md) | CC BY-SA 4.0 | `skills/esgr-compliance-review/references/verdict-rubric.md` and the verdict model used in `esgr-compliance-review` and `esgr-methodology-qa`: verdicts renamed, regulatory severity anchors. **Licensed CC BY-SA 4.0** |
| same | `plugins/fp-check` (SKILL.md, gate-reviews.md) | CC BY-SA 4.0 | `skills/esgr-compliance-review/references/evidence-gates.md` Part A: six security gates replaced by five regulatory gates; rationalizations adapted. **Licensed CC BY-SA 4.0** |

Under Apache-2.0, modified files must carry notice of the changes; the `adapted_from` metadata in each SKILL.md and this file serve that purpose. CC BY-SA 4.0 requires adaptations to be shared under the same licence: the files marked above are licensed CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/). Everything else in this plugin is original work by the plugin author.

Regulatory texts in `library/` are official EU, ESMA, IOSCO and FCA publications, downloaded from their official URLs and subject to their own reuse terms (EU: Commission Decision 2011/833/EU; ESMA: legal notice on its website).
