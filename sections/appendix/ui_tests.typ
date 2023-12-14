#import "../../templates/utils.typ": *
#lsp_placate()

#subsubsection("UI Tests")
#test("Search bar", "User can filter settings by typing in the search bar.")
#test(
  "Dynamic window", "Multiple settings can be opened at the same time and each setting box will reflow based on how much space is available.",
)
#test(
  "Intuitive UI", "The UI is structured in a logical way, so that the user can easily find the setting they are looking for. Settings that belong together are grouped together.",
)
#test(
  "Closing window", "User can close setting by clicking the X on the top right corner",
)
#test("Error handling", "Errors are shown to the user")
#test(
  "Theme", "The theme of ReSet is changed correctly when changing the system theme and looks consistent",
)
#test(
  "Readability", "Font and font size should change based on system settings and should be readable for everyone",
)
#test(
  "Navigation", "All buttons are clearly labeled and lead to its intended location",
)
#test("Accessibility", "Screen reader compatible")
#test("Localisation", "Full support for English and German")

#pagebreak()

#subsubsection("Midpoint UI Tests")
Reaching the project's midpoint, the UI mock of ReSet was given out to a select 
few people for testing and reviewing purposes. The idea is the get feedback early 
so that there is still enough time to change the UI without much effort. Because it's 
only a UI mock test, it wasn't possible to ask for feedback for all tests defined in  @UITests because it hasn't been implemented yet.

- *Navigation feedback*
The feedback is very positive, especially with mention to the ability to show
all settings or just a specific part. The structure is clean and made it easy to
understand which subcategory belongs to which category.

- *Readability feedback*
There wasn't much feedback regarding readability, because it's not something
that can or should be influenced directly. Font size and contrast are set in the
settings, meaning it's consistent throughout the system, which includes ReSet.

- *Layout and Design feedback*
Users were generally positive about the layout and design of the app, but there
were also some ideas for improvement. One user noted that the window was padded,
which was noticeable when using white theme. In addition, when opening a
category (e.g connectivity), users noted that each subcategory lacked clear
separation and labeling. As far as the layout is concerned, inconsistencies were
found in the sizes and margins, which can be attributed to the manual design of
each element. Users also requested features such as the ability to collapse
subcategories and the inclusion of bold font for categories. Despite these areas
for improvement, the overall sentiment towards the app was positive, as users
appreciated the design while providing valuable advice on how to improve it.

- *Conclusion*
Feedback around navigation and readability were positive, mostly attributed to
the currently simple UI. It's important to note that readability is already
configured by the user or by using system defaults. Regarding the layout and
design, there will be improvements made by templating a few elements, which fixes the issue with inconsistent design. Features such als collapsing subcategories have to be
discussed further, to determine if it's necessary and if fits in the timeframe.
