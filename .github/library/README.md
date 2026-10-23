# Source library

- `source-manifest.csv`: 55 official sources (ID, title, reference, date, URL, file name).
- `sources/`: the original files, downloaded from the official sites and validated on 23 Oct 2026 (6 EU laws, 18 ESMA documents, 16 Q&As, 15 related texts).
- `text/<ID>.txt`: extracted text used for searching and quoting (the timeline image has no text).
- `fetch-log.json`: size, SHA-256, page count and origin for every file.
- `downloaders/`: macOS and Windows scripts for refreshing on your own computer. EUR-Lex and IOSCO need the browser step.

Refresh only when you want to (see `skills/esma-rulebook/references/library-maintenance.md`).
