#import "cv-data.typ": cv

// A plain content preview. Replace this renderer when choosing a CV template.
#let inactive-input = sys.inputs.at("include-inactive", default: "false")
#assert(inactive-input in ("true", "false"), message: "include-inactive must be true or false")
#let include-inactive = inactive-input == "true"
#let visible(record) = include-inactive or record.at("active", default: true)
#let linked(label, record) = if "url" in record { link(record.url, label) } else { label }
#let email-link(address) = link("mailto:" + address, address)
#let dated(body, record) = if "dates" in record { [#body #h(0.75em)#emph(record.dates)] } else { body }
#let entry-links(entry) = entry.at("links", default: ()).filter(visible).map(item => link(item.url, item.label))

// Nested items use the same visibility and link rules at every depth.
#let render-children(entry) = {
  let children = entry.at("children", default: ()).filter(visible)
  if children.len() > 0 {
    list(..children.map(child => {
      let body = if "venue" in child { emph(linked(child.venue, child)) } else { linked(child.title, child) }
      if "platform" in child { body += [ | #child.platform] }
      let links = entry-links(child)
      [#dated(body, child)#if links.len() > 0 { [#linebreak()#links.join([ | ])] }#render-children(child)]
    }))
  }
}

#set document(title: cv.profile.name + " — CV", author: cv.profile.name)
#set page(paper: "us-letter", margin: 0.75in)
#set text(font: ("New Computer Modern", "Lohit Devanagari"), size: 11pt, lang: "en", hyphenate: false)
#show regex("[\u0900-\u097F]+"): set text(font: "Lohit Devanagari", lang: "hi")
#set par(justify: false)
#set heading(numbering: none)

// Format semantic fields independently of the enclosing page layout.
#let entry-lines(kind, entry) = {
  let lines = ()
  if kind == "prose" {
    lines.push(entry.description)
  } else if kind == "appointment" {
    lines.push([#strong(linked(entry.institution, entry)) #h(0.75em)#emph(entry.location)])
    lines.push(dated(entry.role, entry))
    if "department" in entry { lines.push(entry.department) }
    if "qualification-level" in entry { lines.push([Level in EQF: #entry.qualification-level]) }
    if "email" in entry { lines.push([Email: #email-link(entry.email)]) }
    if "sector" in entry { lines.push([Business or sector: #entry.sector]) }
    if "thesis" in entry {
      let thesis = entry.thesis
      lines.push([Thesis: #emph(thesis.title) \[#link(thesis.url, "pdf")\]])
    }
    if "adviser" in entry {
      lines.push([#entry.adviser.at("label", default: "Adviser:") #linked(entry.adviser.name, entry.adviser)])
    }
  } else if kind == "publication" {
    lines.push(dated(strong(linked(entry.title, entry)), entry))
    lines.push(entry.authors)
    lines.push(emph(entry.venue))
    if "publisher" in entry { lines.push([Publisher: #entry.publisher]) }
    if "note" in entry { lines.push(emph(entry.note)) }
  } else if kind == "language" {
    lines.push(strong(entry.language))
    if "proficiency" in entry { lines.push(entry.proficiency) }
    for (skill, level) in entry.at("skills", default: (:)) {
      lines.push([#skill: #level])
    }
  } else if kind in ("talk", "visit", "achievement", "teaching", "contribution", "course") {
    let title = linked(entry.title, entry)
    if kind in ("teaching", "contribution") { title = strong(title) }
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
    lines.push(email-link(entry.email))
  } else {
    panic("Unknown section kind: " + kind)
  }
  let links = entry-links(entry)
  if links.len() > 0 { lines.push(links.join([ | ])) }
  lines
}

#let render-entry(kind, entry) = {
  let lines = entry-lines(kind, entry)
  // Keep compact records together; let lists and long prose cross pages.
  let has-children = entry.at("children", default: ()).filter(visible).len() > 0
  let long-prose = kind in ("prose", "project", "contribution")
  block(above: 0.65em, below: 0.65em, breakable: has-children or long-prose)[
    #lines.join(linebreak())
    #render-children(entry)
  ]
}

// The name and contact information belong in the document body for extraction.
#heading(level: 1, cv.profile.name)
#cv.profile.alternate-name \
#cv.profile.address \
#email-link(cv.profile.email)
#if "personal-email" in cv.profile {
  [#h(0.75em)#email-link(cv.profile.personal-email)]
}
#h(0.75em)#link(cv.profile.website.url, cv.profile.website.label)
#if "phone" in cv.profile { [#linebreak()#cv.profile.phone] }

#for section in cv.sections.filter(visible) {
  let entries = section.entries.filter(visible)
  if entries.len() > 0 {
    heading(level: 2, section.title)
    for entry in entries { render-entry(section.kind, entry) }
  }
}
