#import "../../templates/utils.typ": *
#lsp_placate()

#subsubsection("ReSet Test")

#subsubsection("Midpoint UI Tests") // todo rename midpoint to mock ui test
Reaching the project's midpoint, the UI mock of ReSet was given out to a select 
few people for testing and reviewing purposes. The idea is the get feedback early 
so that there is still enough time to change the UI without much effort. Because it's 
only a UI mock test, it wasn't possible to ask for feedback for all tests defined 
in @ReSetTest because it hasn't been implemented yet.

- *Navigation feedback*
The feedback is very positive, especially with the mention of the ability to show
all settings or just a specific part. The structure is clean and makes it easy to
understand which subcategory belongs to which category.

- *Readability feedback*
There wasn't much feedback regarding readability, because it's not something
that can or should be influenced directly. Font size and contrast are set in the
settings, meaning it's consistent throughout the system, which includes ReSet.

- *Layout and Design feedback*
Users were generally positive about the layout and design of the app, but there
were also some ideas for improvement. One user noted that the window was padded,
which was noticeable when using a white theme. In addition, when opening a
category (e.g. connectivity), users noted that each subcategory lacked clear
separation and labeling. As far as the layout is concerned, inconsistencies were
found in the sizes and margins, which can be attributed to the manual design of
each element. Users also requested features such as the ability to collapse
subcategories and the inclusion of bold font for categories. Despite these areas
for improvement, the overall sentiment towards the app was positive, as users
appreciated the design while providing valuable advice on how to improve it.

- *Conclusion*
Feedback around navigation and readability was positive, mostly attributed to
the currently simple UI. It's important to note that readability is already
configured by the user or by using system defaults. ReSet doesn't overwrite 
these configurations to keep a consistent look throughout the user's system. 
Concerning the layout and design, there will be improvements made by templating 
common UI building blocks, which will fix the issue of inconsistent design and 
make it easier to keep it consistent. Features such as collapsing subcategories 
have to be discussed further, to determine if it's necessary and if fit in the 
timeframe.

#pagebreak()

#subsubsection("ReSet Feedback Test")
#test("Search bar and Sidebar", 
  "User can filter settings by typing in the search bar. Clicking on a setting will open the corresponding settings box and reset the sidebar.",
  [
    Searching worked for all testers.
  ],
  [
    - Search field is easy to overlook and should be bigger
    - Highlight search text
    - Search bar is redundant with few categories
  ]
)
#test(
  "Dynamic window", 
  "Multiple settings can be opened at the same time and each setting box will reflow based on how much space is available.",
  [
    Resizing worked for all testers and overall feedback to resizing was positive.
  ],
  [
    - Search bar hide is not very smooth, maybe add animation
    - Selected category is not highlighted (fixed)
    - Default category is arbitrary (Noted in @Conclusion)
  ]
)
#test(
  "Wi-Fi", 
  "Users can connect and disconnect from a Wi-Fi network. They should also be able to change the password for an existing Wi-Fi network and remove it.",
  [
    Changing to a wrong password crashes the program for one user. Another user mentioned that the access points were fetched very slowly compared to nmcli. ReSet crashes when machine doesn't have Wi-Fi, but that has been fixed.
  ],
  [
    - Apply button being clickable with no changes was confusing
    - Not enough error messages
    - Not enough feedback when connecting/connected to Wi-Fi network
    - Perhaps use gear icon instead of pen icon for Wi-Fi settings
    - Clicking on Wi-Fi should close the details page
    - Add different color to connected network
  ]
)
#test(
  "Bluetooth", 
  "Users can connect and disconnect Bluetooth devices.",
  []
)
#test(
  "Volume of Audio devices", 
  "Users can change the volume of their input and output devices.",
  []
)
#test(
  "Change default Audio device", 
  "Users can change the default input and output device.",
  []
)
#test(
  "Audio of individual applications", 
  "Users can change the input and output of individual applications. They should also be able to mute an audio source.",
  []
)
#test(
  "Disable Audio devices", 
  "Users can disable input and output devices.",
  []
)
#test(
  "Performance", 
  "Users should not experience any lags or stuttering.",
  []
)
#test(
  "Intuitive UI", 
  "The UI is structured logically so that the user can easily find the setting they are looking for. Settings that belong together are grouped.",
  []
)
#test(
  "Layout", 
  "The layout should be visually appealing and feel organized to the users.",
  []
)
