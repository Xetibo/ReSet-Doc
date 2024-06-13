#import "../../templates/utils.typ": *
#lsp_placate()

#subsubsection("Interpreted Language Plugin Systems")
This section covers plugin systems utilizing an interpreted language on top of
their system in order to provide expandability. The paradigm used for such
systems is explained in @InterpretedLanguages.

#subsubsubsection("Neovim")
Neovim is a fork of the ubiquitous VIM editor. @vim @neovim It offers both VIMscript
and lua support, as well as a Remote Procedure Call API, providing users with
multiple ways to expand functionality. VIMscript is converted to lua, meaning
Neovim only needs a single interpreter for lua. This interpreter is tightly
coupled to Neovim itself, providing plugin developers with an easy way to access
core functionality.

While the implementation of the interpreter itself is too large for a brief
analysis, the usage of this system can be analyzed. Neovim provides solid
documentation about their natively supported functionality which one can use
within the Neovim lua interpreter. Note that this means the documented
functionality is only supported in Neovim and not in any other Neovim
interpreter. @neovimluadocumentation

#pagebreak()

For the example plugin, the Neovim plugin package manager "lazy" is used.
@lazy_neovim\
In @testplugin, a Neovim test plugin is visualized. @testplugin_neovim

#let code = "
-- define local variables
local opts = {
  val = 0,
}

local test_plugin = {
  opts = opts,
}

-- include variables in user configuration
function test_plugin.setup(user_config)
  test_plugin.opts = user_config
  vim.tbl_deep_extend(\"force\", opts, user_config)
end

function test_plugin.config(user_config)
  test_plugin.opts = user_config
  vim.tbl_deep_extend(\"force\", opts, user_config)
end

-- define function which the user can use
function test_plugin.test()
  if test_plugin.opts.val == 0 then
    vim.cmd(\"echo 'val is 0'\")
  else
    vim.cmd(\"echo 'val is not 0'\")
  end
end

return test_plugin"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "lua")), kind: "code", supplement: "Listing", caption: [Example Neovim Plugin],
    )<testplugin>],
)

// TODO show output

#subsubsubsection("Helix")
Helix is a post-modern modal text editor written in Rust. @helix It currently
does not offer a plugin system, however, as of February 2024, there is an open
pull request on the helix repository. @helixpr This addition would introduce the
lisp-based steel scripting language as a plugin system. @steel

The difference between Neovim with steel besides the paradigm of the scripting
language is the integration with the Rust programming language. Steel offers a
first-party virtual machine for its parent language. Creating plugins with steel
would therefore require less work as a large portion would already be covered by
steel.

#pagebreak()

In @steelengine, a simple usage of the steel engine in Rust and GTK is
visualized.

#let code = "
use steel::steel_vm::engine::Engine;
use steel::steel_vm::register_fn::RegisterFn;

fn main() {
    // gtk initialization
    let vm = Rc::new(RwLock::new(Engine::new()));

    let button_func = ActionEntry::builder(\"test\")
        .activate(move |_, _, _| {
            label_ref.set_text(\"button clicked\");
        })
        .build();
    window.add_action_entries([button_func]);

    vm.register_fn(\"test-function\", test_function);
    vm.run(\"(test-function)\").unwrap();

    // due to both the VM and GTK being limited to one thread
    // it is necessary to provide thread synchronization
    let wrapper = Arc::new(ArcWrapper {
        window: window.clone(),
    });
    let gtk_action_function = move || {
        gtk::prelude::ActionGroupExt::activate_action(&*wrapper.window, \"test\", None);
    };
    vm.write()
        .unwrap()
        .register_fn(\"test-function\", gtk_action_function);
    let button = Button::new();
    let newvm = vm.clone();
    button.connect_clicked(move |_| {
        newvm.write().unwrap().run(\"(test-function)\").unwrap();
    });

    // run gtk
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Example Usage of the Steel Engine],
    )<steelengine>],
)

#columns(
  2, [
    #align(
      center, [#figure(
          img("steel-base.png", width: 50%, extension: "figures"), caption: [Steel GTK example],
        )<steelgtk>],
    )
    #colbreak()
    #align(
      center, [#figure(
          img("steel-clicked.png", width: 50%, extension: "figures"), caption: [Steel GTK example (clicked)],
        )<steelgtkclicked>],
    )
  ],
)

A challenge to utilize any scripting language with GTK is that both GTK and the
scripting language has its thread, and both are single-threaded environments.
Hence, it requires manual synchronization and also requires special wrapping of
GTK structs as they are not marked as Sync/Send, which is required in Rust for
multithreading.

#pagebreak()

#subsubsubsection("Usage in Games")
Various game engines and modding frameworks also utilize lua as a scripting
language in order to provide extendability.

Roblox for example uses lua to provide players a way to create their game modes.
@roblox_lua

There are also modding frameworks like UE4SS, which uses lua as the scripting
language for modifications to Unreal Engine games. @ue4ss

The difference between the Roblox system and the UE4SS system is that Roblox
provides a specific binding for exposed functionality. This ensures that
developers are unable to modify crucial systems like rendering, anti-cheat
protection and more. The UE4SS system provides hooks, meaning it is possible to
attach to existing functions and override or expand them. Hooking functionality
is described in @Hyprland.

#subsubsubsection("GNOME Shell")
The GNOME shell is written in C and JavaScript. Specifically, the user interface
part is written in JavaScript, meaning extensions can fully rely on this
language. Usage of an interpreted language for this allows plugin developers to
simply override existing functions at runtime without requiring a complicated
plugin/hooking system.

In @GNOMEoverride, the override function is visualized. This function allows
extension developers to override existing functionality within GNOME shell
similarly to using hooks.

#let code = "
/**
 * Modify, replace or inject a method
 * @param {object} prototype - the object (or prototype) that is modified
 * @param {string} methodName - the name of the overwritten method
 * @param {CreateOverrideFunc} createOverrideFunc
 *        - function to call to create the override
 */
overrideMethod(prototype, methodName, createOverrideFunc) {
  const originalMethod = this._saveMethod(prototype, methodName);
  this._installMethod(prototype, methodName, createOverrideFunc(originalMethod));
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "js")), kind: "code", supplement: "Listing", caption: [GNOME Extensions Override Function @GNOME_extensions],
    )<GNOMEoverride>],
)

#let code = "
// import the extension js from GNOME shell -> dependency
import {Extension} from './path/to/shell/extensions/extension.js';

export default class Example extends Extension.Extension {
  enable() {
    // override functions, add widgets, etc
  }
  
  disable() {
    // disable plugin
  }
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "js")), kind: "code", supplement: "Listing", caption: [GNOME shell example extension],
    )<GNOMEexampleextension>],
)

Another benefit of the GNOME shell extensions is the fact that the regular GNOME
shell has already created classes, functions and more within JavaScript. This
allows plugin developers to just use said functions to create widgets and more
using the same styling as the native GNOME implementation. For ReSet this could
also be possible, even when using native Rust code, as ReSet-specific widgets
can be exported to a crate, allowing plugin developers to utilize similar
functionality.
