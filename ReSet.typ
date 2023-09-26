#import "templates/template.typ": *

#show link: underline

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
  abstract,
  acknowledgements,
  doc,
)
#file.step()

#include "sections/introduction.typ"
#include "sections/projects.typ"
#pagebreak()
#include "sections/literature.typ"
#pagebreak()
#include "sections/technologies.typ"
#pagebreak()
#include "sections/results.typ"
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
#include "sections/appendix/domain_model.typ"
#pagebreak()
#include "sections/appendix/architecture.typ"
#pagebreak()
#include "sections/appendix/UI.typ"
#pagebreak()
#include "sections/appendix/documentation.typ"
#pagebreak()
#include "sections/appendix/retrospective.typ"
#pagebreak()
#include "sections/appendix/time_report.typ"
