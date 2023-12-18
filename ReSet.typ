#import "templates/template.typ": *

#show link: set text(fill: blue)

#let abstract = {
  [
    In this paper, ReSet, a user-friendly settings application for Linux is
    developed with the rust programming language. ReSet aims to run on every
    distribution and environment#footnote[Refers to what is usually called a Desktop Environment, window manager, or
      compositor.], providing a consistent experience for all users.

    Key features include the configuration of Wi-Fi networks, Bluetooth devices, and
    audio devices. These features are tied together in a responsive user interface.

    Future development will focus on new features such as configuring peripherals,
    as well as a plugin system. This will allow users to extend ReSet with their
    features.

    Existing solutions either focus only on one functionality or are tightly coupled
    into an already existing environment, which brings incompatible features to
    other environments with it. Users of smaller, niche environments are therefore
    forced to either use multiple solutions at once or accept a partially
    incompatible solution. ReSet focuses on more than one functionality while not
    bundling with any environment, making it an independent application and solving
    the underlying issue.

    In order to provide a consistent, functional and appealing design, multiple
    existing solutions were compared and analyzed in order to develop ReSet.

    In summary, ReSet represents a significant advancement in Linux settings
    applications, offering a concise, cross-environment solution that prioritizes
    user experience through Rust's efficiency and adaptability.
  ]
}

#let acknowledgements = {
  [
    We would like to express our sincerest gratitude to Prof. Dr. Frieder Loch for
    advising us throughout our project. His guidance and support have been
    invaluable to us. We are also grateful to our testers who took the time to test
    our product and share valuable feedback. Their input has been instrumental in
    helping us make improvements to our product. We would also like to acknowledge
    the OST for providing us with the opportunity to work on this project.
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
  #include "sections/appendix/ui_tests.typ"
  #pagebreak()
  #include "sections/appendix/documentation.typ"
  #pagebreak()
  #include "sections/appendix/CI.typ"
  #pagebreak()
  #include "sections/appendix/api.typ"
  #pagebreak()
  #include "sections/appendix/datastructures.typ"
  #pagebreak()
  #include "sections/appendix/libraries.typ"
  #pagebreak()
  #include "sections/appendix/screenshots.typ"
  #pagebreak()
  #include "sections/appendix/retrospective.typ"
  #pagebreak()
  #include "sections/appendix/meeting.typ"
  #pagebreak()
  #include "sections/appendix/time_report.typ"
]

#show: doc => conf(
  author: "Fabio Lenherr / Felix Tran", "Prof. Dr. Frieder Loch", "ReSet", "/figures/ReSet1.png", 25%, "/figures/OST.svg", 40%, "School of Computer Science", "OST Eastern Switzerland University of Applied Sciences", "../files/bibliography.yml", abstract, acknowledgements, appendix, doc,
)
#file.step()

#include "sections/introduction.typ"
#pagebreak()
#include "sections/projects.typ"
#pagebreak()
#include "sections/literature.typ"
#pagebreak()
#include "sections/plugins.typ"
#pagebreak()
#include "sections/implementation.typ"
#pagebreak()
#include "sections/results.typ"
#pagebreak()
#include "sections/conclusion.typ"
#pagebreak()
