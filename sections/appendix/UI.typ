#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("UI Design")
Our settings app can be divided into two parts. The left part contains a list of all setting 
categories and the right side displays the actual setting. While this is not a standard, it is a 
very common layout structure as seen in @ExistingProjects and even on other OS like 
Windows and MacOS. The list of settings contains multiple categories like Connectivity and Sound, 
and each of them contains more subcategories.

Because a settings app contains a lot of configuration options and customization features, having a 
search bar is a necessity. To make it as smooth as possible, the list of setting categories is 
updated for every character typed to only show relevant options. This has already been implemented 
in JetBrains Rider for example. In the figure below, searching for specific settings reduces the 
list to a handful of entries that may contain the setting the user is looking for.
#figure(
  grid(
    columns: 2,
    gutter: 0mm,
    image("../../figures/riderSettingFull.png", width: 75%),
    image("../../figures/riderSettingFiltered.png", width: 75%)
  ),
  caption: "JetBrains Rider setting search bar"
)

On the right side, we display the settings that can be configured. It is dynamically adding new 
settings to the screen if there's enough space to facilitate it. For example, if the user clicks on 
a category like Connectivity, it will show the WiFi settings and if there is enough space, Bluetooth 
and VPN settings are also displayed next to it in a grid layout. But if the user clicks on the WiFi 
setting, only the WiFi setting is visible because it is clear that the other settings are not 
relevant. Oftentimes, there's a lot of wasted space, especially if the window is in full screen. 
#align(center, [#figure(
    image("../../figures/GnomeSettingsFullScreen.png", width: 90%),
    caption: [Full-screen #link("https://github.com/Gnome/Gnome-control-center")[Gnome control center] [@Gnome] 
    settings window on ultra-wide monitor],
  )<uimock>])

On top of that, the settings are structured in a hierarchical order, which allows us to have a 
breadcrumb menu similar to file paths. This can help users backtrack to previous sections without 
having to restart their search from the beginning. With this hierarchical order, it is also possible 
to use the Back button on the mouse for navigation.
#align(center, [#figure(
    image("../../figures/windowsBreadcrumb.png", width: 75%),
    caption: [Windows 11 breadcrumb menu],
  )<uimock>])

The following figures are the first UI mocks that follow all the ideas mentioned above.
#align(center, [#figure(
    image("../../figures/wifimock.png", width: 90%),
    caption: [UI mock of WiFi setting],
  )<uimock>])
#align(center, [#figure(
    image("../../figures/monitormock.png", width: 90%),
    caption: [UI mock of monitor setting],
  )<uimock>])
#pagebreak()

#subsubsection("UI Tests")
#test("globi", "globi can connect to wifi", [
  - works
  - easy to see all connections
], [
  - no advanced configuration
  - can't be used with keyboard
], "some notes")
