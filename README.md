# Prateek Dwivedi — Academic CV

Source for my academic CV and standalone publication list, written in
[Typst](https://typst.app/) with content stored in YAML.

Both documents share the same publication records, so an update to a paper's
status, authors or links is reflected in both builds.

[Personal website](https://prateekdwivedi.in/)

## Build the documents

Requires **Typst 0.15.1**. Install the compiler from the
[official releases](https://github.com/typst/typst/releases/tag/v0.15.1)
and make sure `typst --version` works in your terminal.
No external Typst packages are needed. Libertinus Serif is included with Typst;
the repository includes Lohit Devanagari for Hindi text.

From the repository root, create the output directory and compile:

```powershell
New-Item -ItemType Directory -Force build | Out-Null

# Academic CV
typst compile --font-path . --pdf-standard ua-1 resume.typ build/resume.pdf

# Standalone publication list
typst compile --font-path . --pdf-standard ua-1 publication-list.typ build/publication.pdf
```

Generated PDFs are saved in `build/` and are not tracked by Git.

### Live preview

Use `watch` to rebuild a PDF whenever its sources change:

```powershell
typst watch --font-path . --pdf-standard ua-1 resume.typ build/resume.pdf
```

For the publication list, substitute `publication-list.typ` and
`build/publication.pdf`. Open the output in a PDF viewer that reloads changed files.
Stop watching with Ctrl+C.

### Complete CV archive

To include archived entries, additional personal details and supplementary links:

```powershell
typst compile --font-path . --pdf-standard ua-1 --input include-inactive=true resume.typ build/resume-all.pdf
```

The standalone publication list has one version. It includes all publication
records and available supplementary links, omits publisher labels, and uses the
same academic contact header as the standard CV.

## Edit the content

- **Profile and contact details:** `data/profile.yaml`.
- **CV sections:** the corresponding YAML file in `data/`.
- **Publications:** `data/publications.yaml`, shared by both documents.
- **Section order:** the file list in `cv-data.typ`.
- **Typography and layout:** `academic-cv.typ`.

Copy an existing entry in the relevant YAML file when adding content. Text fields
are plain text; dates should be quoted. Routine content edits require no changes
to the Typst template.

Publications are grouped by `category` and sorted by numeric `sort-year`, newest
first. Add presentations of an existing talk to its `children` list rather than
repeating the title.

Set `active: false` to archive an entry, or `application: false` to keep it out of
the standard CV. The complete archive includes both. Commented-out YAML is never
rendered.

## Project structure

| Path | Purpose |
| --- | --- |
| `data/` | Shared CV content in YAML |
| `cv-data.typ` | Loads content and defines section order |
| `academic-cv.typ` | Shared document template |
| `resume.typ` | CV entry point |
| `publication-list.typ` | Publication-list entry point |
| `build/` | Generated PDFs (ignored by Git) |

## Accessibility

The build commands enable PDF/UA-1 checks. The PDFs include semantic headings,
bookmarks, clickable links and language tagging for English and Hindi.
Screen-reader behaviour and Hindi copy/paste still require manual verification;
successful compilation alone does not establish full accessibility compliance.
