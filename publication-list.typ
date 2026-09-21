// Standalone publication list; facts and category order come from the CV's YAML.
#import "cv-data.typ": cv
#import "academic-cv.typ": academic-cv

#let publications = cv.sections.filter(section => section.kind == "publication")
#let publication-cv = cv + (sections: publications.map(section => section + (
  title: "Publication List",
  application-title: "Publication List",
)),)

#show: academic-cv.with(
  publication-cv,
  include-inactive: true,
  expanded-header: false,
  show-publishers: false,
  document-label: "Publication List",
  publication-entry-gap: 18pt,
  publication-title-gap: 5pt,
)
