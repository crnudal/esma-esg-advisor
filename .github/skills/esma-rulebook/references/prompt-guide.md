# Standard prompts

Copy any prompt as written; replace the parts in [brackets]. All of them are guidance requests: the agent reads and explains, and changes nothing unless the last group (explicit actions) is used.

## 1. Find out what the agent is and knows
| Prompt | What you get |
|---|---|
| "What can you do? Show your skills and when to use each, as a table." | One table: skill, purpose, typical questions, documents used |
| "Which documents do you know? Group them and give their IDs and dates." | The document catalogue, summarised by group |
| "What are your limits and house rules?" | Guidance-only behaviour, quoting rules, source hierarchy, what needs your go-ahead |
| "How current is your knowledge? What could be out of date?" | As-of dates of registers, Q&As and open items, plus what a live check would cover |

## 2. Understand the rules (skill: `esma-rulebook`)
| Prompt | What you get |
|---|---|
| "Explain Article [15(12)] in plain English with the exact wording and an example." | Short answer, quote, meaning, example, linked Q&As |
| "Summarise everything an ESG rating provider must disclose, in a table with sources." | Art 23-24, Annex III, RTS 2026/871 in one table |
| "Is [our carbon score / SPO / internal ranking] an ESG rating? Walk me through Art 2 and 3." | Scope test with quotes, exclusions checked, verdict and caveats |
| "What deadlines apply to us as a [non-small EU / small / non-EU] provider?" | Dated table of deadlines and routes |
| "What can ESMA do if we breach the rules? Quote the fines and penalties articles." | Arts 35-38 with quotes; what a fine is based on |
| "Can a UK provider serve EU clients? Compare equivalence, endorsement and recognition." | Comparison table incl. the recognition turnover ceiling |
| "What changed between ESMA's draft RTS and the final RTS?" | Change table from the ESMA final report |
| "What do the ESMA Q&As say about [the two-day notice / small providers / SPOs]?" | Q&A table with exact answer wording |

## 3. Status and providers (skill: `esma-rulebook`)
| Prompt | What you get |
|---|---|
| "Is [MSCI / Sustainalytics / Refinitiv France SAS] on ESMA's lists? Give the list date." | Status from the 16 Oct 2026 lists and what it means |
| "Who is authorised under the ESG Ratings Regulation so far?" | Register summary with date |
| "What is still pending from ESMA or the Commission?" | Open items: endorsement guidelines, ESAs RTS, equivalence |

## 4. Review our position (skill: `esgr-compliance-review`)
| Prompt | What you get |
|---|---|
| "Do a gap review of [attached policy] against the ESGR obligations. Don't edit the file; show the findings as a table." | Gap table: obligation, quote, evidence read, verdict, severity, suggested fix |
| "Which obligations apply to a small provider only? List them with IDs." | Filtered obligation list (Art 5 set) |
| "Design a test for the two-day fact-check control: population, sample, steps, evidence." | Test plan for control C01 |
| "Rate these findings by risk and tell me what to escalate." | Severity × likelihood table, escalation advice |
| "Check whether this finding is real: [finding]." | The five evidence gates with a verdict |

## 5. Methodology and data quality (skill: `esgr-methodology-qa`)
| Prompt | What you get |
|---|---|
| "What does ESMA expect from methodology QA? Map each requirement to the evidence I should keep." | Requirement → QA evidence table |
| "Compare our methodology document with this code. Where do they disagree? Don't change the code." | Statement-by-statement verdicts plus logic the methodology doesn't describe |
| "What must we tell users when a methodology change moves ratings?" | Annex III 2(a)(vi), RTS 871 Art 8, Q&A 2719/2856 with quotes |
| "Which data-quality controls must we disclose, and how often must they run?" | Annex III 2(b)(iv), RTS 871 Art 4(1)(e) explained |
| "Explain the AI disclosure requirements for ESG ratings." | Annex III 1(k) and 2(e) with quotes |

## 6. Explicit actions (only these make changes)
| Prompt | What happens |
|---|---|
| "Save the gap table as a CSV file named [name]." | The agent confirms the file name, then writes it |
| "Refresh the library from ESMA and EUR-Lex now." | The agent explains the steps, then runs the downloader (see `library-maintenance.md`) |
| "Add today's register status to the status tracker." | The agent shows the new row, then appends it |
| "Draft replacement wording for section [x] of our policy." | Text only, for you to paste. The agent does not edit your file |

Tip: add "short answer only" for a 3-bullet reply, or "full detail" for the long version.
