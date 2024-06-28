#import "../utils.typ": *

#subtitle_slide("Plugin Ideas")

#polylux-slide[
  === Monitor Plugin
  \
  #align(center, img("monitorMock.png", width: 50%, fit: "contain"))
  #pdfpc.speaker-note(```md
    - example ui
    - inspired by windows and gnome monitor settings 
      - some environments do not have this feature (text based)
    - drag and drop instead of input fields/text file config
    - specific settings not set in stone yet
    ```)
]

#polylux-slide[
  === Keyboard Plugin
  \
  #align(center, img("keyboardMock.png", width: 50%, fit: "contain"))
  #pdfpc.speaker-note(```md
  - Inspired by Windows and Gnome Keyboard Settings
  - Sortable by drag and drop
    - Top element is active layout
  - How to use:
    - Use the add layout button the go to another screen
    - (Optional) Use the search bar to filter layouts
    - Select the language and press the add button
    - (Optional) Use the delete button to remove a layout with the 3 dots icon
      - Currently not useful as the only feature in there
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
  === Change CSS dynamically
  \
  - Highlight of top 4 layouts
  - Custom signals not working
  - Solution: Using custom actions to change CSS
  #pdfpc.speaker-note(```md
    - custom signals  it would need access to the implementation of the widget
      - else you would send a signal in reponse to a signal
    - actions are function because that can be assigned to widgets and called via string
      - advantages: reusable code, can be called from anywhere where widget is available
    - if i have to bind to an existing signal and call an action, why not inline?
      - certain information not available in the signal
        - e.g in add keyboard layout no access to user keyboard layout list
    ```)
]

#polylux-slide[
  === Nested groups
  \
  - ListBox always selecting a row
    - selecting back row, which triggers an action to go back
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