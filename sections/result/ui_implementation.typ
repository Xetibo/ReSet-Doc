#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("User Interface")
In this section, the results of the user interface of ReSet are discussed.

The final UI design has generally followed the intended vision. The UI is clean
and simple, and the user can easily navigate through the UI. It is also
responsive, which means that it will adjust itself depending on window sizes.

There was one feature that was cut after some discussion which was the 
breadcrumb menu. It was decided that the breadcrumb menu is not necessary 
because the UI is not as nested as initially planned. The depth of it is 
only one level deep at maximum, which means that a breadcrumb bar would be
redundant. If the UI ever gets deeply nested, the breadcrumb bar could be 
reconsidered.

As mentioned in @Introduction ReSet is created with the intent to provide
a dynamic user interface that fits into all environments. Specifically 
standalone environments that currently lack an integrated settings 
application were the target. As such it was a priority to ensure maximum 
compatibility with these environments.

Many of such environments are based on window tiling, a concept that ensures 
the entire screen is used by splitting the screen space with various layout rules.
The paper "The anatomy of the modern window manager" explains the concept of 
tiling in a more detailed manner.@window_manager_study

For ReSet, the importance of tiling is the behavior of applications in this environment.
Concepts such as minimum window size, maximum window size, or popups are often a hindrance 
to tiling. A window will always be placed according to the rules of the layout, and this 
could mean having as little as a few pixels left to be placed, or the entire screen, hence 
size constraints are incompatible. For popups, the most breaking change is the focus change 
and the placement of the popup. A tiling window manager has to consider a popup as a 
different type of window that should not be considered for tiling, and should instead use 
a traditional stacking approach that allows for overlapping windows. Some tiling window 
managers simply place the popups at the center of the currently focused monitor, which might 
be unexpected when trying to open a popup manually, while expected for a password prompt. 
The second issue is the focus, a tiling window manager is very keyboard-focused, and can 
for the most part be used entirely via keyboard shortcuts. A popup requires the user to 
change the focus to the newly created popup and therefore takes away the focus of the 
last window, a behavior that is not welcome in every situation.


For ReSet, the solution was to provide a nearly size-agnostic application that refrains from 
using popups wherever possible. In order to ensure the application is usable with 
any size, each functionality of ReSet is put into a dynamically allocated box. This allows 
not only the size agnostic design but also provides a responsive design by changing 
from horizontal to vertical orientations. Implemented into ReSet are therefore three 
different stages, vertical orientation without a sidebar, vertical orientation with a 
sidebar and horizontal orientation with a sidebar. The stages are shown from minimum 
size to maximum size respectively, in @reset_minimal, @reset_vertical and 
@reset_horizontal, each stage is shown visually.

#figure(
  img("reset_minimal.png", fit: "contain", width: 45%), caption: [ReSet in vertical view without sidebar],  
)<reset_minimal>
#figure(
  img("vertical_reset.png", fit: "contain", width: 85%), caption: [ReSet in vertical view],
)<reset_vertical>
#figure(
  img("horizontal_reset.png", fit: "contain", width: 95%), caption: [ReSet in horizontal view],
)<reset_horizontal>

To prevent using popups or relying on hamburger menus, ReSet opted to provide advanced configuration of each functionality
using the AdwNavigationPage provided by libadwaita@libadwaita.
This module allows for a seamless transition from a parent to a child window by clicking the button with the target page name.
In @reset_audio and @reset_profiles, the AdwNavigationPage can be seen in use.

#subsubsection("Audio User Interface")
For audio, ReSet intends to provide as much relevant information to the user as possible.
The intention is to provide not only the central audio settings but also provide adjustments
for all currently open programs utilizing audio.

In @reset_audio, the user interface can be seen with both the default output device and active programs utilizing audio output.

#figure(
  img("reset_audio.png", fit: "contain", width: 90%), caption: [ReSet Audio section],
)<reset_audio>

Additional configuration, such as audio profiles and per-device adjustment
are available in the device and profile settings respectively.

#figure(
  img("reset_audio_profiles.png", fit: "contain", width: 90%), caption: [ReSet Audio profiles section],
)<reset_profiles>

#figure(
  img("reset_audio_devices.png", fit: "contain", width: 90%), caption: [the ReSet Audio devices section],
)<reset_audio_devices>

Results from the @MidpointUITests show a positive reception of the audio interface.

#pagebreak()

#subsubsection("Wi-Fi User Interface")
The Wi-Fi settings provide a short general adjustment at the top, using a global switch to enable or disable Wi-Fi in general,
while the other entries are changing Wi-Fi adapters or adjusting stored Wi-Fi connections respectively.

#figure(
  img("reset_wifi.png", fit: "contain", width: 90%), caption: [ReSet Wi-Fi section],
)<reset_wifi>

The access points themselves are shown in a continuous list, using the same module as implemented in the audio section.

For adjustments to connections, ReSet offers general configuration, basic IPV4 and IPV6 configuration (not complete) and basic security settings.
The settings page is created with individual tabs for each setting, providing a seamless transition for each functionality.
In @reset_wifi_security, the security configuration is visualized.

#figure(
  img("reset_wifi_security.png", fit: "contain", width: 90%), caption: [ReSet Wi-Fi security section],
)<reset_wifi_security>

#pagebreak()

#subsubsection("Bluetooth User Interface")
Bluetooth has the same setup as Wi-Fi, with the only difference being
the differentiation between connected and available devices.

#figure(
  img("reset_bluetooth.png", fit: "contain", width: 90%), caption: [ReSet Bluetooth section],
)<reset_bluetooth>

As mentioned in @UserInterfaceGuidelines ReSet intends to be as consistent as possible, which is why the same style principles were applied to all pages within ReSet.
This ensures that users who can use parts of ReSet will also be able to use other parts without additional knowledge about the application.

