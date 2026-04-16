# FilmTagger

FilmTagger is a metadata workflow tool for film scans and other image files.

It currently includes two versions:

## Versions

### 🌐 Web Version
- Runs in browser
- No install required
- Limited to browser capabilities

👉 See `/web`

### 🖥️ AutoHotkey Version [not actively maintained]
- Windows desktop tool
- Uses ExifTool directly
- More powerful metadata control
- — the original Windows desktop workflow that came before the website

👉 See `/ahk`

## Why this project exists

Film scans often lose useful metadata such as:

- camera body
- lens
- film stock
- ISO
- date taken
- GPS / location
- keywords and tags

FilmTagger helps restore and standardize that metadata for archiving, searching, and consistent file naming.

## Project structure

```text
web/   -> browser-based FilmTagger
ahk/   -> original AutoHotkey desktop version
