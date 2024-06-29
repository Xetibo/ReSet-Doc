#import "../utils.typ": *

#subtitle_slide("Usability Test Results")

#polylux-slide[
  === Participants
  \
   #align(center, img("testExperience.png", width: 100%, height: 75%, fit: "contain"))
  #pdfpc.speaker-note(```md
    - 12 participants
    - most of them are very experienced with computers or linux
    - most of them study computer science
    - might skew data a bit
    - advantage
      - people who know what they talk about
    - disadvantage
      - might not be representative
  ```)
]

#polylux-slide[
  === Ease of Use
  \
   #align(center, img("testEaseOfUse.png", width: 100%, height: 75%, fit: "contain"))
    #pdfpc.speaker-note(```md
    - Very intuitive (similar to gnome settings)
    - works well with different themes
    - improvements:
      - drag and drop not effortless
  ```)

]

#polylux-slide[
  === Ease of Use
  \
   #align(center, img("testDesign.png", width: 100%, height: 75%, fit: "contain"))
  #pdfpc.speaker-note(```md
    - simple and clean design
      - reminiscent of gnome settings (both use gtk widgets)
    - easy to navigate
    - improvements:
      - add more spacing between widgets (cramped)
      - more customization options
  ```)
]
