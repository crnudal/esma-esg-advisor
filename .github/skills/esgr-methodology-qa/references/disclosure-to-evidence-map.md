# ESGR, Annex III and RTS 2026/871 requirements → QA evidence

Guidance on what to hold as evidence. The user decides and implements; nothing here changes their systems.

| Requirement | What must be true | QA evidence to hold |
|---|---|---|
| ESGR Art 15(7) | Methodology rigorous, systematic, independent, justifiable; applied continuously and transparently | Spec-to-code verdict table; determinism test (same inputs, same outputs); consistency across rated items and periods |
| ESGR Art 15(8) | Review ongoing and at least annual | Annual review pack with findings and approvals |
| ESGR Art 15(11) | Data of sufficient quality, from reliable sources | Source register with reliability assessment; validation logs; exception tickets |
| ESGR Art 15(12) | Rated item can get Annex III info and last data-update date | Per-entity data-update timestamps retrievable; dataset export for fact-check |
| ESGR Art 15(14) | Changes only per published methodology | Reverse-pass findings = none or justified; override log within documented discretion |
| ESGR Art 18(2) | Ratings replicable and fully understood for 5 years | Replication test results; retained snapshots, code and methodology versions |
| ESGR Art 23(2)-(3) | Separate E, S, G or aggregate with weights | Product output schema; weights disclosure |
| RTS 871 Art 3 | Risks/impacts, double materiality, factors, aggregation, Paris alignment stated | Disclosure text matches implemented materiality matrix and aggregation |
| RTS 871 Art 4(1)(e) | Data-quality measures disclosed | Disclosure wording matches the control inventory (no over-claiming) |
| RTS 871 Art 4(1)(g) | Latest update date and change description | Changelog; versioned documents |
| RTS 871 Art 4 (other items) | Scale meaning, validity period, industry classification, engagement process, scientific-evidence process | Documented and consistent with code (e.g. the industry classification actually used in peer grouping) |
| RTS 871 Art 5 | Limitations: availability, completeness, timeliness, accuracy, proxies, estimation | Coverage stats; estimated-value share; staleness distribution |
| RTS 871 Art 7(1) | Non-public data collection methods | Process documentation |
| RTS 871 Art 7(2) | Shortcomings of statistical/algorithmic models | Model limitations register |
| RTS 871 Art 8(1) | Revision process, triggers, consultation, impact assessment, material-change criteria | Change procedure; cross-version impact reports; materiality decisions |
| RTS 871 Art 8(2) | Version number | Semantic versioning in documents and outputs |
| RTS 871 Art 8(3) | Accuracy and consistency when data are revised | Restatement procedure; revision logs |
| Annex III 1(c) | Data sources, processes, estimation when data are unavailable, update frequency (public) | Data lineage summary; estimation rules; update calendar |
| Annex III 1(k); 2(e) | Use of AI in data collection or rating: limitations and risks (public); methodology explanation (users) | AI/ML component inventory; model cards; limitations statement |
| Annex III 2(a)(iv) | Shortcomings of methodologies and the measures taken | Known-issues register with remediation |
| Annex III 2(a)(vi) | Reasons and implications when a rating moved because of material methodology, model, assumption or data changes | Change-impact report linked to affected ratings; user notice text |
| Annex III 2(b)(iii) | Policies for updating data and revising historical data; last update date | Restatement policy; per-entity update timestamps |
| Annex III 2(b)(iv) | Data quality controls, their frequency and remediation process | Control inventory (rule, threshold, frequency, owner, exception workflow, logs) |
| Annex III 2(f) | How major new information on a rated item was taken into account | Event/controversy review log |
| Annex II 1(h) | Record changes in, or deviations from, standard procedures and methodologies | Override and deviation log with approvals |
| Q&A 2719 | Legacy ratings re-notified after material methodology change | Link from change ticket to re-notification batch |
| Q&A 2856 | Material methodology changes notified to ESMA | Regulatory notification log |
