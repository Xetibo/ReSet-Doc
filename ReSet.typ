#import "templates/template.typ": *

#show link: set text(fill: blue)

#let abstract = { [ This is an abstract ] }


#let acknowledgements = { [ 
We would like to express our sincerest gratitude to Frieder Loch for advising us throughout our project. His guidance and support have been invaluable to us.
We are also grateful to our fellow students who took the time to test our product and share valuable feedback. Their input has been instrumental in helping us make improvements to our product.
We would also like to acknowledge the OST for providing us with the opportunity to work on this project.
] }

#show: doc => conf(
  author: "Fabio Lenherr / Felix Tran",
  "Prof. Dr. Frieder Loch",
  "ReSet",
  "/figures/ReSet1.png",
  25%,
  "/figures/OST.svg",
  40%,
  "School of Computer Science",
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
