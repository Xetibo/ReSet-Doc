#import "../../templates/utils.typ": *
#lsp_placate()


#subsubsection("UI Tests")
#test("Search bar", "User can filter settings", [
  - some positives
], [
  - some negatives
], "some notes")
#test("Breadcrumb bar", "User can move settings by clicking on breadcrumb", [
  - some positives
], [
  - some negatives
], "some notes")
#test("Dynamic window", "Settings pages is filled with more settings if there's enough space and is on a setting category", [
  - some positives
], [
  - some negatives
], "some notes")
#test("Closing window", "User can close setting by clicking the X on the top right corner", [
  - some positives
], [
  - some negatives
], "some notes")
#test("Error handling", "Errors are shown to the user", [
  - some positives
], [
  - some negatives
], "some notes")
#test("Theme", "Multiple themes available with dark theme as default theme", [
  - some positives
], [
  - some negatives
], "some notes")
#test("Readability", "Font should be readable in different monitor resolutions and sizes", [
  - some positives
], [
  - some negatives
], "some notes")
#test("Navigation", "All buttons lead to its intended location", [
  - some positives
], [
  - some negatives
], "some notes")
#test("Accessibility", "Screen reader compatible", [
  - some positives
], [
  - some negatives
], "some notes")
#test("Localisation", "Full support for English and German", [
  - some positives
], [
  - some negatives
], "some notes")

#pagebreak()

#subsubsection("Midpoint UI Tests")
Now that we have reached the midpoint of our project, we have given our UI mock to a select few people for testing and reviewing purposes. The idea is the get feedback early so that we can still change our UI without much effort and time. Because it's only a UI mock test, we couldn't go into much depth or go by the UI Tests defined above, because it simply was not possible to test it as it hasn't been implemented yet.

- *Navigation feedback*
The feedback is very positive, especially with mention to the ability to show all settings or just a specific part. The structure is clean and made it easy to understand which subcategory belongs to which category.

- *Readability feedback*
There wasn't much feedback regarding readability, because it's not something that can or should be influenced directly. Font size and contrast are set in the settings, meaning it's consistent throughout the system, which includes ReSet.

- *Layout and Design feedback*
Users were generally positive about the layout and design of the app, but there were also some ideas for improvement. One user noted that the window was padded, which was noticeable when using white theme. In addition, when opening a category (e.g connectivity), users noted that each subcategory lacked clear separation and labeling. As far as the layout is concerned, inconsistencies were found in the sizes and margins, which can be attributed to the manual design of each element. Users also requested features such as the ability to collapse subcategories and the inclusion of bold font for categories. Despite these areas for improvement, the overall sentiment towards the app was positive, as users appreciated the design while providing valuable advice on how to improve it.

- *Conclusion*
Feedback around navigation and readability were positive, mostly attributed to the currently simple app. It's important to note that readability is already configured by the user or by using system defaults. Regarding the layout and design, we will start by templating a few elements, which fixes the issue with inconsistent theming. Features such als collapsing subcategories have to be discussed further, to determine if we want to implement it and if fits in our timeframe.