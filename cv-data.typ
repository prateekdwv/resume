// This list controls section order, including sections currently inactive.
#let section-files = (
  "research-interests",
  "employment",
  "education",
  "publications",
  "talks",
  "courses",
  "visits",
  "achievements",
  "teaching",
  "professional-contributions",
  "personal-details",
  "projects",
  "technical-strengths",
  "references",
)

#let cv = (
  profile: yaml("data/profile.yaml"),
  sections: section-files.map(name => yaml("data/" + name + ".yaml")),
)
