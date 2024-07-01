#import "../utils.typ": *

#subtitle_slide("Keyboard Plugin")

#polylux-slide[
  #columns(
    2, [
      #align(center, img("gnomeKeyboardSetting.png", width: 100%, fit: "contain"))
      #colbreak()
      #align(center, img("kdeKeyboardSetting.png", width: 100%, fit: "contain"))
    ],
  )
  #pdfpc.speaker-note(```md
  - Inspired by Windows and Gnome Keyboard Settings
  - Windows similar to Gnome
  - Gnome: 
    - Drag and drop to change order
    - Add button below list
    - Other functions in triple dots icon right
  - KDE:
    - 2 buttons to change order
    - Add button above list
    - Other functions next to add button
    - Too cluttered (personal preference)
  ```)
]

#polylux-slide[
  #align(center, img("reset-keyboard.png", width: 100%, fit: "contain"))
  #pdfpc.speaker-note(```md
  - Sortable by drag and drop
    - Reason: Much easier to drag compared to spam button
    - Top element is active layout
    - 6 dots left same as real world example (tv controller)
  - Add layouts button above list 
    - Easier than to scroll down every time
  - Features:
    - Add/Reorder/Remove layouts
    - Easy to find a layout
    - Highlight of top 4 layouts
  ```)
]

#polylux-slide[
  === Change CSS dynamically
  \
  - Highlight of top 4 layouts
    - XKB limitation
  #align(center, img("resetKeyboardHighlight.png", width: 70%, fit: "contain"))
  #pdfpc.speaker-note(```md
    - limitation of xkb (not enough space for more in xkbstate struct)
      - more possible in theory just only top 4 saved
    - actions are function because that can be assigned to widgets
      - can be called from anywhere of the widget or children via string
      - with information not available from where it is called
      - advantages: reusable code, can be called from anywhere where widget is available
    - Solution: Using custom actions to change CSS
    ```)
]

#polylux-slide[
  === Nested groups
  \
  - ListBox always selecting a row
    - Selecting back row, which triggers an action to go back
  - Some rows have different logic depending on if variant exists
  #align(center, img("resetKeyboardAdd.png", width: 70%, fit: "contain"))
  #pdfpc.speaker-note(```md
    - Solution: Grab focus of another widget so no selection is triggered
    - Rows with no variant need no action
    - Rows with variant have a on click event to override keyboard layout list
    ```)
]

#polylux-slide[
  === Flatpak Sandboxing
  \
  - GIO cannot access the system schemas
    - GSettings subsequently not working as well
    // flatpak -> gio with x
  #align(center, img("flatpak-issue.png", width: 65%, fit: "contain"))
  #pdfpc.speaker-note(```md
    - this problem is will happen to all plugins that need to access system schemas
    - schema is a db file that contains the settings of the system
    - Solution: Use flatpak-spawn to spawn commands outside of sandbox
    ```)
]

