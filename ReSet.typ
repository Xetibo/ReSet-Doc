#import "templates/template.typ": *

#show link: set text(fill: blue)

#let abstract = {
  [
    Abstract
  ]
}

#let acknowledgements = {
  [
    Acknowledgements We would like to express our sincerest gratitude to Prof. Dr.
    Frieder Loch for advising us throughout our project. His guidance and support
    have been invaluable to us. /*We are also grateful to our testers who took the time to test
    our product and share valuable feedback. Their input has been instrumental in
    helping us make improvements to our product.*/ We would also like to
    acknowledge the OST for providing us with the opportunity to work on this
    project.
  ]
}

#let appendix = [
  #pagebreak()
  #section("Appendix")
  #include "sections/appendix/projectplan.typ"
  #pagebreak()
  #include "sections/appendix/requirements.typ"
  #pagebreak()
  #include "sections/appendix/risks.typ"
  #pagebreak()
  #include "sections/appendix/hyprland_plugin.typ"
  #pagebreak()
  #include "sections/appendix/libraries.typ"
  #pagebreak()
  #include "sections/appendix/meeting.typ"
  #pagebreak()
  #include "sections/appendix/time_report.typ"
]

#show: doc => conf(
  author: "Fabio Lenherr / Felix Tran", "Prof. Dr. Frieder Loch", "Introduction of a Plugin System" , "ReSet", "/figures/ReSet1.png", 25%, "/figures/OST.svg", 40%, "School of Computer Science", "OST Eastern Switzerland University of Applied Sciences", "../files/bibliography.yml", abstract, acknowledgements, appendix, doc,
)
#file.step()

#include "sections/introduction.typ"
#pagebreak()
#include "sections/Prelude.typ"
#pagebreak()
#include "sections/literature.typ"
#pagebreak()
#include "sections/existing_systems.typ"
#pagebreak()
#include "sections/comparison.typ"
#include "sections/result.typ"
#pagebreak()
#include "sections/conclusion.typ"
#pagebreak()
