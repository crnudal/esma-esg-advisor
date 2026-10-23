# ESGR control library (C01-C21)

Each control maps to obligation IDs (OB-xxx) in [obligations-register.csv](../../esma-rulebook/references/obligations-register.csv). The procedures are suggested starting points: tailor them, and present them as guidance (the user runs the tests).

## Sample sizes (practitioner convention from Anthropic `audit-support`, Apache-2.0; not an ESMA requirement)
| Control frequency | Population | Low risk | Moderate | High |
|---|---|---|---|---|
| Annual | 1 | 1 | 1 | 1 |
| Quarterly | 4 | 2 | 2 | 3 |
| Monthly | 12 | 2 | 3 | 4 |
| Weekly | 52 | 5 | 8 | 15 |
| Daily | ~250 | 20 | 30 | 40 |
| Per event (<250) | varies | 20 | 30 | 40 |
| Per event (250+) | varies | 25 | 40 | 60 |

Use random selection by default, plus targeted items (legacy ratings revised after a methodology change, sovereign issuers without a contact, ratings issued close to deadlines). For an automated control, one test plus effective change management is usually enough.

## Controls

| ID | Control | OB-IDs | Population / frequency | Test procedures (operating effectiveness) | Key evidence |
|---|---|---|---|---|---|
| C01 | Pre-issuance fact-check notice to rated item/issuer | OB-019 | Each first issuance on or after 2 Jul 2026, plus legacy ratings revised after a material methodology change (Q&A 2719) | For each sample: notice timestamp within working hours and at least 2 full working days before issuance; contact channel appropriate (Q&A 2717) or documented search; dataset-access requests answered free of charge; comments considered (Q&A 2716); issuance not earlier than allowed (Q&A 2890) | Notification log, issuance log, email or portal records, contact-search records |
| C02 | Annual methodology review | OB-015, OB-014 | Each methodology; annual | Inspect the review record: date within 12 months, scope covers all components, conclusions, approvals; trace actions to changes | Review packs, minutes, sign-off |
| C03 | Methodology change management and material-change assessment | OB-049, OB-020, OB-043, OB-005 | Each methodology change in period | Change request → impact assessment on existing ratings → materiality per disclosed criteria → approval → version increment → public changelog update → ESMA notification if material (Q&A 2856) → re-notification of affected rated items (Q&A 2719) | Change tickets, impact analysis, version history, disclosures |
| C04 | Ratings changed only per published methodology | OB-020 | Rating changes | Sample changes; re-perform with the published methodology version; flag overrides and analyst adjustments, and check they are within documented methodology discretion | Rating history, override log, methodology version |
| C05 | Data quality and source reliability | OB-018, OB-042, OB-044 | Data loads / pipeline runs | Inspect validation rules (schema, ranges, completeness, staleness); sample failed checks and their resolution; compare disclosed data-quality measures with the controls actually running | Validation logs, data-quality dashboards, incident tickets |
| C06 | Oversight function | OB-017 | Annual / periodic | Charter and independence; reporting to management body; evidence of challenge; resourcing | Charter, reports, minutes |
| C07 | Annual systems effectiveness evaluation | OB-016, OB-010 | Annual | Evaluation exists, covers systems and procedures, deficiencies tracked to closure | Evaluation report, remediation tracker |
| C08 | Separation of activities and staff | OB-021..OB-028 | Annual declarations; access reviews; 24-month assessment | Activity inventory vs Art 16(1); all assessment staff signed annual declarations; workspace allocation; access matrix review for data classification; 24-month adequacy review done; benchmark safeguards (no mechanical reliance) where relevant | Declarations, access reviews, review report, ESMA decision (benchmarks) |
| C09 | Personal trading, recusal, gifts | OB-031, OB-032 | Staff population; periodic attestations | Holdings declarations vs rated universe; recusal log; gifts register; breaches handled | Attestations, holdings data, registers |
| C10 | Leaver look-back and cooling-off | OB-034, OB-035 | Leavers joining rated items | Identify leavers; check look-back reviews were done; 9-month restriction monitored | HR records, review files |
| C11 | Record-keeping and replicability (Annex II items) | OB-036, OB-068 | Historical ratings | Select historical ratings and **replicate** them from retained data, code and methodology version; confirm 5-year retention | Data snapshots, code versions, replication results |
| C12 | Complaints handling | OB-037 | Each complaint | Published procedure; timeliness; independence of the investigator from the rating team; outcome communicated; root cause fed to methodology review | Complaints log, case files |
| C13 | Reasoned concerns | OB-038 | Each concern | Logged; response within 30 working days (non-small) | Concerns log |
| C14 | Outsourcing oversight | OB-039 | Each outsourced relevant function | Contract access and audit rights; oversight reports; no impairment of ESMA supervision | Register, contracts, oversight evidence |
| C15 | Public methodology disclosures (incl. AI use, Annex III 1(k)) | OB-040..OB-045, OB-062, OB-063 | Each product; on change | Compare website section to RTS 2026/871 Arts 3-6 checklist; separate E, S, G or weights disclosed; currency vs latest version | Website snapshots, checklist |
| C16 | User, rated-item and issuer disclosures (incl. reasons for rating moves, data-quality controls, unsolicited flag, major new information) | OB-046..OB-049, OB-064..OB-067 | Ongoing | Annex III pt 2 / RTS Art 7-8 content available to users; distribution licences require a methodology link | Client documentation, licence terms |
| C17 | Conflicts register and annual review | OB-050..OB-053 | Annual + events | Register complete; annual review done; conflicts disclosed to ESMA | Register, review report, ESMA submissions |
| C18 | Remuneration and approval before distribution | OB-054, OB-055 | Each rating distributed; annual remuneration review | Management approval before distribution for samples; remuneration not linked to rating outcomes or commercial results | Workflow logs, remuneration policy |
| C19 | Pricing policy (FRAND) | OB-056 | Fee changes and discounts | Documented pricing policy; discounts approved and non-discriminatory | Policy, fee schedules |
| C20 | Regulatory notifications and ESMA requests | OB-005, OB-052, OB-057 | Events | Material changes notified; ESMA requests answered on time | Regulatory log |
| C21 | ITGC for rating systems | OB-013 | Systems in scope | Access provisioning and review, change management (code to production), batch monitoring, backup and restore | ITGC evidence |
