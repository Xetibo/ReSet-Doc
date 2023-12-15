#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("UI Design")
The initial UI mocks have been made in a generic PDF tool. The goal of these
mocks is to get a general idea of how the UI should look like and to figure out
a good user experience.
#align(
  center, [#figure(
      img("monitormock.png", width: 75%), caption: [UI mock of monitor setting],
    )<uimock4>],
)
#align(
  center, [#figure(
      img("widemock.png", width: 75%), caption: [UI mock behavior on wide monitor screen],
    )<uimock5>],
)

#pagebreak()
There are multiple ways to build GTK UI. The first one is to use the GTK library
itself to build the UI directly in the code. The next two tools are UI builders
like Glade @glade and Cambalache @cambalache. These tools will also be evaluated
using a value table using a score range between 0 and 10 for each category. Each
category is also given a weight to express impact.\
The weights are as follows: low -> 1, medium -> 2, high -> 3

The following categories are evaluated for programming languages:
- *Functionality* | weight: high\
  Describes how many features the tool has to help development. More functionality
  means that it is easier and faster to implement certain features. But too much
  will increase complexity which is a detriment to the ease of use.
- *Ease of use* | weight: high\
  Indicates how intuitive the tools is. A better ease of use means the learning
  curve is lower. This also means a lowered complexity which makes it easier to
  understand what each feature does. It also includes how easy it is to find
  information about a tool on the internet. A lack thereof means a lot of research
  on the tools itself just to implement basic features.
- *Collaboration* | weight: medium\
  Describes how good the tool can be used in a team. This includes version
  control, how the tool can be used by multiple people at the same time and how
  easy merge conflicts can be solved.
- *Debugging* | weight: low\
  Tools that help developers find problems and bugs in the UI. This includes error
  messages and warnings and its quality.
- *Updates* | weight: medium\
  ReSet uses the latest version of GTK, which means that the tools should also be
  updated regularly to support the latest features.

#let language_weights = (
  functionality: 3, easeOfUse: 3, collaboration: 2, debugging: 1, updates: 2,
)

#let gtk = (
  functionality: 4, easeOfUse: 2, collaboration: 9, debugging: 5, updates: 10,
)

#let glade = (
  functionality: 1, easeOfUse: 8, collaboration: 2, debugging: 5, updates: 0,
)

#let cambalache = (
  functionality: 8, easeOfUse: 6, collaboration: 2, debugging: 5, updates: 9,
)

#grid(
  columns: (auto), rows: (30pt), cell(
    [#figure([], kind: table, caption: [UI Builder tools])<programminglanguages>], bold: true,
  ),
)

#grid(
  columns: (2.5fr, 1.5fr, 1.5fr, 1.5fr, 1.5fr), rows: (30pt, 30pt, 30pt, 30pt, 30pt, 30pt, 30pt), gutter: 0pt, cell("Category", bold: true, use_under: true, cell_align: left), cell("Code UI", bold: true, use_under: true), cell("Glade", bold: true, use_under: true), cell("Cambalache", bold: true, use_under: true), cell("Weight", bold: true, use_under: true), cell("Functionality", bold: true, cell_align: left), cell([#gtk.functionality], bold: true), cell([#glade.functionality], bold: true), cell([#cambalache.functionality], bold: true), cell([\*#language_weights.functionality], bold: true), cell("Ease of Use", bold: true, fill: silver, cell_align: left), cell([#gtk.easeOfUse], fill: silver, bold: true), cell([#glade.easeOfUse], fill: silver, bold: true), cell([#cambalache.easeOfUse], fill: silver, bold: true), cell([\*#language_weights.easeOfUse], fill: silver, bold: true), cell("Collaboration", bold: true, cell_align: left), cell([#gtk.collaboration], bold: true), cell([#glade.collaboration], bold: true), cell([#cambalache.collaboration], bold: true), cell([\*#language_weights.collaboration], bold: true), cell("Debugging", bold: true, fill: silver, cell_align: left), cell([#gtk.debugging], fill: silver, bold: true), cell([#glade.debugging], fill: silver, bold: true), cell([#cambalache.debugging], fill: silver, bold: true), cell([\*#language_weights.debugging], fill: silver, bold: true), cell("Updates", bold: true, cell_align: left), cell([#gtk.updates], bold: true), cell([#glade.updates], bold: true), cell([#cambalache.updates], bold: true), cell([\*#language_weights.updates], bold: true), cell("Total", bold: true, fill: silver, cell_align: left), cell([#calculate_total(gtk, language_weights)], fill: silver, bold: true), cell([#calculate_total(glade, language_weights)], fill: silver, bold: true), cell(
    [#calculate_total(cambalache, language_weights)], fill: silver, bold: true, color: green,
  ), cell(" ", fill: silver, bold: true),
)

ReSet will use Cambalache to build the UI. The reason for this it provides a application 
in which the UI can be built with drag and drop. This makes it easy to instantly see how 
the UI looks. Glade does provide the "same" functionality because Cambalache is heavily inspired, 
but it doesn't support GTK4 and is no longer maintained.While code created user
interface has impressive scores in the Collaboration and Updates categories, it
is harder to use because there is no UI builder.
#align(center, [#figure(
    img("cambalache.png", width: 90%),
    caption: [Screenshot of Cambalache],
  )<uimock1>])

