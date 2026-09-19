# Prateek Dwivedi — CV

The CV uses Typst with content separated from a plain renderer. Template selection
and visual design are deferred.

## Files

- `data/profile.yaml`: name and contact information.
- `data/*.yaml`: one file per CV section, including inactive entries.
- `cv-data.typ`: loads the YAML files in order.
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

Edit the relevant file under `data/` for routine changes, for example
`data/publications.yaml` or `data/teaching.yaml`. Each section file has a `title`,
a rendering `kind`, and an `entries` list. Copy an existing entry from the same
section when adding one. Order, dates, wording, and repeated entries are preserved
as entered. Typst reads YAML directly; no conversion command is needed.

`cv-data.typ` lists section files in their display order and exports the assembled
`cv` dictionary to the renderer. To reorder sections, change that list. To add a
section, create its YAML file and add it to the list. Inactive sections stay listed
so they remain available to the inclusive build.

For example, a publication entry has this shape:

```yaml
title: Publications
kind: publication
entries:
  - title: Publication title
    dates: "2026"
    authors: with Collaborator Name
    venue: Venue or submission status
    url: https://example.org/paper
```

Add `active: false` to keep an entry without displaying it in the default PDF.
Sections and nested entries support the same flag. An entry is shown only when
both it and its section are active. To reactivate archived courses, projects,
or skills, remove or change the inactive flags on both the section and its entries.
The inclusive build shows all retained content.

Use spaces for indentation. Quote dates, phone numbers, and strings containing
`: `, ending in `:`, or beginning with YAML punctuation. Long prose can use `>-` to wrap source
lines into a single paragraph without adding a trailing newline. Keep
`active: false` as a boolean, without quotes.

Text fields contain plain strings. YAML text is literal: Markdown and Typst
expressions are not evaluated. Formatting can be decided in a future template.
A new section kind needs a corresponding renderer; a future template can import
the same `cv` dictionary.

## Known PDF text-extraction limitation

Hindi renders correctly, but with Typst 0.15.1 and Lohit Devanagari, PDF text
extraction can produce `द्विवेवेदी` instead of `द्विवेदी`. The data module contains
the correct spelling. This is consistent with the
[Typst complex-shaping extraction issue](https://github.com/typst/typst/issues/4225).
Recheck copy/paste when updating Typst.
