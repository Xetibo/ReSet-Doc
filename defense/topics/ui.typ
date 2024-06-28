#import "../utils.typ": *

#subtitle_slide("User Interface")

// 2 defined challenges in docs: consistency and accessibility
#polylux-slide[ // how we have done consistency till now
=== Consistency
\
#columns(2, [
  - Libadwaita UI widgets
  - Follow Gnome Human Interface Guidelines
  - 2 Usability tests (SA)
    - Animations
    - Inconsistency with sizes and margins
  - 1 Usability test (BA)
  #colbreak()
  #align(center, image("../figures/layout.svg", width: 40%))
])
#pdfpc.speaker-note(```md
    - using libadwaita widgets when possible
      - ui library with theminig for gnome
    - follow gnome hci (besides pointer + touch)
    - idea with boxes around setting widgets
      - multiple widgets per page
        - dynamic sizing (ultrawide screens)
    - ui results for usability tests
    - 1 or 2 usability tests planned for BA
  ```) ]

#polylux-slide[ // how we do consistency with plugin system
=== Plugin Consistency & Guidelines
\
#columns(2, [
  - *Goal*: Seamlessness
  - Provide as much as possible (borders etc.)
  - Provide CSS classes (spacing, alignment, sizing, etc.)
  - Plugins user interface
    - Developers only need to provide content
    - Custom widgets
    #colbreak()
    #v(40pt)
    #align(center, image("../figures/check.svg", width: 40%))
])
#pdfpc.speaker-note(```md
    - no difference between reset ui and plugin ui is the goal
    - css classes exposed with documentation
    - custom widgets with predefined css classes for unified ui
  ```) ]

#polylux-slide[
=== Accessibility
\
#columns(2, [
  - Mostly adopted by Gnome Settings (High Contrast, Large Text, etc.)
  - Shortcuts + Keyboard Movement
    - Shortcut config for plugins
  #colbreak()
  #v(-15pt)
  #align(center, image("../figures/accessibility.svg", width: 40%))
])
#align(center, img("resetHighContrast.png", width: 70%))

#polylux-slide[
=== Shortcoming
\
#columns(2, [
  - Provide CSS classes (spacing, alignment, sizing, etc.)
  - No custom widgets
  - No custom animations
  - Terminal client
  #colbreak()
  #v(40pt)
  #align(center, image("../figures/check.svg", width: 40%))
])
#pdfpc.speaker-note(```md
    - no difference between reset ui and plugin ui is the goal
    - css classes exposed with documentation
    - custom widgets with predefined css classes for unified ui
  ```) ]

#pdfpc.speaker-note(```md
    - not much active work bc already integrated
    - shortcuts a work in progress in BA
  ```)
]
