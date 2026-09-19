# Prateek Dwivedi — CV

The CV uses Typst with content separated from a plain renderer. Template selection
and visual design are deferred.

## Files

- `cv-data.typ`: all CV content, including inactive entries.
- `resume.typ`: rendering and active/inactive filtering.
- `Lohit-Devanagari.ttf`: the font used for Hindi text.

## Build

Tested with **Typst 0.15.1**. Download the compiler from the
[official releases](https://github.com/typst/typst/releases/tag/v0.15.1), extract it,
and put the executable's directory on your `PATH`. Confirm with `typst --version`.
No external Typst packages are required.

Run from the repository root in PowerShell:

```powershell
New-Item -ItemType Directory -Force build | Out-Null
typst compile --font-path . resume.typ build/resume.pdf
```

Rebuild automatically while editing (stop with Ctrl+C):

```powershell
typst watch --font-path . resume.typ build/resume.pdf
```

Include archived content:

```powershell
typst compile --font-path . --input include-inactive=true resume.typ build/resume-all.pdf
```

`include-inactive` accepts `true` or `false` and defaults to `false`.
Generated files belong in the ignored `build/` directory. `--font-path .` loads the
bundled Hindi font; New Computer Modern for Latin text is bundled with Typst.

## Edit content

Edit `cv-data.typ` for routine changes. It exports a `cv` dictionary containing
`profile` and ordered `sections`. Each section has a `title`, a rendering `kind`,
and an `entries` array. Copy an existing entry from the same section when adding
one. Order, dates, wording, and repeated entries are preserved as entered.

For example, a publication entry has this shape:

```typst
(
  title: "Publication title",
  dates: "2026",
  authors: "with Collaborator Name",
  venue: "Venue or submission status",
  url: "https://example.org/paper",
),
```

Add `active: false` to keep an entry without displaying it in the default PDF.
Sections and nested entries support the same flag. An entry is shown only when
both it and its section are active. To reactivate archived courses, projects,
or skills, remove or change the inactive flags on both the section and its entries.
The inclusive build shows all retained content.

Keep dates as strings. Use content blocks for emphasis and superscripts, such as
`[21#super[st]]`. Keep fonts, colors, spacing, and layout in `resume.typ`.
A new section kind needs a corresponding renderer; a future template can import
the same data module.

## Known PDF text-extraction limitation

Hindi renders correctly, but with Typst 0.15.1 and Lohit Devanagari, PDF text
extraction can produce `द्विवेवेदी` instead of `द्विवेदी`. The data module contains
the correct spelling. This is consistent with the
[Typst complex-shaping extraction issue](https://github.com/typst/typst/issues/4225).
Recheck copy/paste when updating Typst.
