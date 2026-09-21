#import "cv-data.typ": cv
#import "academic-cv.typ": academic-cv

#let inactive-input = sys.inputs.at("include-inactive", default: "false")
#assert(inactive-input in ("true", "false"), message: "include-inactive must be true or false")

#show: academic-cv.with(cv, include-inactive: inactive-input == "true")
