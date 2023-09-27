#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("UI Design")
On the left side, there's a scrollabe window containing a list of settings
categories. Above that is a search bar that allows users to quickly locate
specific settings. In addition to the search bar, there is a breadcrumb menu
similar to file paths which can be especially useful when users need to traverse
multiple screens or submenus, ensuring they can easily backtrack.
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
