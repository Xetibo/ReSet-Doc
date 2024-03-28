#import "../utils.typ": *

#subtitle_slide("What Is ReSet?")

#polylux-slide[
  === One User Interface design
  #align(center, image("../figures/reset_audio.png", width: 70%))
]

#polylux-slide[
  === Variable features
  #align(left + horizon, [
    - Plugin System
    - Cuser controllable features
    - Automatic detection for base features
  ])
]

#polylux-slide[
=== working features across environments
#v(35pt)
//typstfmt::off
  #grid(
    columns: (auto, auto , auto),
    rows: (auto, auto),
    gutter: 50pt,
    grid.cell(
      align(center,
        rotate(-14deg,
          img("kde.svg", width: 100pt)
        ),
      )
    ),
    grid.cell(
      align(center,
        rotate(0deg,
          img("gnome.svg", width: 250pt),
        ),
      )
    ),
    grid.cell(
      align(center,
        rotate(14deg,
          img("hyprland.png", width: 200pt),
        ),
      )
    ),
    grid.cell(
      align(center,
        rotate(14deg,
          img("pop.svg", width: 100pt, height: 100pt, fit: "contain"),
        ),
      )
    ),
    grid.cell(
      align(right + horizon,
        rotate(0deg,
          img("awesome.svg", width: 200pt, fit: "contain"),
        ),
      )
    ),
    grid.cell(
      align(center,
        rotate(-14deg,
          img("sway.png", width: 100pt, fit: "contain"),
        ),
      )
    ),
  )
]

#polylux-slide[
  === SA shortcomings
  \
  - No Testing
  - Limited feature set
  - No configurability
  - Questionable accessibility
]

#polylux-slide[
  === BA goals
  \
  - Plugin system
  - Testing framework 
  - Increased stability
  - Improved accessibility
]

