#import "../utils.typ": *

#subtitle_slide("What Is ReSet?")

#polylux-slide[
#align(center, img("abando.png", width: 100%, fit: "contain"))
#pdfpc.speaker-note(```md
    # default gnome look
    - modular
      - can be replaced
      - different environments kde, budgie, hyprland, sway
    - not all apps cross compatible
      - especially with wayland
    ```)
]

#polylux-slide[
#align(center, img("hyprland_desktop.png", width: 100%, fit: "contain"))
#pdfpc.speaker-note(```md
    # hyprland
    - modular
      - specific and small environment
      - doesn't ship configuaration features
    ```)
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
  === Variable features
  \
    - Plugin System
    - User controllable features
    - Automatic detection for base features
      - No Bluetooth hardware, no Bluetooth features
      - Small amount of base features
  #pdfpc.speaker-note(
    ```md
    - Explain why these features are chosen
      - Everything a typical user might want to use 
      - Base features include features that are independent of environments
    - Explain why the plugin system
      - wayland and x11 differences
      - environment differences
      - user preferences to omit features
      - new hardware -> new configuration
    ```
  )
]

#polylux-slide[
  === One User Interface design
  #align(center, image("../figures/reset_audio.png", width: 70%))
  #pdfpc.speaker-note(
    ```md
    - All features share one user interface design
    - GTK/Rust
      - GTK used in gnome, very prevalent on linux
    - more information later 
    ```
  )
]

#polylux-slide[
  === SA Limitations
  \
  - No testing
  - Limited feature set
  - No configurability
  - More potential for accessibility
  #pdfpc.speaker-note(
    ```md
    - testing not possible because BUS connection
      - reliance on real world hardware
    - features set intentionally limited due to plugin system
    - accessibility limited to default gnome
    ```
  )
]

#polylux-slide[
  === BA goals
  \
  - Plugin system
  - Testing framework
  - Increased stability
  - Improved accessibility
  #pdfpc.speaker-note(
    ```md
    - plugin system for features
    - testing framework with mocks
    - stability by bug squashing
    ```
  )
]

