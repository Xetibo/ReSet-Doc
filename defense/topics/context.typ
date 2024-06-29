#import "../utils.typ": *

#subtitle_slide("What Is ReSet?")

#polylux-slide[
#align(center, img("abando.png", width: 100%, fit: "contain"))
#pdfpc.speaker-note(```md
    # default gnome look
    - modular
      - can be replaced unlike in windows
      - different environments kde, budgie, hyprland, sway
    - not all apps cross compatible
      - especially with wayland
    ```)
]

#polylux-slide[
== Environments
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
#pdfpc.speaker-note(```md
  - specific implementation needed
  - not all environments support everything
  - differing paradigms
  - not all environments offer settings at all
    ```)
]

#polylux-slide[
  === Idea
  #align(center, image("../figures/reset_audio.png", width: 70%))
  #pdfpc.speaker-note(
    ```md
    - show picture of ReSet -> explain functionality
    - works on as many environments as possible
    - All features share one user interface design
    ```
  )
]

#polylux-slide[
  === Features
  \
  #grid(columns: (2fr, 1fr), rows: auto, [
    - User controllable features
    - Automatic detection for base features
      - No Bluetooth hardware\
        -> no Bluetooth features
      - Small amount of base features
    ], [
  #align(left, image("../figures/shopping.svg", width: 60%))
    ])
  #pdfpc.speaker-note(
    ```md
    # features
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
  == Technologies
  #align(
    center + horizon, [
      #v(-20pt)
      #columns(3, [
        #box(stroke: none, fill: none, [
          #text(size: 25pt, weight: "bold", "Rust")
          #align(center, img("rust.png", width: 80%, fit: "contain"))
        ])
        #colbreak()
        #box(stroke: none, fill: none, [
          #text(size: 25pt, weight: "bold", "GTK")
          #align(center, img("gtk.png", width: 80%, fit: "contain"))
        ])
        #colbreak()
        #box(stroke: none, fill: none, [
          #text(size: 25pt, weight: "bold", "Libadwaita")
          #align(center, img("libadwaita.jpg", width: 80%, fit: "contain"))
        ])
      ])
    ],
  )
  #pdfpc.speaker-note(
    ```md
    - gtk -> reliable, established -> 20 years
      - iced possible alternative -> not ready when SA started
      - no change for BA due to time constraints
    - libadwaita -> extension of gtk -> subjective choice
    - rust -> fast, memory efficient, good developer experience, still safe
      -> optimal to speed up with dbus -> aka mask dbus overhead
    ```
  )
]

#polylux-slide[
  === SA Limitations
  \
  #columns(2, [
  - No testing
  - Limited feature set
  - No configurability
  - More potential for accessibility
  #colbreak()
  #v(-15pt)
  #align(center, image("../figures/settings.svg", width: 40%))
    ])
  #pdfpc.speaker-note(
    ```md
    - testing not possible because BUS connection
      - reliance on real world hardware
    - features set intentionally limited due to plugin system
    - accessibility limited to default gtk
      - work in progress
    ```
  )
]

