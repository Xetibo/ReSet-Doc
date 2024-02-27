#import "../templates/utils.typ": *
#lsp_placate()

#section("Plugin System Analysis")
In this section existing plugin systems are analyzed and evaluated. The results
of this section will directly influence the choices for the plugin system ReSet
will introduce. Evaluation of results can be found in @PluginSystemParadigms.

#subsection("Dynamic Library Plugin Systems")
This section covers plugin systems utilizing dynamic libraries. Dynamic
libraries are explained at detail in @DynamicLibraries.

#subsubsection("Hyprland")
Hyprland is a dynamic tiling compositor which can be extended via a plugin
system. Both the plugin systems and the compositor itself is written in C++.
Notably, the plugin systems only rarely uses the "extern C" keyword, which
results in only C++ compatible plugins. An example for this exact system can be
seen in @ExhibitABICompatibility.

Using C++ ABI directly does offer both the plugin developer and Hyprland itself
a benefit, namely the C++ classes, structs and functions do not need to be
converted to C compatible types. Depending on the complexity of the type, this
can lead to a sizable overhead.

Hyprland also offers a hooking system besides regular additional plugins. The
difference is that hooks allow direct modification of code execution, instead of
execution at a specific point in code. With the hooking system, it is possible
to replace any existing function within Hyprland with your own, or append
functionality to it. In @hyprlandhookexample, an example for the hooking system
of Hyprland is analyzed.

// typstfmt::off
#align(center, [#figure(sourcecode(```cpp
// make a global instance of a hook class for this hook
inline CFunctionHook* g_pMonitorFrameHook = nullptr;
// create a pointer typedef for the function we are hooking.
typedef void (*origMonitorFrame)(void*, void*);

// define new/additional functionality
void hkMonitorFrame(void* owner, void* data) {
    std::cout << "I bring additional functionality\n";
    // call the original function
    (*(origMonitorFrame)g_pMonitorFrameHook->m_pOriginal)(owner, data);
}

APICALL EXPORT PLUGIN_DESCRIPTION_INFO PLUGIN_INIT(HANDLE handle) {
    // Find function listener_monitorFrame and return address of it
    static const auto METHODS = HyprlandAPI::findFunctionsByName(PHANDLE, "listener_monitorFrame");
    // Bind our hkMonitorFrame function to listener_monitorFrame
    g_pMonitorFrameHook = HyprlandAPI::createFunctionHook(handle, METHODS[0].address, (void*)&hkMonitorFrame);
    // init the hook
    g_pMonitorFrameHook->hook();
}
```,), kind: "code", supplement: "Listing", caption: [Hyprland Hook Example @hyprland_hook_wiki],
)<hyprlandhookexample>])
// typstfmt::on

The createFunctionHook API function takes a source and destination function. The source function is the address of the Hyprland function to be overwritten.
Hence, a plugin developer would first need to get the address of that function. Hyprland provides a find function for this use case, making it easy to create hooks.
The destination function is the function you would like to implement instead of the original functionality. Note that the original function can still be called before or after your new functionality.
In @hyprland_hook_wiki, the additional functionality was added before the call to the original function.

In @hyprlandmempatching, the copying of the plugin defined function is analyzed.

// typstfmt::off
#align(center, [#figure(sourcecode(```cpp
    // alloc trampoline
    // populate trampoline
    memcpy(m_pTrampolineAddr, PROBEFIXEDASM.bytes.data(), HOOKSIZE);                                                       // first, original but fixed func bytes
    memcpy((uint8_t*)m_pTrampolineAddr + HOOKSIZE, PUSH_RAX, sizeof(PUSH_RAX));                                            // then, pushq %rax
    memcpy((uint8_t*)m_pTrampolineAddr + HOOKSIZE + sizeof(PUSH_RAX), ABSOLUTE_JMP_ADDRESS, sizeof(ABSOLUTE_JMP_ADDRESS)); // then, jump to source

    // fixup trampoline addr
    *(uint64_t*)((uint8_t*)m_pTrampolineAddr + TRAMPOLINE_SIZE - sizeof(ABSOLUTE_JMP_ADDRESS) + ABSOLUTE_JMP_ADDRESS_OFFSET) =
        (uint64_t)((uint8_t*)m_pSource + sizeof(ABSOLUTE_JMP_ADDRESS));

    // various code omitted: fixing pointers, NOP remaining code, etc.
    // set original addr to trampo addr
    m_pOriginal = m_pTrampolineAddr;
