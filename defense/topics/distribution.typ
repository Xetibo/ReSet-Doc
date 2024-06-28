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
]