#pagebreak()

#subsubsection("Sidebar and Menu")
The sidebar offers simple navigation by click and has a prominent search bar which can also be accessed with a shortcut.
Future entries can be created using the sidebar entry developed for ReSet, with the functionality being handled by a callback function.

#figure(
  sourcecode(
    ```rs
    // callback for sidebar  Wi-Fi click
    pub const HANDLE_WIFI_CLICK: fn(Arc<Listeners>, FlowBox, Rc<RefCell<Position>>) =
        |listeners: Arc<Listeners>, reset_main: FlowBox, position: Rc<RefCell<Position>>| {
        // omitted more setup
            let wifi_box = WifiBox::new(listeners.clone());
            start_event_listener(listeners, wifi_box.clone());
            show_stored_connections(wifi_box.clone());
            scan_for_wifi(wifi_box.clone());
        // omitted more setup
        };

    // template
    pub struct SidebarEntry {
        // omitted other fields
        pub on_click_event: RefCell<SidebarAction>,
    }
    ```,
  ), 
  kind: "code", 
  supplement: "Listing",
  caption: [ReSet sidebar entry],
)<d>

The Menu on the top right is a standard GTK menu, providing a consistent experience with other GTK applications.

#figure(
  img("menu.png", fit: "contain", width: 100pt), caption: [the ReSet popover menu],
)<reset_menu>

#subsubsection("Template Binding")
The user interface is built using the GTK compatible XML markup language. This
allows for a separate user interface definition which reduces code size and
keeps functionality away from design. Alongside this, XML also allows for use of
graphical tools in order to create the user interface itself, providing
immediate feedback about the style and feel of the design.

The binding of these definitions is handled via a GTK specific build.rs file,
which defines GResources that will be integrated into the project. GResources
represent a variety of tools and objects which can be used within the project,
such as user interface templates, icons, images and more.@gresources

#figure(sourcecode(```rs
fn main() {
    glib_build_tools::compile_resources(
        &["src/resources"],
        "src/resources/resources.gresource.xml",
        "src.templates.gresource",
    );
    // more resources omitted
}
```), 
kind: "code", 
supplement: "Listing",
caption: [Example GResources])<build_rs>

For ReSet, the vast majority of the user interface is handled via XML
definitions, with only a fraction being inlined in the code. These inline
definitions are usually temporary containers or need a more dynamic
functionality that is not directly available with XML.

The binding for XML to Rust happens within regular Rust files, with various GTK
macros being used. This means that one can use seemingly regular Rust code,
which the gtk-rs library later restructures to GTK compatible code via Rust
macros. Rust macros are metaprogramming, which means the Rust toolchain will
change the code before compiling it into a binary. For Rust this features
expands to allowing full Rust code withing metaprogramming, making entire
programs possible at compile time.@Rust_macros ReSet currently only uses this
feature via gtk-rs or default macros provided by the standard library,
however, it could become a vital tool for the creation of a plugin system which
is mentioned in @PluginSystem.

#figure(
sourcecode(
// typstfmt::off
```rs
// an example macro from "The Rust Programming Language"
fn impl_hello_macro(ast: &syn::DeriveInput) -> TokenStream {
    let name = &ast.ident;
    let gen = quote! {
        impl HelloMacro for #name {
            fn hello_macro() {
                println!("Hello, Macro! My name is {}!", stringify!(#name));
            }
        }
    };
    gen.into()
}
```,
  ), 
  kind: "code", 
  supplement: "Listing",
  caption: [An example macro from the book: "The Rust Programming Language"@Rust_macros],
)<macro_example>

The binding itself is created via the PImpl (Pointer to Implementation) idiom,
which allows for a generic implementation of an object without immediate
recompilation unless the object itself is changed. As defined by cppreference@pimpl@pimpl_gotw, this
idiom is usually applied in C++, but can also be used with Rust, and is also
recommended to be used by an officially endorsed gtk-rs
introduction.@gtk_rs_introduction

#figure(
sourcecode(
// typstfmt::off
```rs
glib::wrapper! {
    pub struct ListEntry(ObjectSubclass<list_entry_impl::ListEntry>)
    // define GTK classes to inherit from
    @extends gtk::ListBoxRow, gtk::Widget,
    // define interfaces to implement
    @implements gtk::Accessible, gtk::Buildable, gtk::ConstraintTarget, gtk::Actionable;
}

impl ListEntry {
    pub fn new(child: &impl IsA<Widget>) -> Self {
        Object::builder().build()
    }
}
```,
  ), 
  kind: "code", 
  supplement: "Listing",
  caption: [Example Pointer for an XML template],
)<pointer_xml>

In figure @pointer_xml, there are two structs with the name ListEntry,
the first is the pointer which holds generic GTK functionality,
in this case, it will offer everything that the inherited classes provided,
as well as the implemented interfaces.
The second ListEntry is the implementation which will refer to the XML template visualized in @implementation_xml.

#figure(
sourcecode(
// typstfmt::off
```rs
#[derive(Default, CompositeTemplate)]
#[template(resource = "/org/Xetibo/ReSet/resetListBoxRow.ui")]
pub struct ListEntry {
    #[template_child]
    // custom entries that will be included in the template
    pub example: TemplateChild<GTKTYPE>,
}

#[glib::object_subclass]
impl ObjectSubclass for ListEntry {
    const ABSTRACT: bool = false;
    // the name of the created GTK module
    const NAME: &'static str = "resetListBoxRow";
    // the pointer type
    type Type = list_entry::ListEntry;
    type ParentType = gtk::ListBoxRow;
}

// omitted more required setup
```,
  ), 
  kind: "code", 
  supplement: "Listing",
  caption: [Example Implementation for an XML template],
)<implementation_xml>
