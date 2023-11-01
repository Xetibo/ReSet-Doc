#import "../../templates/utils.typ": *
#lsp_placate()

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
