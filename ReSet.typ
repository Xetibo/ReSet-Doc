#import "templates/template.typ": *

#show link: set text(fill: blue)

#let abstract = {
  [
    This abstract introduces ReSet, a user-friendly settings application for Linux
    written in Rust. ReSet aims to run on every distribution, providing a consistent
    experience for all users.

    Key features include the configuration of WiFi networks, Bluetooth devices,
    Input devices and Output devices. These features are tied together in a
    responsive user interface.

    Future development will focus on new features such as configuring peripherals,
    as well as a plugin system. This will allow users to extend ReSet with their own
    features.

    In summary, ReSet represents a significant advancement in Linux settings
    applications, offering a concise, cross-distribution solution that prioritizes
    user experience through Rust's efficiency and adaptability. // todo write more stuff here
    // why is this stuff centered? it looks weird af
  ]
}

#let acknowledgements = {
  [
    We would like to express our sincerest gratitude to Prof. Dr. Frieder Loch for advising us
    throughout our project. His guidance and support have been invaluable to us. We
    are also grateful to our fellow students who took the time to test our product
    and share valuable feedback. Their input has been instrumental in helping us
    make improvements to our product. We would also like to acknowledge the OST for
    providing us with the opportunity to work on this project.
  ]
}

#show: doc => conf(
  author: "Fabio Lenherr / Felix Tran", "Prof. Dr. Frieder Loch", "ReSet", "/figures/ReSet1.png", 25%, "/figures/OST.svg", 40%, "School of Computer Science", "OST Eastern Switzerland University of Applied Sciences", "../files/bib.yml", abstract, acknowledgements, doc,
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
