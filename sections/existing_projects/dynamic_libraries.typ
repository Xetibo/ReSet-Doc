#import "../../templates/utils.typ": *
#lsp_placate()

#subsubsection("Dynamic Library Plugin Systems")
This section covers plugin systems utilizing dynamic libraries. Dynamic
libraries are explained in detail in @DynamicLibraries. @vim

#subsubsubsection("Hyprland")
Hyprland is a dynamic tiling compositor that can be extended via a plugin
system. Both the plugin system and the compositor itself are written in C++.
Notably, the plugin systems rarely use the "extern C" keyword, which results in
only C++-compatible plugins. An example of this exact system can be seen in
@ExhibitABICompatibility.

Using C++ ABI directly does offer both the plugin developer and Hyprland itself
a benefit, namely the C++ classes, structs and functions do not need to be
converted to C-compatible types. Depending on the complexity of the type, this
can lead to a sizable overhead.

Hyprland also offers a hooking system besides regular additional plugins. The
difference is that hooks allow direct modification of code execution, instead of
execution at a specific location in code. With the hooking system, it is
possible to replace any existing function within Hyprland with your own, or
append functionality to it. In @hyprlandhookexample, an example of the hooking
system of Hyprland is analyzed.

#let code = "
// make a global instance of a hook class for this hook
inline CFunctionHook* g_pMonitorFrameHook = nullptr;
// create a pointer typedef for the function we are hooking.
typedef void (*origMonitorFrame)(void*, void*);

// define new/additional functionality
void hkMonitorFrame(void* owner, void* data) {
  // call the original function
  std::cout << \"I bring additional functionality\";
  (*(origMonitorFrame)g_pMonitorFrameHook->m_pOriginal)(owner, data);
}

// Find function listener_monitorFrame and return address of it
APICALL EXPORT PLUGIN_DESCRIPTION_INFO PLUGIN_INIT(HANDLE handle) {
  // Bind our hkMonitorFrame function to listener_monitorFrame
  static const auto METHODS =
    HyprlandAPI::findFunctionsByName(PHANDLE, \"listener_monitorFrame\");
  g_pMonitorFrameHook = HyprlandAPI::createFunctionHook(handle,
    METHODS[0].address, (void*)&hkMonitorFrame);
  // init the hook
  g_pMonitorFrameHook->hook();
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "cpp")), kind: "code", supplement: "Listing", caption: [Hyprland Hook Example @hyprland_hook_wiki],
    )<hyprlandhookexample>],
)

The createFunctionHook API function takes a source and destination function. The
source function is the address of the Hyprland function to be overwritten.
Hence, a plugin developer would first need to get the address of that function.
Hyprland provides a find function for this use case, making it easy to create
hooks. The destination function is the function you would like to implement
instead of the original functionality. Note that the original function can still
be called at any point within your new function. In the official example from
Hyprland, the additional functionality was added before the call to the original
function. @hyprland_hook_wiki

#pagebreak()

In @hyprlandmempatching, the copying of the plugin-defined function is analyzed.

#let code = "
// alloc trampoline
// populate trampoline
// first, original but fixed func bytes
memcpy(m_pTrampolineAddr, PROBEFIXEDASM.bytes.data(), HOOKSIZE);
// then, pushq %rax
memcpy((uint8_t*)m_pTrampolineAddr + HOOKSIZE, PUSH_RAX, sizeof(PUSH_RAX));
// then, jump to source
memcpy((uint8_t*)m_pTrampolineAddr + HOOKSIZE + sizeof(PUSH_RAX),
  ABSOLUTE_JMP_ADDRESS, sizeof(ABSOLUTE_JMP_ADDRESS));

// fixup trampoline addr
*(uint64_t*)((uint8_t*)m_pTrampolineAddr + TRAMPOLINE_SIZE -
  sizeof(ABSOLUTE_JMP_ADDRESS) + ABSOLUTE_JMP_ADDRESS_OFFSET) =
  (uint64_t)((uint8_t*)m_pSource + sizeof(ABSOLUTE_JMP_ADDRESS));

// various code omitted: fixing pointers, NOP remaining code, etc.
// set original addr to trampo addr
m_pOriginal = m_pTrampolineAddr;"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "cpp")), kind: "code", supplement: "Listing", caption: [Hyprland Hook Creation @hyprland],
    )<hyprlandmempatching>],
)