#text(12pt, [*Libadwaita*])\
In addition to GTK, ReSet will also use a library called libadwaita @libadwaita.
Libadwaita is a library which extends the features of GTK. It is developed by
the GNOME project and thus follows the GNOME Human Interface Guidelines as well.
It provides a lot of beautiful UI widgets that make the UI feel modern.

#text(12pt, [*UI structure*])\
The settings app can be divided into two parts. The left part is a sidebar which
contains a list of all settings and the right side displays the actual setting
where the user can make changes. While this is not a standard, it is a very
common layout structure as seen in @Analysisofexistingapplications and even on
other OS like Windows and macOS. The list of settings contains multiple
categories like Connectivity and Sound, and each of them contains more
subcategories.

Because a settings app contains a lot of configuration options and customization
features, having a search bar is a necessity. To make it as smooth as possible,
the list of setting categories is updated for every character typed to only show
relevant options. This has already been implemented in JetBrains Rider for
example. In the figure below, searching for specific settings reduces the list
to a handful of matching entries that may contain the setting the user is
looking for.
#figure(
  grid(
    columns: 2, gutter: 0mm, img("riderSettingFull.png", width: 75%), img("riderSettingFiltered.png", width: 75%),
  ), caption: "JetBrains Rider setting search bar",
)

The right side displays the settings that can be configured. It is dynamically
adding new settings to the screen if there's enough space to facilitate it. For
example, if the user clicks on a category like Connectivity, it will show the
Wi-Fi settings and if there is enough space, Bluetooth and VPN settings are also
displayed next to it in a flowbox layout. But if the user clicks on the Wi-Fi
setting, only the Wi-Fi setting is visible because it is clear that the other
settings are irrelevant. This is especially useful on bigger monitor sizes,
because there's generally a lot of unused space in settings applications mentioned
in @Analysisofexistingapplications, especially if the window is displayed in
full screen.
#align(
  center, [#figure(
      img("gnomeSettingsFullScreen.png", width: 100%), caption: [Full-screen Gnome control center
        settings window on ultra-wide monitor],
    )<uimock1>],
)

On top of that, the settings are structured in a hierarchical order, which
allows us to have a breadcrumb menu similar to file paths. This can help users
backtrack to previous sections without having to restart their search from the
beginning. With this hierarchical order, it is also possible to use the Back
button on the mouse for navigation.
#align(
  center, [#figure(
      img("windowsBreadcrumb.png", width: 75%), caption: [Windows 11 breadcrumb menu],
    )<uimock2>],
)

The following figures are the first UI mocks that follow all the ideas mentioned
above using Cambalache.
#align(
  center, [#figure(img("wifimock.png", width: 90%), caption: [UI mock of Wi-Fi setting])<uimock3>],
)
