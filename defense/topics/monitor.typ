#import "../utils.typ": *

#subtitle_slide("Monitor Plugin")

#polylux-slide[
  #columns(2, [
    #align(center, img("gnome-monitor.png", width: 100%, fit: "contain"))
    #colbreak()
    #align(center, img("kde-monitor.png", width: 100%, fit: "contain"))
  ])
]

#polylux-slide[
  === Issues
  \
  #grid(columns: (2fr, 1fr), rows: auto, [
    - Differing endpoints
      - Differing conventions
    - Dynamic user interface
    - Conversion to user-friendly information
      - Example: Scaling
  ], [
    #align(center, [*Scaling*])
    #align(center, text(fill: maroon, size: 25pt, [
      #v(10pt)
      $1.00 * 120 = 120$\
      $120 + 6 = 126$\
      $126 / 120 = 1.066666... $
      #v(10pt)
    ]))
  ])
]

#polylux-slide[
  ==== Overlaps
  #align(center, img("overlap.png", width: 100%, fit: "contain"))
]

#polylux-slide[
  ==== Overlaps
  #align(center, img("overlap-solved.png", width: 100%, fit: "contain"))
]

#polylux-slide[
  ==== Snapping
  #align(center, img("snapping.png", width: 100%, height: 90%, fit: "contain"))
]

#polylux-slide[
  ==== Mode Conversion
  #grid(columns: (2fr, 0.5fr, 2fr), rows: auto, [
    #box(stroke: 5pt, fill: none, inset: 10pt, [
    *API Endpoint* 
      - resolution (width, height)
      - refreshrate
        - refreshrate1
        - refreshrate2
        - refreshrate3
      - gnome: scaling
        - scale1
        - scale2
        - scale3
    ]);
  ], [
    #line(start: (-30pt, 45%), end: (100%, 33%), stroke: 5pt)
  ], [
    #box(stroke: 5pt, fill: none, inset: 10pt, [
    *ReSet Endpoint* 
      - resolution (width, height)
      - refreshrate
      - gnome: scaling
    ]);
  ])
]

#polylux-slide[
  #align(center, img("reset-monitor.png", width: 100%, fit: "contain"))
]

