# Keeping the library current (only when the user asks)

Refreshing writes files, so it is a change. Do it **only on an explicit request** ("refresh the library", "download the latest register"). Otherwise, say how current the library is and offer a refresh.

## What is in the library
- `library/source-manifest.csv`: 55 sources (ID, title, reference, date, official URL, filename).
- `library/sources/`: the originals (PDF, XLSX, HTML, PNG). `library/text/<ID>.txt`: extracted text for search and quotes.
- `library/fetch-log.json`: size, SHA-256 and origin of each file.
- Current set: downloaded by the user from the official sites and verified on 23 Oct 2026. Registers dated 16 Oct 2026.

## How to refresh
1. Tell the user what will be downloaded and overwritten, and ask for a go-ahead.
2. Run `python3 scripts/fetch_sources.py --only <IDs> --force` from the `esma-rulebook` skill folder. The usual IDs are `ESMA-LIST-ART51`, `ESMA-LIST-REG`, `ESMA-HUB`, `ESMA-ENDORSE-PAGE` and `EC-L2-PAGE`.
3. **EUR-Lex and IOSCO block scripts** with a bot check (an empty reply or HTTP 403). For those, use the downloaders in `library/downloaders/` on the user's computer: macOS `1_download_all.command`, then `2_fix_with_browser.command`; Windows `1_DOWNLOAD_ALL.bat`, then `2_FIX_WITH_BROWSER.bat`. Or ask the user to download the files in a browser.
4. If the network blocks a host entirely, say so plainly. Never report a refresh that did not happen. WebFetch can read pages but cannot store them.
5. After a refresh, re-extract the text, compare it with the previous version, and propose (don't apply) updates to the reference files. Apply them once the user agrees. Add a dated row to the status tracker in `jurisdiction-and-status.md`; append, never rewrite.

## Provider lookup (read-only)
`python3 scripts/check_provider_status.py "<name>"` searches the stored lists without downloading. Adding `--refresh` downloads, so it needs a go-ahead. Report the list's own "Last updated" date. Remember that an Art 51 listing means notified, not authorised.

## Adding a new document
When the user asks: add a manifest row (next ID in its category), download it, extract the text, add it to `document-catalogue.md`, and summarise it into the right reference file.
