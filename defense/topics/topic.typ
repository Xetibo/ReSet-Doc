#import "../utils.typ": *

#polylux-slide[
#set text(25pt)
== Main Goal

#align(center + horizon, [
  *Implementation* and *validation* of a *plugin system* for _multiprocess
  applications_.
])
#set text(20pt)
#pdfpc.speaker-note(```md
- multi process -> ReSet
- rust -> ReSet
- dbus -> ReSet
    ```)
]

#polylux-slide[
== Goals
\
#grid(columns: (2fr, 1fr), rows: auto, [
  - Plugin System for ReSet
    - Analysis of system paradigms
    - Analysis of existing systems
    - Implementation
  - Exemplary plugins
    - Validation for the plugin system
    - Analysis of existing solutions
    - Two implementations
], [
  #align(left, img("flag.svg", width: 80%))
])
#pdfpc.speaker-note(```md
    # topic
    - goal:
      - plugin system for reset
    - methods:
      - analysis of existing solutions
      - Implementation
      - exemplary plugins to validate system
      - user tests to validate experience
      - testing framework across both to prove validity and viability
    ```)
]
