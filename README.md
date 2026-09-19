# Prateek Dwivedi — CV

This branch contains the complete CV in Typst, with its content separated from a
plain renderer. Template selection and visual design are deferred.

The migration baseline is `main` at
`6630d80569504064bb21b0e5d4d3eeada4f922b6`. The original `resume.tex`,
`resume.cls`, `resume.pdf`, and `Lohit-Devanagari.ttf` are retained unchanged.
The LaTeX source is the historical baseline; subsequent Typst content edits go
in `cv-data.typ` and are not automatically synchronized back to LaTeX.

## Setup and build

Tested with **Typst 0.15.1 (9dfd3a08)** on Windows. Download the compiler for your
platform from the [official releases](https://github.com/typst/typst/releases/tag/v0.15.1),
extract it, and put the executable's directory on your `PATH`. Confirm with
`typst --version`. No LaTeX installation, Python, or external Typst package is
required to build the CV.

Run these commands from the repository root in PowerShell:

```powershell
New-Item -ItemType Directory -Force build | Out-Null
typst compile --font-path . resume.typ build/resume.pdf
typst watch --font-path . resume.typ build/resume.pdf
```

The watch command keeps running; stop it with Ctrl+C. To include archived content:

```powershell
typst compile --font-path . --input include-inactive=true resume.typ build/resume-all.pdf
```

`include-inactive` accepts `true` or `false` and defaults to `false`. Generated
files belong in the ignored `build/` directory. The PDF at the repository root
is the original LaTeX reference, so use the explicit output paths above.

`--font-path .` discovers the bundled Lohit Devanagari font. The renderer uses
Typst's bundled New Computer Modern font for Latin text. You can check font
discovery with `typst fonts --font-path .`. Compilation works offline once the
compiler is available.

A portable compiler used during this migration is available locally at
`build/tools/typst-x86_64-pc-windows-msvc/typst.exe`. If Typst is not on your PATH,
replace `typst` in the commands above with
`& ./build/tools/typst-x86_64-pc-windows-msvc/typst.exe`. This ignored local tool
is not included in a fresh clone.

## Editing content

- `cv-data.typ` exports one `cv` dictionary containing `profile` and ordered
  `sections`. Each section has a `title`, a rendering `kind`, and an `entries`
  array. Entry order is preserved; there is no automatic sorting or deduplication.
- `resume.typ` handles presentation, links, and the active/inactive filter.
  Routine edits to names, dates, publications, and descriptions require only
  the data file. A future template can import the same `cv` dictionary.
- Entries use semantic fields such as `institution`, `role`, `dates`, `authors`,
  `venue`, `description`, `url`, and nested `children`. Copy an existing entry
  from the same section when adding one. Introducing a new section kind requires
  a corresponding renderer; unknown kinds fail explicitly.
- Dates remain strings so their original wording is retained. Ordinary text is
  stored in strings. Use Typst content blocks for meaningful emphasis or
  superscripts, for example `[21#super[st]]`. Keep fonts, colors, dimensions,
  and positioning in the renderer.

Example active publication, to add to the publications array:

```typst
(
  title: "Publication title",
  dates: "2026",
  authors: "with Collaborator Name",
  venue: "Venue or submission status",
  url: "https://example.org/paper",
),
```

An entry is active unless it has `active: false`. To retain an entry without
showing it in the default PDF, add that field:

```typst
(
  active: false,
  title: "Archived publication title",
  dates: "2020",
  authors: "with Collaborator Name",
  venue: "Original venue",
),
```

Whole sections can also be inactive. An entry appears in the default PDF only
when both it and its section are active. The archived course, project, and skill
sections have inactive flags on both the section and its entries; remove or
change both flags when reactivating them. Nested entries support the same flag.
The inclusive build renders all retained entries in source order.

## Migration audit

The migration preserved all 11 active sections, their header information,
wording, dates, links, repetitions, and nested entries. Substantive commented-out
material was migrated as inactive data. Generic template examples and formatting
boilerplate were excluded.

| Content | Active | Inactive |
| --- | ---: | ---: |
| Publications | 8 | 0 |
| Top-level talks | 8 | 0 |
| Short-term visits | 16 | 0 |
| References | 3 | 1 |
| Relevant courses | 0 | 9 |
| Projects | 0 | 3 |
| Technical-strength entries | 0 | 2 |

Validation performed with Typst 0.15.1 and PyMuPDF 1.28.2:

- Compared the full ordered text of the exported Typst data with the LaTeX
  source for both active-only and inclusive content. Both matched after
  converting LaTeX markup to text and normalizing whitespace and Unicode.
- Compiled and visually inspected the 4-page active PDF and the 5-page inclusive
  PDF. Checked page bounds, Hindi shaping, accented names, superscripts, and
  nested lists. Short entries stay together across page breaks.
- Compared extracted PDF text and link destinations with the source. All 12
  distinct active URLs and the additional inactive reference URL were preserved.
  The only extracted-text differences were the Hindi surname issue below.
- Confirmed inactive data is excluded by default, a data-only edit renders with
  the unchanged renderer, and invalid `include-inactive` values fail clearly.
- Verified that the original LaTeX files, PDF, and font match the baseline.

### Known PDF text-extraction limitation

The data contains the correct `प्रतीक द्विवेदी`, and the PDF renders it correctly.
However, with this font and compiler, PyMuPDF extracts the surname as
`द्विवेवेदी` at both occurrences, duplicating `वे`. Hindi PDF copy/paste therefore
does not pass exact text parity. This is consistent with the open upstream
[Typst complex-shaping extraction issue](https://github.com/typst/typst/issues/4225).
All other extracted text matches the source after whitespace normalization.
Use the data module for exact text, and recheck PDF extraction when updating Typst.

### Existing content retained for later review

- `STOC 2025` appears twice in the conference-reviewing list.
- The thesis-defense talk is dated 2022, while education lists the PhD through 2025.
- Some publication years differ from their venue years, and submission or
  review-status wording may need a later content update.
- The conference-reviewing list has no comma between the source lines ending
  `ISSAC 2023` and beginning `STOC 2023`; the lines are retained separately.
- The commented technical-strength entries contain literal ampersands before
  their values. Those characters are retained in the inactive data.

These items were preserved without editorial correction. Content updates,
template selection, bibliography conversion, and publishing are separate work.