```,), kind: "code", supplement: "Listing", caption: [Hyprland Hook Creation @hyprland],
)<hyprlandmempatching>])
// typstfmt::on

Hyprland simply patches the memory of itself by creating a trampoline function, which will point to the plugin function.
This means that the instructions of the original function are turned to "No Operation(NOP)", which will be skipped by the cpu.
Instead, the trampoline will point to the new plugin function, which will be executed.

This system is extremely powerful, allowing plugin developers to override any
and all behavior of the existing application. For ReSet, this would likely not
make much sense, as ReSet does not offer much functionality at its core, instead
ReSet intends to provide extendability.

A regular Hyprland plugin can be seen in @ExhibitABICompatibility, specifically @hyprland_plugin_rust.

#subsubsection("Anyrun")
Anyrun is a Wayland application launcher similar to launchpad for Macintosh computers.
It is written in Rust and GTK3 and offers users the ability to load plugins with shared libraries using the stable ABI crate which automatically converts Rust structs to C structs.

@anyrunbase shows the regular launch mode for anyrun.
#align(
  center, [#figure(
      img("anyrunbase.png", width: 100%, extension: "figures"), caption: [],
    )<anyrunbase>],
)


@anyruncalculator and @anyrunwebsearch show two plugins for anyrun,
a calculator plugin and a websearch plugin.

#align(
  center, [#figure(
      img("anyruncalculator.png", width: 100%, extension: "figures"), caption: [Anyrun Calculator Plugin],
    )<anyruncalculator>],
)
#align(
  center, [#figure(
      img("anyrunwebsearch.png", width: 100%, extension: "figures"), caption: [Anyrun Websearch Plugin],
    )<anyrunwebsearch>],
)

Anyrun abstracts the plugin implementation behind several different crates.
First is the ABI crate which handles the conversion of Rust specific types into C stable ABI compatible ones.

In @anyrunplugininfo, the plugin info struct of anyrun is visualized.

#align(center, [#figure(sourcecode(```rs
#[repr(C)]
#[derive(StableAbi, Debug)]
pub struct PluginInfo {
    pub name: RString,
    pub icon: RString,
}
```,), kind: "code", supplement: "Listing", caption: [Anyrun PluginInfo @anyrun],
)<anyrunplugininfo>])

The next part of the Anyrun plugin structure is found within the maco crate.
Macros allow plugin developers for Anyrun to create plugins without the need to worry about certain restrictions like special types,
mutexes and thread synchronization, as this can be handled automatically by the macro.
More information about Macros can be found in @Macros.

In @anyruninfomacro, the simple macro that transforms the plugin provided info function into the required format is visualized.

#align(center, [#figure(sourcecode(```rs
#[proc_macro_attribute]
pub fn info(_attr: TokenStream, item: TokenStream) -> TokenStream {
    let function = parse_macro_input!(item as syn::ItemFn);
    let fn_name = &function.sig.ident;

    quote! {
        #[::abi_stable::sabi_extern_fn]
        fn anyrun_internal_info() -> ::anyrun_plugin::anyrun_interface::PluginInfo {
            #function

            #fn_name()
        }
    }
    .into()
}
```,), kind: "code", supplement: "Listing", caption: [Anyrun Info Macro @anyrun],
)<anyruninfomacro>])

With these two crates, it is now possible to create a function within a potential plugin for Anyrun.
The macro in @anyruninfomacro is an attribute macro, this means the info function within the plugin will need to be annotated with the \#[info] flag.

In @anyruninfofunction, an example info function is visualized.

#align(center, [#figure(sourcecode(```rs
#[info]
fn info() -> PluginInfo {
    PluginInfo {
        name: "YourPlugin".into(),
        icon: "YourIcon".into(),
    }
}
```,), kind: "code", supplement: "Listing", caption: [Anyrun Info Plugin Function @anyrun],
)<anyruninfofunction>])

This plugin function will now be used within Anyrun after loading the plugin.so file.
In @anyrunpluginusage, the usage of the function is visualized.

#align(center, [#figure(sourcecode(```rs
// load plugin first
let plugin = if plugin_path.is_absolute() {
    abi_stable::library::lib_header_from_path(plugin_path)
} else {
  // omitted
}
.and_then(|plugin| plugin.init_root_module::<PluginRef>())
.expect("Failed to load plugin");

