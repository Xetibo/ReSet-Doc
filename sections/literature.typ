#import "../templates/utils.typ": *
#lsp_placate()

#subsection("Insights from literature")
#subsubsection("User Interfaces")
The Gnome Human Interface Guidelines @gnome_human_guidelines are likely the most
applicable for ReSet, as they are the most prominent in the Linux sphere and are
directly meant to be used with GTK4, a potential user interface toolkit for
ReSet. While Reset does not intend to belong into the Gnome circle, for which
rather strict adherence to these guidelines is needed, ReSet will still use best
practices that are employed by these guidelines.

These best practices can also be seen in the renowned book by Steve Krug, "Don't
Make Me Think". @krug In said work the author defined rules to follow when
creating user interfaces for the web, however, the vast majority of these rules
can be applied in the same manner on desktop applications.

Krug's rules:
+ "Don't Make Me Think" - Steve Krug @krug\
  This defines that a user should not need to "think" when using the interface, it
  should come as obvious where the user has to click or navigate to in order to
  finish their task. In the case of ReSet, this might be something like connecting
  to a Wi-Fi network or a Bluetooth device.\
  For the example the application blueman introduced in @ExistingProjects is used.

  First, let's open the application, what do we see?
  #figure(
    align(center, [#image("../figures/bluetooth_manager.png", width: 80%)]),
  )
  We see an empty page, why? Does my Bluetooth not work? But it was working the
  last time!\
  Turns out, we first have to click the search button.
  #figure(align(
    center,
    [#image("../figures/bluetooth_manager_filled.png", width: 80%)],
  ))
  Alright, nice, now we can see our devices, but, how do we connect? The checkmark
  seems the most likely.
  #figure(align(
    center,
    [#image("../figures/bluetooth_manager_commented.png", width: 80%)],
  ))
  Well wrong, that was the mark as trusted button, the one we wanted was the key
  button for pairing, or we can double-click to connect as well(the second part is
  intuitive!).

+ "It doesn’t matter how many times I have to click, as long as each click is a
  mindless, unambiguous choice." - Steve Krug @krug\
  Each navigation should have a consistent path and a clearly defined destination,
  it should be clear to the user where they are right now, and where they can go
  from here.

  Both the Gnome human interface guidelines and Steve Kruger advise developers to
  use as few required clicks to navigate to a certain page as possible. This
  avoids tedious navigation where users could either get lost in navigation or
  simply get annoyed at the endless path.
  #figure(
    align(center, [#image("../figures/kde-hamburger.png", width: 60%)]),
    caption: [An extreme example of KDE hamburger menus],
  )<kde-hamburger>
  There is a long-standing debate over menu layers like in @kde-hamburger, the KDE
  side justifies these menus with increased functionality, while the Gnome side
  explicitly discourages these menus citing reduced accessibility. In this case
  the question becomes, where can I see my bookmarks? Well, it's in
  more->go->bookmarks, this is on layer4 of a menu without search functionality
  and with very ambiguous navigation.

  In other words, it is clear that shorter navigation is usually the best way to
  achieve "mindless navigation", however it is, as Krug mentioned, not the only
  factor.

+ "Get rid of half the words on each page, then get rid of half of what is left."
  - Steve Krug @krug\
  This defines unnecessary information on a page or application. Everything that
  the user does not care about should be omitted. One should note however that
  this does not imply removal or omitting of _features_, instead only showing
  users a certain feature when they need it. Gnome uses the same concept when
  creating applications, keeping the overall application simple, but powerful when
  needed.

  The downside of this approach can be a too simple application, meaning the _powerful when needed_ part
  does not always apply. Compared to KDE applications, Gnome is often considered
  to be simpler, but also less configurable, and in large part this is correct.
  #grid(columns: (1fr, 1.1fr), rows: (auto), gutter: 10pt, figure(
    align(center, [#image("../figures/new-gnome.png", width: 60%)]),
    caption: [Context menu in Nautilus(the Gnome file manager)],
  ), figure(
    align(center, [#image("../figures/new-kde.png", width: 100%)]),
    caption: [Context menu in Dolphin(the kde file manager)],
  ))
  Here the KDE application is clearly more powerful, offering a variety of files
  to create, including links and shortcuts, while the Gnome experience only offers
  a new folder, anything else needs to be done with a terminal.

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

#subsubsection("Configuration Storage")
In "The Pragmatic Programmer" @pragprog by David Thomas and Andrew Hunt, the
authors mentioned the importance of text file configuration that is
human-readable and can be put under version control. For ReSet the importance
comes from the fact that configuration of various categories need persistent
storage, and ReSet also needs to handle this.\

The already mentioned Gnome control center handles this via a database, contrary
to the chapter in the aforementioned book. This is done for increased speed in
loading and storing configuration data. However, it does come with the downside
of needing a program to interact with the stored data, as you can't otherwise
access it.

KDE systemsettings in contrast works with text files as Thomas and Hunt
advocate, but their files are all over the place, meaning it is often hard to
understand where a certain setting might be if you would like to manually change
something, perhaps due to a bug in the graphical user interface, or because you
just like to do these changes manually.
