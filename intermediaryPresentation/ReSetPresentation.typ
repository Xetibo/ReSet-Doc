#import "./utils.typ": *

#set page(paper: "presentation-16-9")
#set text(size: 25pt)

#polylux-slide[
  #align(horizon + center)[
    = ReSet
    #image("./figures/ReSet1.png", width: 150pt)
    Directed by: Fabio Lenherr, Felix Tran

    04.04.2024
  ]
]

#set page(background: regular_page_design(), footer: default_footer())

#show heading.where(level: 3).or(heading.where(level: 2)): content => [
  #content
  #v(-20pt)
  #line(
    start: (0%, 0%), end: (97%, 0%), stroke: 2pt + gradient.linear(black, white),
  )
]

#polylux-slide[
  == Summary

  #columns(2, [
    - Context //
      - What is ReSet?// talk about reset and its idea
      - SA shortcoming
      - BA goals
    - Plugin system // Fabio
      - Architecture
      - Testing
      - Security
      - Developer experience
    #colbreak()
    - Plugin ideas //
      - Monitor
      - Keyboard
    - UI // Felix
      - Consistency
      - Seamlessness
      - Guidelines// maybe our own
    - Showcase//
    - Questions
  ])
]

#include "topics/context.typ"
#include "topics/plugin_system.typ"
#include "topics/plugin_ideas.typ"
#include "topics/ui.typ"