// omitted initialization etc

if !runtime_data.borrow().config.hide_plugin_info {
  plugin_box.add(&create_info_box(
      &plugin.info()(),
      runtime_data.borrow().config.hide_icons,
  ));
  // omitted
}
```,), kind: "code", supplement: "Listing", caption: [Anyrun Plugin Usage @anyrun],
)<anyrunpluginusage>])

#subsection("Interpreted Language Plugin Systems")
This section covers plugin systems utilizing an interpreted language on top of
their system in order to provide expandability. The paradigm used for such
systems is explained in @InterpretedLanguages.

#subsubsection("Neovim")
Neovim is a fork of the iconic VIM editor. It offers both VIMscript and lua support, as well as an RPC API, providing users with multiple ways to expand functionality.
VIMscript is converted to lua, meaning Neovim only needs a single interpreter for lua.
This interpreter is tightly coupled to Neovim itself, providing plugin developers with an easy way to access core functionality.

While the implementation of the interpreter itself is too large for a brief analysis, the usage of this system can be analyzed.
Neovim provides solid documentation about their natively supported functionality wich one can use within the Neovim lua interpreter.
Note that this means the documented functionality is only supported in Neovim and not in any other Neovim interpreter. @neovimluadocumentation

In @testplugin, a Neovim testplugin is visualized.
#align(
  center, [#figure(
    sourcecode(```lua
local opts = {
  what = 0,
}

local test_plugin = {
  opts = opts,
}

function test_plugin.setup(user_config)
  test_plugin.opts = user_config
  vim.tbl_deep_extend("force", opts, user_config)
end

function test_plugin.config(user_config)
  test_plugin.opts = user_config
  vim.tbl_deep_extend("force", opts, user_config)
end

function test_plugin.test()
  if test_plugin.opts.what == 0 then
    vim.cmd("echo 'pingpang'")
  else
    vim.cmd("echo 'not pingpang'")
  end
end

return test_plugin
```),kind: "code", supplement: "Listing", caption: [Example Neovim Plugin])<testplugin>],
)

// TODO show output

#subsubsection("Helix")
Helix is a post modern modal text editor written in Rust.
It currently does not offer a plugin system, however, as of February 2024, there is an open pull request on the helix repository. @helixpr
This addition would introduce the list based steel scripting language as a plugin system. @steel

The difference to Neovim with steel besides the paradigm of the scripting language is the integration with the Rust programming language.
Steel offers a first party virtual machine for its parent language.
Creating plugins with steel would therefore require less work as a large portion would already be covered by steel.

In @steelengine, a simple usage of the steel engine in Rust is visualized.


#align(center, [#figure(sourcecode(```rs
use steel::steel_vm::engine::Engine;
use steel::steel_vm::register_fn::RegisterFn;

fn main() {
    let mut vm = Engine::new();
    vm.register_fn("test-function", test_function);
    vm.run("(test-function)").unwrap();
}

fn test_function() {
    println!("this is a test");
}
// this is simple, but it is quick to implement and offers
// powerful usage in Rust.
```),kind: "code", supplement: "Listing", caption: [Example Usage of the Steel Engine])<steelengine>])

// TODO example steel plugin
// TODO analyze integration into helix

#subsubsection("Roblox")
Roblox also offers the lua language as a scripting language, making it easy for potential game developers to create their own gamemode within roblox.


#subsection("Function Overriding Plugin Systems")
This section covers plugin systems utilizing function overriding, which is
explained in @FunctionOverriding.

#subsubsection("Gnome Shell")
The Gnome shell is writtin in JavaScript, this provides the benefit of allowing developers to simply override an existing function with another without caring about memory management.

