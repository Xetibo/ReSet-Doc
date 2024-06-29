#import "./utils.typ": *

#set page(paper: "presentation-16-9")
#set text(size: 20pt, font: "DejaVu Sans")
// #set text(size: 20pt,

#polylux-slide[
  #align(horizon + center)[
    = ReSet
    #image("./figures/ReSet1.png", width: 150pt)
    Fabio Lenherr, Felix Tran

    02.07.2024
  ]
]

#set page(background: regular_page_design(), footer: default_footer())

#show heading.where(level: 3).or(heading.where(level: 2)): content => [
  #content
  #v(-20pt)
  #line(
    start: (0%, 0%),
    end: (97%, 0%),
    stroke: 2pt + gradient.linear(black, white),
  )
]

#polylux-slide[
  == Table of Contents
  #v(15pt)

  #columns(2, [
    - Context
      - What is ReSet? // talk about reset and its idea
      - BA goals
    - Plugin system // Fabio
      - Architecture
      - Plugin API
      - Macros
      - Testing
      - Threading
      - Security
    #colbreak()
    - Plugins
      - Keyboard
      - Monitor
    - Distributions
    - Usability Test Results
    - Showcase
    - Questions
  ])
  #pdfpc.speaker-note(
    ```md
    # Fabio
    - context
    - plugin system
    # Felix
    - plugin ideas
    - User interface
    - showcase
    ```
  )
]

#include "topics/context.typ"
#include "topics/topic.typ"
#include "topics/plugin_system.typ"
#include "topics/keyboard.typ"
#include "topics/monitor.typ"
#include "topics/distribution.typ"
#include "topics/usabilitytest.typ"
#include "topics/showcase.typ"