Hyprland simply patches the memory itself by creating a trampoline function,
which will point to the plugin function. This means that the instructions of the
original function are turned to "No Operation (NOP)", which will be skipped by
the CPU. Instead, the trampoline will point to the new plugin function, which
will be executed.

This system is both extremely powerful and potentially dangerous. It allows
plugin developers to override any behavior of the existing application,
providing potentially new and expected functionality, but also allows overriding
any security implementations the program might have. For ReSet, this would
likely not make much sense, as ReSet does not offer much functionality at its
core, instead, ReSet intends to provide extend-ability.

A mock example Hyprland plugin written in Rust can be seen in
@ExhibitABICompatibility, specifically @hyprland_plugin_rust.

#subsubsubsection("Anyrun")
Anyrun is a Wayland application launcher similar to Launchpad for Macintosh
computers. It is written in Rust and GTK3 and offers users the ability to load
plugins with shared libraries using the stable ABI crate which automatically
converts Rust structs to C structs.

@anyrunbase shows the regular launch mode for Anyrun which allows users to find
and launch desktop applications.
#align(
  center, [#figure(
      img("anyrunbase.png", width: 100%, extension: "figures"), caption: [Anyrun Program search/launch],
    )<anyrunbase>],
)

#pagebreak()
@anyruncalculator and @anyruntranslate show two plugins for Anyrun, a calculator
plugin and a translate plugin.

#align(
  center, [#figure(
      img("anyrun-rink.png", width: 100%, extension: "figures"), caption: [Anyrun Calculator Plugin],
    )<anyruncalculator>],
)
#align(
  center, [#figure(
      img("anyrun-translate.png", width: 100%, extension: "figures"), caption: [Anyrun Translate Plugin],
    )<anyruntranslate>],
)

Anyrun abstracts the plugin implementation behind several different crates.
First is the ABI crate which handles the conversion of Rust-specific types into
C stable ABI-compatible ones. @stable_abi_crate

In @anyrunplugininfo, the plugin info struct of Anyrun is visualized.

#let code = "
#[repr(C)]
#[derive(StableAbi, Debug)]
pub struct PluginInfo {
    // RString is the stable ABI compatible string
    pub name: RString,
    pub icon: RString,
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Anyrun PluginInfo @anyrun],
    )<anyrunplugininfo>],
)

The next part of the Anyrun plugin structure is found within the macro crate.
Macros allow plugin developers for Anyrun to create plugins without the need to
worry about certain restrictions like special types, mutexes and thread
synchronization, as this can be handled automatically by the macro. More
information about Macros can be found in @Macros.

In @anyruninfomacro, the simple macro that transforms the plugin-provided info
function into the required format is visualized.

#let code = "
#[proc_macro_attribute]
pub fn info(_attr: TokenStream, item: TokenStream) -> TokenStream {
    let function = parse_macro_input!(item as syn::ItemFn);
    let fn_name = &function.sig.ident;

    quote! {
        #[::abi_stable::sabi_extern_fn]
        fn anyrun_internal_info() 
          -> ::anyrun_plugin::anyrun_interface::PluginInfo {
            #function
            #fn_name()
        }
    }
    .into()
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Anyrun Info Macro @anyrun],
    )<anyruninfomacro>],
)

With these two crates, it is now possible to create a function within a
potential plugin for Anyrun. The macro in @anyruninfomacro is an attribute
macro, this means the info function within the plugin will need to be annotated
with the \#[info] flag.

In @anyruninfofunction, an example info function is visualized.

#let code = "
#[info]
fn info() -> PluginInfo {
    PluginInfo {
        name: \"YourPlugin\".into(),
        icon: \"YourIcon\".into(),
    }
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Anyrun Info Plugin Function @anyrun],
    )<anyruninfofunction>],
)

This plugin function will now be used within Anyrun after loading the plugin.so
file. In @anyrunpluginusage, the usage of the function is visualized.

#let code = "
// load plugin first
let plugin = if plugin_path.is_absolute() {
    // load file
    abi_stable::library::lib_header_from_path(plugin_path)
} else {
  // omitted
}
.and_then(|plugin| plugin.init_root_module::<PluginRef>())
.expect(\"Failed to load plugin\");

// omitted initialization etc

// handle file and run functions within the dynamic library
if !runtime_data.borrow().config.hide_plugin_info {
  plugin_box.add(&create_info_box(
      &plugin.info()(),
      runtime_data.borrow().config.hide_icons,
  ));
  // omitted
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Anyrun Plugin Usage @anyrun],
    )<anyrunpluginusage>],
)
