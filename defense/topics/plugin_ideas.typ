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
    - Highlight of top 4 layouts
      - Change CSS dynamically is hard
        - No signals to bind to
      - Solution: Using custom actions to change CSS
    - Grouped layouts
      - Nested groups -> ListBox always selecting a row
        - Always selecting back row, which triggers an action
      - Some rows have different logic depending on if variant exists
      - Solution: Grab focus so no selection is triggered
    - Flatpak Sandboxing
      - GIO cannot access the system schemas 
      - Solution: Use flatpak-spawn to spawn commands outside of sandbox
    - Main problems:
      - Bad documentation and no examples
      - Very static
  ```)
]
//  - warum schwierig, wie gelöst, sandboxing
