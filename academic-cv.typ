// Presentation only: the caller supplies the complete CV dictionary.
#let academic-cv(cv, include-inactive: false, body) = {
  let ink = rgb("242424")
  let muted = rgb("555555")
  let link-color = rgb("24465C")
  let date-width = 27mm
  let gutter = 4mm
  // Separate levels of information: related rows, entries, and titled groups.
  let row-gap = 7pt
  let entry-gap = 14pt
  let group-gap = 18pt
  let title-gap = 8pt
  let visible(record) = include-inactive or (
    record.at("active", default: true) and record.at("application", default: true)
  )
  let linked(label, record) = if "url" in record { link(record.url, label) } else { label }
  let email(address) = link("mailto:" + address, address)
  // The original index explicitly preserves the source order for equal years.
  let chronological(records) = records.enumerate().sorted(
    key: pair => (-pair.at(1).at("sort-year", default: 0), pair.at(0)),
  ).map(pair => pair.at(1))
  let lines(items) = items.join(linebreak())
  let supplementary(entry) = {
    if include-inactive {
      let links = entry.at("links", default: ()).filter(visible)
      if links.len() > 0 {
        [#linebreak()#text(size: 9.5pt, links.map(item => link(item.url, item.label)).join([ · ]))]
      }
    }
  }

  set document(title: cv.profile.name + " — Curriculum Vitae", author: cv.profile.name)
  set page(
    paper: "a4",
    margin: (x: 19mm, y: 18mm),
    footer: context text(size: 9pt, fill: muted)[
      #cv.profile.name #h(1fr)#counter(page).display("1 / 1", both: true)
    ],
    footer-descent: 8mm,
  )
  set text(font: "Libertinus Serif", size: 11pt, fill: ink, lang: "en", hyphenate: false)
  show regex("[\u0900-\u097F]+"): set text(font: "Lohit Devanagari", lang: "hi")
  set par(justify: false, leading: 0.65em, spacing: 0.4em)
  set list(indent: 3mm, body-indent: 2mm, spacing: 2pt)
  set heading(numbering: none, outlined: true)
  show heading: it => block(above: 16pt, below: 0pt, inset: (bottom: 12pt), sticky: true)[
    #text(size: 12pt, weight: "bold", it.body)
  ]
  show link: set text(fill: link-color)

  // Category labels share one style and follow each section's content column.
  let subheading(title, label-width: date-width, first: true) = {
    block(above: if first { 0pt } else { 14pt }, below: 0pt, inset: (bottom: 8pt), sticky: true)[
      #grid(columns: (label-width, 1fr), column-gutter: gutter,
        [], text(size: 11pt, fill: muted, weight: "bold", title))
    ]
  }

  // Each row can paginate if its body grows; short records stay together.
  let row(label, content, label-width: date-width, bottom: entry-gap) = context layout(size => {
    let long = measure(content, width: size.width - label-width - gutter).height > 55mm
    block(above: 0pt, below: 0pt, inset: (bottom: bottom), breakable: long)[
      #grid(
        columns: (label-width, 1fr),
        column-gutter: gutter,
        align: (right + top, left + top),
        text(size: 9.5pt, fill: muted, label),
        content,
      )
    ]
  })
  let dated(entry, content) = row(entry.at("dates", default: ""), content)

  let children(entry) = {
    let nested = entry.at("children", default: ()).filter(visible)
    for (index, child) in nested.enumerate() {
      let label = if "courses" in child { child.courses.join(", ") } else {
        child.at("title", default: child.at("venue", default: ""))
      }
      let content = [#linked(label, child)#if "role" in child { [ (#child.role)] }#if "platform" in child { [ · #child.platform] }#supplementary(child)]
      row(child.at("dates", default: ""), content,
        bottom: if index == nested.len() - 1 { group-gap } else { row-gap })
      children(child)
    }
  }

  let appointment(entry) = {
    let detail = (strong(entry.role), linked(entry.institution, entry) + [ · #entry.location])
    if "department" in entry { detail.push(entry.department) }
    if "thesis" in entry {
      if "title" in entry.thesis {
        detail.push([Thesis: #emph(linked(entry.thesis.title, entry.thesis))])
      }
      let milestones = entry.thesis.at("milestones", default: ())
      if milestones.len() > 0 {
        detail.push(milestones.map(item => [#item.label: #item.date]).join([ · ]))
      }
    }
    if "adviser" in entry {
      let adviser = entry.adviser
      detail.push([#adviser.at("label", default: "Adviser:") #linked(adviser.name, adviser)])
    }
    if include-inactive {
      if "qualification-level" in entry { detail.push([Level in EQF: #entry.qualification-level]) }
      if "email" in entry { detail.push([Email: #email(entry.email)]) }
      if "sector" in entry { detail.push([Business or sector: #entry.sector]) }
    }
    dated(entry, [#lines(detail)#supplementary(entry)])
    children(entry)
  }

  let publication(entry, number) = {
    let venue = if include-inactive { entry.venue } else { entry.at("application-venue", default: entry.venue) }
    let year-shown = venue.contains(entry.dates) or venue.contains("’" + entry.dates.slice(2)) or entry.at("note", default: "").contains(entry.dates)
    let detail = (
      entry.authors,
      [#emph(venue)#if not year-shown { [ · #entry.dates] }],
    )
    if "note" in entry { detail.push(entry.note) }
    if include-inactive and "publisher" in entry { detail.push([Publisher: #entry.publisher]) }
    row([\[#number\]], [
      #strong(linked(entry.title, entry))
      #linebreak()
      #v(3pt)
      #lines(detail)#supplementary(entry)
    ], label-width: 9mm)
  }

  let reference(entry) = {
    let detail = (
      strong(linked(entry.name, entry)),
      entry.role,
      entry.institution,
      email(entry.email),
    )
    lines(detail)
  }

  let references(entries) = {
    for index in range(0, entries.len(), step: 2) {
      let pair = entries.slice(index, calc.min(index + 2, entries.len()))
      block(above: 0pt, below: 0pt,
        inset: (bottom: if index + 2 >= entries.len() { 0pt } else { 10pt }), breakable: false)[
        #grid(columns: (1fr, 1fr), column-gutter: 12mm, align: left + top,
          ..pair.map(reference))
      ]
    }
  }

  let generic-entry(kind, entry, first: true) = {
    if kind == "prose" {
      block(above: 0pt, below: 4pt)[#entry.description#supplementary(entry)]
    } else if kind == "detail" {
      block(above: 0pt, below: 4pt)[#strong(entry.label): #entry.value#supplementary(entry)]
    } else if kind == "language" {
      let details = ()
      if "proficiency" in entry { details.push(entry.proficiency) }
      for (skill, level) in entry.at("skills", default: (:)) { details.push([#skill: #level]) }
      block(above: 0pt, below: 4pt)[#strong(entry.language) · #details.join([; ])]
    } else if kind == "project" {
      dated(entry, lines((
        strong(entry.title),
        [#entry.category #entry.institution],
        entry.adviser,
        entry.description,
      )))
    } else if kind == "contribution" {
      let activities = chronological(entry.at("activities", default: ()).filter(visible))
      let reviewing = entry.at("reviewing", default: ()).filter(visible).sorted(key: item => -item.year)
      subheading(entry.title, first: first)
      for (index, activity) in activities.enumerate() {
        let details = (strong(linked(activity.title, activity)),)
        let metadata = ()
        for field in ("role", "acronym", "location") {
          if field in activity { metadata.push(activity.at(field)) }
        }
        if metadata.len() > 0 { details.push(metadata.join([ · ])) }
        if "description" in activity { details.push(activity.description) }
        row(activity.at("dates", default: ""),
          [#lines(details)#supplementary(activity)], bottom: entry-gap)
      }
      for (index, record) in reviewing.enumerate() {
        let venues = if "journals" in record {
          record.journals.map(journal => [#journal.acronym · #journal.name]).join(", ")
        } else { record.conferences.join(", ") }
        row(str(record.year), venues,
          bottom: if index == reviewing.len() - 1 { entry-gap } else { 2pt })
      }
      let details = entry.at("descriptions", default: ())
      if details.len() > 0 {
        block(above: 0pt, below: 0pt, inset: (bottom: entry-gap))[
          #lines(details)#supplementary(entry)
        ]
      }
    } else if kind in ("visit", "achievement", "teaching", "course") {
      let details = (strong(linked(entry.title, entry)),)
      for field in ("venue", "location", "host", "description") {
        if field in entry { details.push(entry.at(field)) }
      }
      details += entry.at("descriptions", default: ())
      if entry.at("children", default: ()).filter(visible).len() > 0 {
        block(above: 0pt, below: 0pt, inset: (bottom: title-gap), sticky: true)[
          #grid(
            columns: (date-width, 1fr), column-gutter: gutter,
            align: (right + top, left + top),
            text(size: 9.5pt, fill: muted, entry.at("dates", default: "")),
            [#lines(details)#supplementary(entry)],
          )
        ]
      } else {
        dated(entry, [#lines(details)#supplementary(entry)])
      }
    } else {
      panic("Unknown section kind: " + kind)
    }
    children(entry)
  }

  // Sort explicit date metadata, keeping source order for ties and unknown months.
  let talk-date(entry) = (entry.at("sort-year", default: 0), entry.at("sort-month", default: 0))
  let talks(entries) = {
    let groups = entries.map(entry => {
      let occurrences = entry.children.filter(visible).enumerate().sorted(key: pair => {
        let date = talk-date(pair.at(1))
        (-date.at(0), -date.at(1), pair.at(0))
      }).map(pair => pair.at(1))
      entry + (children: occurrences)
    }).filter(entry => entry.children.len() > 0)
    groups.enumerate().sorted(key: pair => {
      let date = talk-date(pair.at(1).children.first())
      (-date.at(0), -date.at(1), pair.at(0))
    }).map(pair => pair.at(1))
  }

  let talk-group(entry) = {
    block(above: 0pt, below: 0pt, inset: (bottom: title-gap), sticky: true)[
      #grid(columns: (date-width, 1fr), column-gutter: gutter,
        [], [#strong(linked(entry.title, entry))#supplementary(entry)])
    ]
    for (index, occurrence) in entry.children.enumerate() {
      let details = (linked(occurrence.venue, occurrence),)
      for field in ("location", "host", "description") {
        if field in occurrence { details.push(occurrence.at(field)) }
      }
      details += occurrence.at("descriptions", default: ())
      row(occurrence.at("dates", default: ""),
        [#lines(details)#supplementary(occurrence)],
        bottom: if index == entry.children.len() - 1 { group-gap } else { row-gap },
      )
    }
  }

  block(above: 0pt, below: 10pt, breakable: false)[
    #align(center)[
      #text(size: 25pt, weight: "bold", cv.profile.name)
      #linebreak()
      #text(size: 12pt, cv.profile.alternate-name)
    ]
    #v(8pt)
    #text(size: 10pt)[
      #grid(columns: (1fr, 1fr), column-gutter: 8mm,
        align: (left + top, right + top),
        lines(cv.profile.address.split("\n")),
        {
          let contacts = (email(cv.profile.email),)
          for address in cv.profile.at("additional-emails", default: ()) {
            contacts.push(email(address))
          }
          if include-inactive and "personal-email" in cv.profile {
            contacts.push(email(cv.profile.personal-email))
          }
          contacts.push(link(cv.profile.website.url, cv.profile.website.label))
          if include-inactive and "phone" in cv.profile { contacts.push(cv.profile.phone) }
          lines(contacts)
        },
      )
    ]
    #v(6pt)
    #line(length: 100%, stroke: 0.5pt + ink)
  ]

  for section in cv.sections.filter(visible) {
    let entries = section.entries.filter(visible)
    if section.kind == "publication" { entries = chronological(entries) }
    if section.kind == "talk" { entries = talks(entries) }
    if entries.len() > 0 {
      let title = if include-inactive { section.title } else { section.at("application-title", default: section.title) }
      heading(level: 1, title)
      if section.kind == "reference" {
        references(entries)
      } else if section.kind == "publication" {
        let number = 0
        for group in section.groups {
          let records = entries.filter(entry => entry.category == group.id)
          if records.len() > 0 {
            subheading(group.title, label-width: 9mm, first: number == 0)
            for entry in records {
              number += 1
              publication(entry, number)
            }
          }
        }
      } else {
        for (index, entry) in entries.enumerate() {
          if section.kind == "appointment" { appointment(entry) }
          else if section.kind == "talk" { talk-group(entry) }
          else { generic-entry(section.kind, entry, first: index == 0) }
        }
      }
    }
  }
  body
}
