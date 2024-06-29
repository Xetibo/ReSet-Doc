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
  - Gnome:
    - Drag and drop to change order
    - Add button below list
    - Other functions in triple dots icon right
  - KDE:
    - 2 buttons to change order
    - Add button above list
    - Other functions next to add button
  ```)
]

#polylux-slide[
  #align(center, img("reset-keyboard.png", width: 100%, fit: "contain"))
  #pdfpc.speaker-note(```md
  - Sortable by drag and drop
    - Top element is active layout
    - Reason: Much easier to drag compared to spam button

  - Features:
    - Add layouts
    - Easy to find a layout
    - Highlight of top 4 layouts
  - Obstacles: // todo explain more
      - Main problems:
        - Bad documentation and no examples
        - Very rigid to changes
  ```)
]

#polylux-slide[
  #align(center, img("reset-add-keyboard.png", width: 100%, fit: "contain"))
  #pdfpc.speaker-note(```md
  - How to use:
    - Use the add layout button the go to another screen
    - (Optional) Use the search bar to filter layouts
    - Select the language and press the add button
    - (Optional) Use the delete button to remove a layout with the 3 dots icon
      - Currently not useful as the only feature in there
  ```)
]

#polylux-slide[
  === Change CSS dynamically
  \
  - Highlight of top 4 layouts
    - XKB limitation
  - Custom signals not working
    - Required information not available
  #pdfpc.speaker-note(```md
    - limitation of xkb (not enough space for more in xkbstate struct)
    - custom signals it would need access to the implementation of the widget
      - else you would send a signal in reponse to a signal
      - not possible because it would require changes in the gtk library
    - actions are function because that can be assigned to widgets
      - can be called from anywhere of the widget or children via string
      - with information not available from where it is called
      - advantages: reusable code, can be called from anywhere where widget is available
    - if i have to bind to an existing signal and call an action, why not inline?
      - certain information not available in the signal
        - e.g in add keyboard layout no access to user keyboard layout list
    - Solution: Using custom actions to change CSS
    ```)
]

#polylux-slide[
  === Nested groups
  \
  - ListBox always selecting a row
    - Selecting back row, which triggers an action to go back
  - Some rows have different logic depending on if variant exists
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
  - Solution: Use flatpak-spawn to spawn commands outside of sandbox
  #pdfpc.speaker-note(```md
    - this problem is will happen to all plugins that need to access system schemas
    - schema is a db file that contains the settings of the system
    ```)
]

