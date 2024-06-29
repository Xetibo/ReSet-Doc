#import "../utils.typ": *

#polylux-slide[
== Distribution
#align(
  center + horizon, [
    #v(-20pt)
    #columns(4, [
      #box(stroke: none, fill: none, [
        #text(size: 25pt, weight: "bold", "Ubuntu")
        #align(center, img("abando-logo.png", width: 100%, fit: "contain"))
      ])
      #colbreak()
      #box(stroke: none, fill: none, [
        #text(size: 25pt, weight: "bold", "Nix")
        #align(center, img("nix.png", width: 100%, fit: "contain"))
      ])
      #colbreak()
      #box(stroke: none, fill: none, [
        #text(size: 25pt, weight: "bold", "Arch")
        #align(center, img("arch.png", width: 100%, fit: "contain"))
      ])
      #colbreak()
      #box(stroke: none, fill: none, [
        #text(size: 25pt, weight: "bold", "Flatpak")
        #align(center, img("flatpak.png", width: 100%, fit: "contain"))
      ])
    ])
  ],
)
#pdfpc.speaker-note(```md
# ubuntu 24.04 package
  - reset
  - both plugins
  - auto installed -> configuration required
  # Nix
  - homemanager module
  - ReSet and plugins
  - auto installation and configuration
  # Arch
  - reset
  - both plugins
  - auto installed -> configuration required
# Flatpak
  - ReSet
  - plugins must be installed manually -> binary
  - manual configuration
  - suboptimal
      ```)
]
