# Prateek Dwivedi — CV

An academic CV for research faculty and postdoctoral applications in mathematics
and theoretical computer science. YAML holds the master content; a reusable Typst
template produces a selected application CV or an inclusive master CV.

## Files

- `data/profile.yaml`: name and contact information.
- `data/*.yaml`: one file per CV section, including inactive entries.
- `cv-data.typ`: loads the YAML files in order.
- `resume.typ`: build input validation and template entry point.
- `academic-cv.typ`: typography, layout, selection, and rendering components.
- `Lohit-Devanagari.ttf`: the font used for Hindi text.

## Build

Tested with **Typst 0.15.1**. Download the compiler from the
[official releases](https://github.com/typst/typst/releases/tag/v0.15.1), extract it,
and put the executable's directory on your `PATH`. Confirm with `typst --version`.
No external Typst packages are required.

Run from the repository root in PowerShell:

```powershell
New-Item -ItemType Directory -Force build | Out-Null
typst compile --font-path . --pdf-standard ua-1 resume.typ build/resume.pdf
```

Rebuild automatically while editing (stop with Ctrl+C):

```powershell
typst watch --font-path . --pdf-standard ua-1 resume.typ build/resume.pdf
```

Include all structured master content, including archived entries:

```powershell
typst compile --font-path . --pdf-standard ua-1 --input include-inactive=true resume.typ build/resume-all.pdf
```

`include-inactive` accepts `true` or `false` and defaults to `false`. The default
build is the application CV. `true` bypasses both `active` and `application`
filters, includes supplementary links and contact fields, and uses the original
section titles. YAML comments are not entries and never appear in either build.
Generated files belong in the ignored `build/` directory. `--font-path .` loads the
bundled Hindi font; Libertinus Serif for Latin text is bundled with Typst.

## Edit content

Edit the relevant file under `data/` for routine changes, for example
`data/publications.yaml` or `data/teaching.yaml`. Each section file has a `title`,
a rendering `kind`, and an `entries` list. Copy an existing entry from the same
section when adding one. Typst reads YAML directly; no conversion command is needed.

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
    sort-year: 2026
    dates: "2026"
    authors: with Collaborator Name
    venue: Venue or submission status
    url: https://example.org/paper
```

Add `active: false` for archived content, or `application: false` for current
content deliberately omitted from applications. Both flags default to `true`;
sections, entries, and nested occurrences support them. The application build
requires both flags to be true at every ancestor. For example:

```yaml
  - title: An older award kept in the master CV
    dates: "2014"
    application: false
```

`application-title` optionally supplies a section's application heading;
`application-venue` optionally supplies an expanded publication venue. The original
values remain available to the master build.

Publications are sorted by numeric `sort-year`, newest first, preserving YAML
order within a year. Set this field on each new publication. Other sections
follow their YAML order, except talks as described below.

Both builds show each talk title once, with dated venues beneath it. Add another
presentation to the existing title's `children` list, rather than repeating the
title. Use this structure even for a talk presented only once:

```yaml
  - title: Talk title
    children:
      - venue: University or conference
        dates: "Mar 2026"
        sort-year: 2026
        sort-month: 3
```

Each occurrence may also have a `description`, a venue `url`, supplementary
`links`, or inclusion flags. Set numeric `sort-year` and, when known, `sort-month`
(1–12) on each occurrence. For unknown months, use a year-only `dates` value and
omit `sort-month`. Occurrences sort newest first, with unknown months after known
months within the same year; ties preserve YAML order. Groups sort by their latest
visible occurrence. No dates are inferred from text. A group with no visible
occurrences is omitted. The inclusive build bypasses both inclusion filters.

Use spaces for indentation. Quote dates, phone numbers, and strings containing
`: `, ending in `:`, or beginning with YAML punctuation. Long prose can use `>-` to wrap source
lines into a single paragraph without adding a trailing newline. Keep
`active: false` as a boolean, without quotes.

Text fields contain plain strings. YAML text is literal: Markdown and Typst
expressions are not evaluated. Text styling belongs in `academic-cv.typ`.
A new section kind needs a corresponding renderer. The reusable template accepts
`academic-cv(cv, include-inactive: false, body)` and reads no data files itself.

## Application selection and layout

The application order is research interests, appointments, education, publications,
fellowships and research support, teaching and mentoring, talks, short term
visits, academic service, and references. Education lists thesis submission and
defence dates; the full thesis title and link appear only in the publication
section's combined thesis/survey category.
Publication records have an explicit `category`: `published`, `preprint`, or
`thesis-survey`. The `groups` list in `data/publications.yaml` controls their
headings and order. Each group is reverse chronological, with continuous numbering
across groups: seven published/accepted papers, one submitted manuscript, and two
thesis/survey records. Submission and acceptance status are retained.
Supplementary publication links and publisher
fields are displayed only in the master build.

The application omits personal particulars, personal email and phones, language
tables, and archived courses/projects/skills. These are retained in YAML.
All awards and achievements are included, including entrance-exam ranks and
undergraduate achievements. All talks are included, including examination
and departmental presentations. The talks section contains eight titles and 14
distinct presentations; Georgetown appears once in both builds. All visits are included,
including conference, workshop, and school attendance. All reviewer conference/year
entries and four referees remain.

The template uses A4, 19 mm side margins, 18 mm vertical margins, 11 pt Libertinus
Serif, 12 pt headings, and a 27 mm date column with a 4 mm gap. Publications use a
9 mm number column. The bilingual header, fine rule, and muted blue links provide
the visual identity. Change these presentation settings in the template only.
Short records stay together; long records and nested lists can cross pages. No
fixed page count or section-specific page breaks are used.

Spacing is controlled by named values near the top of `academic-cv.typ`: 6 pt
between related rows, 11 pt between ordinary entries, 15 pt between titled groups
and 8 pt below group titles. Section headings have 16 pt above and
12 pt of bottom padding. Paragraph leading stays at 0.65 em; extra space separates
records rather than spreading out every line. Publication titles have an additional
3 pt gap before their authors and venue details.

References use two equal-width columns with a 12 mm gutter, in source order
across each row. Each pair stays together across page breaks, with 10 pt between
rows and no trailing padding after the final row. Reviewing years have 2 pt
between rows. Names and emails remain clickable; roles and affiliations wrap naturally.

## PDF accessibility

Use the PDF/UA-1 build commands above. Typst also produces tagged PDFs without
that flag, but `--pdf-standard ua-1` enables additional compiler checks. A passing
build alone does not establish full accessibility or PDF/UA conformance.

Main sections are semantic level-one headings; publication and service categories
are level-two headings. Both levels appear in PDF bookmarks. Styling preserves
the complete heading element. Paper titles, teaching roles and talk titles remain
entry text. The document language is English, with the entire Hindi name explicitly
marked as Hindi. Layout grids retain source order: date then content, publication
number then record, and each referee's full details before the next referee.
Typst automatically treats the repeated page footer as an artifact.

Local validation with Typst 0.15.1:

- Both PDF/UA-1 builds complete without diagnostics. The application has 10 H1
  and 6 H2 tags; the inclusive version has 15 H1 and 6 H2 tags. Category bookmarks
  are children of the appropriate section bookmarks.
- All five application pages and all seven inclusive pages render identically
  to their pre-accessibility baselines (PNG hash comparison at 80 and 65 ppi,
  respectively), preserving typography and page breaks.
- All 42 application and 52 inclusive URI annotations match the baseline,
  including publication links and clickable email addresses.
- PDF stream inspection confirms Hindi language tags, Unicode replacement text
  for shaped Devanagari clusters, and footer artifact markers. These checks do
  not substitute for reader copy/paste or screen-reader testing.
- Contrast against white is 15.52:1 for body text (`#242424`), 7.46:1 for muted
  text (`#555555`), and 9.97:1 for links (`#24465C`), above 4.5:1.

Outstanding manual validation: use a tagged-PDF-capable reader and screen reader
to navigate headings and links, read representative dated entries and all four
referees, and copy/paste Hindi and accented names. Confirm the full Hindi name
including its space and conjuncts is preserved; pronunciation also depends on
the installed Hindi voice. No reader-based extraction, interactive screen-reader
test, or independent PDF/UA validator was available in this validation session.
Do not claim certified or complete accessibility until those checks are completed.
Keep validation local rather than uploading personal CV data to online services.

References: [Typst PDF export](https://typst.app/docs/reference/pdf/),
[accessibility guide](https://typst.app/docs/guides/accessibility/), and
[artifact handling](https://typst.app/docs/reference/pdf/artifact/).

## Content notes for future review

Main section headings use 12 pt bold text at the page margin. Publication and
Academic Service category labels share the `subheading` component: 11 pt bold,
dark grey, aligned with the section's content column, with 8 pt below and kept
with the first entry. Subsequent categories have an additional 14 pt above.
Entry titles remain 11 pt bold.

- The PhD period is **2018–2025**, through the defence. The thesis was submitted in **2024**
  and defended in **March 2025**, confirmed by the author; Education explicitly
  distinguishes these milestones. The master publication list retains the thesis's
  separate **2025** record. The defence talk also remains dated **March 2025**.
- The Adhyayan summer-school teaching took place in **2023**, confirmed by the
  author. Both its date and description now consistently show 2023.
- Talk months are recorded when confirmed by the author or supported by dated
  event announcements or programmes; source URLs for online verification are
  comments beside the dates in `data/talks.yaml`.
  Months remain unverified for Georgetown (2021),
  the comprehensive evaluation (2020), and SIGTACS
  (2019). These entries retain their stored years.

## Template verification

The initial template was verified with Typst 0.15.1: the application had four pages
and the inclusive master had six. Every page was visually inspected. The content audit confirmed
nine application research works, four referees, every reviewer conference/year,
and preservation of all original structured values and URLs. Publication and
contact link annotations, text bounds, and accented text extraction were checked.
A long publication title and an 80-item nested list compiled across pages;
nested selection flags were checked in both builds. Page counts may change as
the YAML content grows.

## Known PDF text-extraction limitation

Hindi renders correctly, but with Typst 0.15.1 and Lohit Devanagari, PDF text
extraction can produce `द्विवेवेदी` instead of `द्विवेदी`. The data module contains
the correct spelling. This is consistent with the
[Typst complex-shaping extraction issue](https://github.com/typst/typst/issues/4225).
Recheck copy/paste when updating Typst.
