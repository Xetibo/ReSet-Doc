#import "../templates/utils.typ": *
#lsp_placate()

#section("Implementation")

#subsection("Research")
#subsubsection("Plugin System")
As read on NullDeref @nullderef, there are multiple ways to create a potential
plugin system for ReSet:
- WASM\
  Web assembly is a very flexible way of creating plugins, as it is based on
  something that will work on every device that has a WASM target. However, WASM
  is not something known to anyone involved in this project, which is why it is
  not covered further.
- Scripting Languages\
  Languages like Lua have succeeded integrating in multiple fields such as game
  programming and even the Neovim editor. In both cases it expands the potential
  functionality by giving developers a fully functional programming language while
  still keeping the original system with a more performant system programming
  language.
- IPC\
  With inter process communication, one will have a lot of overhead when talking
  about a plugin system, however, it is a lot easier to write. For this project,
  IPC can be considered as a potential solution, should the other alternatives not
  be viable.
- Dynamic Loading\
  This refers to dynamic libraries that are loaded at runtime. These dynamic
  libraries are the most performant way to create a plugin system without outright
  moving towards changing the code and recompiling. However, it forces ReSet to
  offer a "stable" ABI which can be done directly over the C programming language,
  or indirectly with the abi_stable crate for the Rust programming language.\
  The project "anyrun" @anyrun by Kirottu serves as a perfect example for a small
  but powerful example of the abi_stable crate. Anyrun is a so-called application
  launcher, with each plugin being able to fill the launcher queries.
//typstfmt::off
#figure(
  sourcecode(```rs
use abi_stable::std_types::{RString, RVec, ROption};
use anyrun_plugin::*;

#[init]
fn init(config_dir: RString) {
  // ...
}

#[info]
fn info() -> PluginInfo {
  PluginInfo {
    // ...
  }
}

#[get_matches]
fn get_matches(input: RString) -> RVec<Match> {
  // ...
}

#[handler]
fn handler(selection: Match) -> HandleResult {
  HandleResult::Close
}
```),
  caption: [Example code for an anyrun plugin, available at: @anyrun],
)
//typstfmt::on
With just 4 functions, an anyrun plugin can be created which will fill a dynamic
library functions to be loaded at runtime.

#pagebreak()
#include "implementation/technologies.typ"
#pagebreak()
#include "implementation/architecture.typ"
#pagebreak()
#include "implementation/domain_model.typ"
#pagebreak()

#subsection("UI Design")
Our settings app can be divided into two parts. The left part contains a list of all setting 
categories and the right side displays the actual setting. While this is not a standard, it is a 
very common layout structure as seen in @PreviousWork and even on other OS like 
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
    image("../figures/riderSettingFull.png", width: 75%),
    image("../figures/riderSettingFiltered.png", width: 75%)
  ),
  caption: "JetBrains Rider setting search bar"
)

The right side displays the settings that can be configured. It is dynamically adding new 
settings to the screen if there's enough space to facilitate it. For example, if the user clicks on 
a category like Connectivity, it will show the WiFi settings and if there is enough space, Bluetooth 
and VPN settings are also displayed next to it in a grid layout. But if the user clicks on the WiFi 
setting, only the WiFi setting is visible because it is clear that the other settings are not 
relevant. Oftentimes, there's a lot of wasted space, especially if the window is in full screen. 
#align(center, [#figure(
    image("../figures/gnomeSettingsFullScreen.png", width: 90%),
    caption: [Full-screen #link("https://github.com/gnome/gnome-control-center")[Gnome control center] [@Gnome] 
    settings window on ultra-wide monitor],
  )<uimock>])

On top of that, the settings are structured in a hierarchical order, which allows us to have a 
breadcrumb menu similar to file paths. This can help users backtrack to previous sections without 
having to restart their search from the beginning. With this hierarchical order, it is also possible 
to use the Back button on the mouse for navigation.
#align(center, [#figure(
    image("../figures/windowsBreadcrumb.png", width: 75%),
    caption: [Windows 11 breadcrumb menu],
  )<uimock>])

The following figures are the first UI mocks that follow all the ideas mentioned above.
#align(center, [#figure(
    image("../figures/wifimock.png", width: 90%),
    caption: [UI mock of WiFi setting],
  )<uimock>])
#align(center, [#figure(
    image("../figures/monitormock.png", width: 90%),
    caption: [UI mock of monitor setting],
  )<uimock>])
#align(center, [#figure(
  image("../figures/widemock.png", width: 90%),
  caption: [UI mock behaviour on wide monitor screen],
)<uimock>])
#pagebreak()

