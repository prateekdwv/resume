#import "cv-data.typ": cv

// A plain content preview. Replace this renderer when choosing a CV template.
#let include-inactive = sys.inputs.at("include-inactive", default: "false")
#assert(include-inactive in ("true", "false"), message: "include-inactive must be true or false")
#let visible(record) = include-inactive == "true" or record.at("active", default: true)
#let linked(label, record) = if "url" in record { link(record.url, label) } else { label }
#let dated(body, record) = if "dates" in record { [#body #h(0.75em)#emph(record.dates)] } else { body }

#set document(title: cv.profile.name + " — CV", author: cv.profile.name)
#set page(paper: "us-letter", margin: 0.75in)
#set text(font: ("New Computer Modern", "Lohit Devanagari"), size: 11pt, lang: "en", hyphenate: false)
#show regex("[\u0900-\u097F]+"): set text(font: "Lohit Devanagari", lang: "hi")
#set par(justify: false)
#set heading(numbering: none)

#let render-entry(kind, entry) = {
  let lines = ()
  if kind == "prose" {
    lines.push(entry.description)
  } else if kind == "appointment" {
    lines.push([#strong(entry.institution) #h(0.75em)#emph(entry.location)])
    lines.push(dated(entry.role, entry))
    lines.push(entry.department)
    if "thesis" in entry {
      let thesis = entry.thesis
      lines.push([#thesis.label #emph(thesis.title) \[#link(thesis.url, thesis.link-label)\]])
    }
    if "adviser" in entry {
      lines.push([#entry.adviser.label #linked(entry.adviser.name, entry.adviser)])
    }
  } else if kind == "publication" {
    lines.push(dated(strong(linked(entry.title, entry)), entry))
    lines.push(entry.authors)
    lines.push(emph(entry.venue))
    if "note" in entry { lines.push(emph(entry.note)) }
  } else if kind in ("talk", "visit", "achievement", "teaching", "contribution", "course") {
    let title = if kind in ("teaching", "contribution") { strong(entry.title) } else { entry.title }
    lines.push(dated(title, entry))
    for field in ("venue", "location", "host", "description") {
      if field in entry { lines.push(emph(entry.at(field))) }
    }
    for description in entry.at("descriptions", default: ()) {
      lines.push(description)
    }
  } else if kind == "detail" {
    lines.push([#entry.label #h(0.75em)#entry.value])
  } else if kind == "project" {
    lines.push([#strong(entry.category) #emph(entry.title) #h(0.75em)#emph(entry.institution)])
    lines.push(dated(entry.adviser, entry))
    lines.push(entry.description)
  } else if kind == "reference" {
    lines.push(linked(entry.name, entry))
    lines.push(entry.role)
    lines.push(entry.institution)
    lines.push(entry.email)
  } else {
    panic("Unknown section kind: " + kind)
  }

  // Keep each short CV entry together when a page ends.
  block(above: 0.65em, below: 0.65em, breakable: false)[
    #lines.join(linebreak())
    #if "children" in entry {
      let children = entry.children.filter(visible).map(child => {
        let body = if "venue" in child { emph(child.venue) } else { child.title }
        if "platform" in child { body += [ | #child.platform] }
        dated(body, child)
      })
      if children.len() > 0 { list(..children) }
    }
  ]
}

// The name and contact information belong in the document body for extraction.
#heading(level: 1, cv.profile.name)
#cv.profile.alternate-name \
#cv.profile.address \
#cv.profile.email #h(0.75em)#link(cv.profile.website.url, cv.profile.website.label)

#for section in cv.sections.filter(visible) {
  let entries = section.entries.filter(visible)
  if entries.len() > 0 {
    heading(level: 2, section.title)
    for entry in entries { render-entry(section.kind, entry) }
  }
}
