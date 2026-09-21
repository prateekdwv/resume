// This list controls section order, including sections currently inactive.
#let section-files = (
  "research-interests",
  "employment",
  "education",
  "publications",
  "achievements",
  "teaching",
  "talks",
  "visits",
  "professional-contributions",
  "references",
  "languages",
  "personal-details",
  "courses",
  "projects",
  "technical-strengths",
)

#let cv = (
  profile: yaml("data/profile.yaml"),
  sections: section-files.map(name => yaml("data/" + name + ".yaml")),
)
