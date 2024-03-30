#import "../utils.typ": *

#subtitle_slide("User Interface")


// 2 defined challenges in docs: consistency and accessibility

#polylux-slide[ // how we have done consistency till now
  === Consistency
  \
  - Libadwaita UI widgets
  - Follow Gnome Human Interface Guidelines
  - Nielsen's Heuristics
  - 2 Usability tests (SA)
    - Animations
    - Inconsistency with sizes and margins
]

#polylux-slide[ // how we do consistency with plugin system
  === Plugin Consistency & Guidelines
  \
  - *Goal*: Seamlessness
  - Provide as much as possible (borders etc.)
  - Provide CSS classes (spacing, alignment, sizing, etc.)
    - Developers only need to provide content
  - Custom widgets
]

#polylux-slide[
  === Accessibility
  \
  - Mostly adopted by Gnome Settings (High Contrast, Large Text, etc.)
  - Shortcuts + Keyboard Movement
]
