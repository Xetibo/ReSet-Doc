#import "templates/template.typ": *

#show link: set text(fill: blue)

#let abstract = { [ This is an abstract ] }
#let acknowledgements = { [ This is acknowledgements ] }

#show: doc => conf(
  author: "Fabio Lenherr / Felix Tran",
  "Dr. Prof. Frieder Loch",
  "ReSet",
  "/figures/ReSet1.png",
  25%,
  "/figures/OST.svg",
  40%,
  "Department for Computer Science",
  "OST Eastern Switzerland University of Applied Sciences",
  "../files/bib.yml",
  abstract,
  acknowledgements,
  doc,
)
#file.step()

#include "sections/introduction.typ"
#pagebreak()
#include "sections/projects.typ"
#pagebreak()
#include "sections/literature.typ"
#pagebreak()
#include "sections/implementation.typ"
#pagebreak()
#include "sections/conclusion.typ"
#pagebreak()
#section("Appendix")
#include "sections/appendix/projectplan.typ"
#pagebreak()
#include "sections/appendix/requirements.typ"
#pagebreak()
#include "sections/appendix/risks.typ"
#pagebreak()
#include "sections/appendix/ui_tests.typ"
#pagebreak()
#include "sections/appendix/documentation.typ"
#pagebreak()
#include "sections/appendix/retrospective.typ"
#pagebreak()
#include "sections/appendix/time_report.typ"
