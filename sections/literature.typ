#import "../templates/utils.typ": *
#lsp_placate()

#subsection("Insights from literature")
#subsubsection("User Interfaces")
The Gnome Human Interface Guidelines @gnome_human_guidelines are likely the most
applicable for ReSet, as they are the most prominent in the Linux sphere and are
directly meant to be used with GTK4, a potential user interface toolkit for
ReSet. While Reset does not intend to belong into the gnome circle, for which
rather strict adherence to these guidelines are needed, ReSet will still use
best practices that are employed by these guidelines.

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
  Each navigation should have an obvious destination, in other each time the user
  changes their current position, it should be clear to the user where they are
  right now, and where they can go from here.\
  Both gnome human interface guidelines and Steve Kruger advise developers to use
  as few required clicks to navigate to a certain page as possible, however,
  Kruger also specifies that clarity is more important.
+ "Get rid of half the words on each page, then get rid of half of what is left."
  - Steve Krug @krug\
  This defines unnecessary information on a page or application. Everything that
  the user does not care about should be omitted.

#subsubsection("Plugin System")
As read on NullDeref @nullderef, there are multiple ways to create a potential
plugin system for ReSet:
- WASM\
  Web assembly is a very flexible way of creating plugins, as it is based on
  something that will work on every device that has a WASM target. However, WASM
  is not something known to anyone involved in this project, which is why it is
  not covered further.
- Scripting Languages\
  Languages like Lua have had quite a big success integrating in multiple fields
  such as game programming and even the Neovim editor. In both cases it expands
  the potential functionality by giving developers a fully functional programming
  language while still keeping the original system with a more performant system
  programming language.
- IPC\
  With inter process communication, one will have a lot of overhead when talking
  about a plugin system, however, it is a lot easier to write. For this project,
  IPC will be the fallback if the other systems are not suitable or turn out to be
  too complex.
- Dynamic Loading\
  This refers to dynamic libraries that are loaded at runtime. These dynamic
  libraries are the most performant way to create a plugin system without outright
  moving towards changing the code and recompiling. However, it forces ReSet to
  offer a "stable" ABI which could be done over the C programming language or the
  abi_stable crate for the Rust programming language.\
  The project "anyrun" @anyrun by Kirottu servers as a perfect example for a small
  but powerful example of the abi_stable crate.
#figure(sourcecode(```rs
use abi_stable::std_types::{RString, RVec, ROption};
use anyrun_plugin::*;

#[init]
fn init(config_dir: RString) {
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
```), caption: [Example code for an anyrun plugin, available at: @anyrun])

#subsubsection("Configuration Storage")
In "The Pragmatic Programmer" @pragprog by David Thomas and Andrew Hunt, the
authors mentioned the importance of text file configuration that is
human-readable and can be put under version control. For ReSet the importance
comes from the fact that configuration of various categories need persistent
storage, and ReSet also needs to handle this.\

The already mentioned gnome control center handles this via a database, contrary
to the chapter in the aforementioned book. This is done for increased speed in
loading and storing configuration data. However, it does come with the downside
of needing a program to interact with the stored data, as you can't otherwise
access it.

KDE systemsettings in contrast works with text files as Thomas and Hunt
advocate, but their files are all over the place, meaning it is often hard to
understand where a certain setting might be if you would like to manually change
something, perhaps due to a bug in the graphical user interface, or because you
just like to do these changes manually.
