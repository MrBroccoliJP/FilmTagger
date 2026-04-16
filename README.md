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

⚠️ **Important (ExifTool required)**

The AutoHotkey version depends on ExifTool and will **not work without it**.

You must either:

1. Download ExifTool from the official website and place `exiftool.exe` in the **same folder** as the compiled `.exe`

**or**

2. Install ExifTool and make it available in your system **PATH**

👉 https://exiftool.org/

If ExifTool is not found, metadata operations will fail.

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

This makes it very hard to organize and filter in a digital world with cloud providers as google photos or self hosted options as immich

FilmTagger helps restore and standardize that metadata for archiving, searching, and consistent file naming.

## How it works

1. Open `index.html` in a modern browser
2. Add image files
3. Parse EXIF
4. Select rows and stage changes from the side panels
5. Export all staged files as a ZIP

## Notes

- JPEG files receive in-browser EXIF edits
- Other file types can still be renamed and added to the ZIP, but EXIF editing is currently focused on JPEG output
- All processing happens locally in the browser

## Tech stack

- HTML
- CSS
- Vanilla JavaScript
- exifr
- piexifjs
- JSZip

## Third-party libraries

This project uses:
- exifr — MIT
- piexifjs — MIT
- JSZip — MIT or GPLv3, used here under the MIT option

See `THIRD_PARTY_NOTICES.md` for details.

## License

MIT

## Author

Built by [MrBroccoliJP](https://github.com/MrBroccoliJP)

## Project structure

```text
web/   -> browser-based FilmTagger
ahk/   -> original AutoHotkey desktop version
