#import "../utils.typ": *

#subtitle_slide("Monitor Plugin")

#polylux-slide[
#columns(2, [
  #align(center, img("gnome-monitor.png", width: 100%, fit: "contain"))
  #colbreak()
  #align(center, img("kde-monitor.png", width: 100%, fit: "contain"))
])
#pdfpc.speaker-note(```md
  ### gnome
  - per monitor display in separate popup
  - dragging possible -> no gaps
  - numbered monitors
  - offers various additional features on top page
    - night light
    - join/mirror
  - fixed scaling

  ### kde
  - per monitor settings on top page
  - shows currently selected monitor by highlighting
  - dragging possible -> no gaps
  - arbitrary scaling
      ```)
]

#polylux-slide[
#align(center, img("reset-monitor.png", width: 100%, fit: "contain"))
#pdfpc.speaker-note(```md
  - selected monitor highlighted
    - blue -> color blindness
  - per monitor settings below
  - libadwaita rows
  - dynamic entries for scaling, primary monitor, vrr
      ```)
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
#align(center, text(fill: maroon, size: 30pt, [
  #v(10pt)
  $ 3440 / (1.066666...) = 3225$
  $ 1440 / (1.066666...) = 1350$\
  #v(10pt)
]))
#pdfpc.speaker-note(
  ```md
  - gnome -> fixed scaling
  - all others -> arbitrary scaling
  - x11 to wayland differences ? -> therefore no x11!
  - dynamic hiding and showing of interface parts -> hyprland no primary monitor
  - convert information to be user friendly
    - user doesn't understand what a monitor MODE is
    - user wants to choose refreshrate not a resolution,refreshrate,scaling combo
      - abstract these into singular items which can be chosen independently
    ```,
)
]

#polylux-slide[
==== Overlaps
#align(center, img("overlap.png", width: 100%, fit: "contain"))
#pdfpc.speaker-note(```md
  ### overlaps
  - resizing (resolution) might cause overlaps
    - bigger issue with more monitors
    - complex detection and solution
  - transform or scaling can also cause overlaps
      ```)
]

#polylux-slide[
==== Overlaps
#align(center, img("overlap-solved.png", width: 100%, fit: "contain"))
#pdfpc.speaker-note(```md
  - detected overlaps are handled if
    - monitor is not in y axis position 0 -> level
    - monitor is not the furthest monitor to the right
  - only one monitor is moved out of the way
      ```)
]

#polylux-slide[
==== Snapping
#align(center, img("snapping.png", width: 100%, height: 90%, fit: "contain"))
#pdfpc.speaker-note(```md
  - monitor snap to the closest monitor
  - not possible on overlap due to edge cases
  - similar approach to kde
    - useful for hyprland with possible monitor gaps
      ```)
]

#polylux-slide[
==== Mode Conversion
#grid(columns: (2fr, 0.5fr, 2fr), rows: auto, [
  #box(stroke: 5pt, fill: none, inset: 10pt, [
    *API Endpoint*
    - resolution (width, height)
    - refreshrate
    - gnome: scaling
  ]);
], [
  #line(start: (-30pt, 33%), end: (100%, 45%), stroke: 5pt)
], [
  #box(stroke: 5pt, fill: none, inset: 10pt, [
    *ReSet Endpoint*
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
])
#pdfpc.speaker-note(```md
  - loops over modes
  - independent refreshrate/scaling from resolution
  - no duplicate entries
      ```)
]

