#import "../templates/utils.typ": *
#lsp_placate()

#section("Plugin System Analysis")
Plugin systems allow both the users and the developers of an application to
provide specific implementations for use cases. Notably, it does this by neither
putting the burden of development on the application developers, while also
providing users with the functionality they explicitly want to use. The notable
downside to this is the development and performance overhead the system itself
has on the application.

For ReSet, the use case for a plugin system is the wide variety of features that
either a system supports, or the user wants. As an example, it makes no sense to
provide a VR Headset configuration for a system that does not support such
devices. At the same, it is also counterproductive to offer settings for users
that will never be used, for example, touchpad settings on a desktop, here the
system could either detect available devices and load plugins respectively, or
simply give users the ability to gradually control their used plugins.

Specifically for hardware support, a plugin system also covers potential future
hardware, which would require new features to be added to ReSet in order to
support new hardware. A plugin system can alleviate this problem, by offering a
simpler extension mechanism.

#subsection("High Level Architecture")

ReSet follows a multi-process paradigm. This ensures that users have the option
to avoid the graphical user interface of ReSet if they wish to. The parts of
ReSet is therefore split into the daemon, which handles the functionality as a
constant running service, while ReSet itself refers to the graphical user
interface which will interact with the daemon via Dbus (Inter Process
Communication).

In @base_plugin_architecture the intended architecture of the plugin system is
visualized.
#align(
  center, [#figure(
      img("architecture.svg", width: 80%, extension: "files"), caption: [Architecture of ReSet],
    )<base_plugin_architecture>],
)

The intention is that each plugin will offer three parts for ReSet. The first
part is the functionality itself, as an example, a monitor configuration plugin
would need the ability to apply various resolutions to monitors. This
functionality would then be offered by the plugin via a function or similar.

The next part of the plugin is the DBus interface, this interface can be
directly injected into the existing DBus server provided by the ReSet daemon,
providing users with locality transparency, meaning users will not see the
difference between a plugin interface, and the core interfaces provided by ReSet
out of the box.

The third part of a plugin is a user interface widget, which can be integrated
into the ReSet user interface application. Notably, this is optional, as users
can choose to not use the user interface, and instead interact with ReSet via
DBus.

#subsection("Plugin System Variants")
In this section, different variants of plugin systems are discussed.

#subsubsection("Interpreted Languages")
Interpreted languages can be run on top of the original application in order to
provide on-the-fly expansion of functionality. In this case, the included
interpreter uses functions within the application when certain functions are
called by the interpreted language.

#subsubsubsection("Custom Scripting Language")
Creating a custom language just for a plugin system serves two potential use
cases. The first would be security concerns which are explained in @Security.
The idea is that with custom scripting languages, it is possible to limit the
functionality of the language, making it infeasible or harder for malicious
developers to abuse the plugin system. The second use case is the simplification
of functionality for potential plugin developers. For ReSet, this could mean
creating ReSet-specific user interface elements with a single function call.
However, this could also be potentially implemented with a library for an
existing language.

#subsubsubsection("Turing Complete")
A simplified version of the meaning of Turing completeness for a programming
language is whether the language can simulate the Turing machine (simplest
possible computer). If the language can simulate a Turing machine, it would
imply that the language has access to potential infinite loops and can therefore
not be restricted in terms of functionality. In other words, if the language is
Turing complete, any functionality that any other language can create is
possible to be implemented. Turing incomplete languages on the other
hand only offers a specific and limited set of functionalities, which cannot
under any circumstance be extended upon without changing the language
specification itself. @turing

The security aspect is likely the biggest factor in choosing to create a custom
scripting language. Here the use of Turing incomplete languages is the most
effective. It enforces limited functionality, which can severely limit the
attack vectors compared to a Turing complete language. The downside of this
approach is that only plugins with a supported use case can be created.

An example of a Turing incomplete language is the markup language HTML. It
only offers specific tags which cannot create any functionality beyond the
documented functionality. @html

#subsubsubsection("Error Handling")
A big benefit of this system is the abstraction between the original application
and the interpreted language. It allows the two parties to exist relatively
independently of each other. This includes errors, which ensures that an error
in the interpreted language does not lead to a full crash of the application.

As an example, browsers use the same independent error handling for web pages,
hence when a webpage encounters issues, the browser itself is still usable.

#subsubsubsection("Language Requirements")
A soft requirement of an interpreted language for plugins is the simplification
of creating a plugin for potential plugin developers. If this requirement is not
fulfilled, then the interpreted language does not offer any benefit other than
slight security improvements if the language is non-turing complete.

The second requirement is interoperability with both the programming
languages of the base system and any technology that is used within the base
system. For ReSet, this would be Rust and GTK as the main technologies.

#subsubsubsection("Architecture")
in @interpreted_languages_plugin the architecture of a plugin system with
interpreted languages are visualized.
#align(
  center, [#figure(
      img("interpreted_languages.svg", width: 80%, extension: "files"), caption: [Architecture of a potential interpreted plugin system.],
    )<interpreted_languages_plugin>],
)

#subsubsection("Code Patching")
Code patching is technically not a plugin system. With code patching, users need
to change the code of the application themselves in order to achieve the
expected functionality. This type of extensibility is found in a specific set of
free and open-source applications called "suckless". @suckless

While not necessarily part of a plugin system, it is still important to note
that this system requires a soft API/ABI stability. If the developers of the
main applications often make radical changes, then these patches need to be
rewritten for each change, which would make this system completely infeasible.

Suckless specifically targets the Unix philosophy of "do one thing and do it
well".@unixwikipedia @unixcentury While ReSet is not opposed to this philosophy,
ReSet does intend to offer more than one functionality by utilizing a plugin
system in the first place. ReSet will therefore not pursue this approach.

#subsubsection("IPC")
Inter-Process Communication can be seen as a soft version of a plugin system.
While it does not allow users to expand the functionality of the program itself,
it does allow users to wrap the program by using the provided IPC and expanding
it with new functions.

ReSet itself is made with this idea in mind, expanding on existing functionality
for Wi-Fi, audio and more.

IPC has a major limitation, while the backend can be implemented solely with IPC
by creating a new process that will handle the new functionality, the frontend
cannot be expanded by just using IPC, hence this is not a system that can be
fully applied to ReSet. On top of this, requiring a new process for each
functionality would break the locality transparency which was defined as a
requirement for ReSet in @Non-FunctionalRequirements.

#subsubsection("Dynamic Libraries")
Dynamic libraries can be used in order to load specific functions during
runtime. This allows developers to load either specific files or all files
within a folder or similar, which will then be used to execute specified
functions for the application.

In order for this interaction to work, the plugin must implement all functions
that the application requires, meaning the code has to be contained within the
framework of the developer of the application.

// TODO: Explain loader -> ELF loader

#subsubsubsection("Example")
For Rust, the crate "libloading" handles the mapping of C functions to Rust in a
simple fashion. This allows a straightforward usage of dynamic libraries. Figure
@rust_dynamic_libary_loading visualizes a simple dynamic library with a single
function.

#let code = "
// code in the calling binary
fn main() {
    unsafe {
        let lib = libloading::Library::new(\"./testlib/target/debug/libtestlib.so\")
            .expect(\"Could not open library.\");
        let func: libloading::Symbol<unsafe extern \"C\" fn(i32) -> i32> =
            lib.get(b\"test_function\").expect(\"Could not load function.\");
        assert_eq!(func(2), 4);
        println!(\"success\");
    }
}

// code in the dynamic library
#[no_mangle]
pub extern \"C\" fn test_function(data: i32) -> i32 {
    data * data
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Dynamic library loading in Rust],
    )<rust_dynamic_libary_loading>],
)

In @rust_dynamic_libary_loading, the dynamic library has the annotation "no_mangle".
This flag tells the compiler to not change the identity of the specified
designator. Without this, functions and variables will not be found with the
original names. Mangling is further explained in section @Mangling.

Additionally, in both the dynamic library and the calling binary, the flag "extern
C" is used. This is required as Rust does not guarantee ABI stability, meaning
that without this flag, a dynamic library with compiler version A might not
necessarily be compatible with the binary compiled with compiler version B.
Hence, Rust and other languages use the C ABI to ensure ABI stability.

The lack of a stable Rust ABI is also the reason why there are no Rust native
shared libraries. Crates, as found on crates.io, are static libraries that are
compiled into the binary, and all shared libraries are created with the C ABI
using "extern C". Further information about ABI along with examples can be found
in @ApplicationBinaryInterfaceABI.

#subsubsubsection("Containerization of dynamic libraries")
Plugin systems have a variety of points to hook a dynamic library into the
application. The easiest is to just execute plugin functions at a certain point
in the application. As an example, loading various settings in ReSet would mean
looping through dynamic libraries and loading their respective user interfaces
to show in ReSet. This approach is plausible and proven to work by a variety of
existing plugin systems, however, it also has a major shortcoming. The moment
the plugin crashes, the application has to either handle this unknown error or
worse, if the error is not recoverable, the entire application crashes. This can
lead to potential instability with plugins of different versions using different
ABIs or simply due to bugs in a plugin.

To handle this case, a plugin system can also containerize plugins to run in
their thread or process to provide independent error handling. This allows an
application to recover even when a plugin exits abnormally while using
resources.

In @rust_thread_panic and @thread_panic_screenshot the use of simple Rust
threads guarantees the continuation of the invoking thread, meaning the
underlying application can continue to run even though the spawned thread
encountered a fatal error.

#let code = "
fn main() {
    thread::spawn(|| {
        library_function();
        // encapsulated functionality
    });
    // program should still get this input even if the thread crashes
    let mut buffer = String::new();
    io::stdin().read_line(&mut buffer);
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Thread panic example],
    )<rust_thread_panic>],
)

#align(
  center, [#figure(
      img("thread_panic.png", width: 100%, extension: "figures"), caption: [Thread panic result],
    )<thread_panic_screenshot>],
)

While the runtime guarantee is a benefit of this system, it also requires
thread-safe synchronization of resources. This would incur a performance penalty
on the entire system as even the native application services would now need to
use synchronization when accessing data.

On top of this, when a plugin encounters a fatal error, this should not only be
communicated to the user, but potential interactions with the now-lost plugin
need to be removed. This might happen when plugins communicate with each other,
or when multiple plugin systems are in place.

#pagebreak()

#subsubsubsection("Architecture")
In @dynamic_libraries_plugin_system, the architecture of a plugin system with
dynamic libraries are visualized.
#align(
  center, [#figure(
      img("dynamic_libraries.svg", width: 100%, extension: "files"), caption: [Architecture of a dynamic library plugin system.],
    )<dynamic_libraries_plugin_system>],
)

#subsubsection("Function Overriding")
Function overriding is a variant of dynamic plugins which will override existing
functionality instead of just expanding it. This type of functionality provides
more control to the plugin developers, but also requires more maintenance from
the plugin system developers and is more prone to breaking changes, as plugins
interact more closely with the original system.

An existing plugin system with this variant is the GNOME Shell. This application
is used on top of the GNOME Compositor to provide users with various user
interfaces such as a status bar, notifications, and more. As GNOME-Shell is
written in JavaScript, the overriding of functions is comparatively straight
forward, meaning there are no type issues with extensions. Compared to using the
ABI for compiled languages, this variant also means that just changing the
integer variant does not break compatibility with existing extensions.

Using JavaScript for this use case also creates a bind, namely, it is no longer
possible to split extensions, as JavaScript is a single-threaded system. This
means that each extension that can crash, would also take down the GNOME-Shell
as collateral.

To visualize the concept, @rust_function_overriding provides an example of
function overriding as a parameter in Rust:

#let code = "
use once_cell::sync::Lazy;
static mut G_PLUGIN_SYSTEM: Lazy<PluginSystem> = Lazy::new(|| PluginSystem {
    function: Box::new(regular_function),
});

fn main() {
    // The reason for unsafe is the mutability with different threads.
    // With static variables it is possible to access the same Plugin System
    // at the same time.
    // For a real system with different threads,
    // it would be required to put mutable access behind a locking mechanism.
    unsafe {
        G_PLUGIN_SYSTEM.call(5);
        // this override can be done with a dynamic library or IPC
        G_PLUGIN_SYSTEM.override_function(second_function);
        G_PLUGIN_SYSTEM.call(5);
    }
}

fn regular_function(data: i32) {
    println!(\"This is the first function: {}\", data);
}

fn second_function(data: i32) {
    println!(\"This is the second function: {}\", data);
}

struct PluginSystem {
    function: Box<fn(i32)>,
}

impl PluginSystem {
    fn override_function(&mut self, new_function: fn(i32)) {
        self.function = Box::new(new_function);
    }

    fn call(&self, data: i32) {
        (self.function)(data);
    }
}
"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Function overriding example in Rust],
    )<rust_function_overriding>],
)

The output of this program is the regular_function and the second_function after
this, both functions get the dummy data 5 passed to it. In a real-world example,
this data could potentially be of the "any" type provided by the any pattern,
which would allow plugins to use custom-defined types, even with a statically
typed language such as Rust. Important to note, however, is that even with the
any pattern, Rust would still break the ABI compatibility, as memory access
depends on the size of a type.

#pagebreak()

#subsubsubsection("Example Any pattern")
In @rust_any_pattern an example any pattern implementation is visualized.

#let code = "
fn main() {
    let penguin = Example {
        name: \"penguin\".to_string(),
        age: 29,
    };
    let any_penguin = penguin.to_any();
    let restored_penguin = Example::from_any(any_penguin);
    assert_eq!(penguin, restored_penguin);
    println!(\"Success\");
}

trait AnyImpl {
    fn to_any(&self) -> Any;
    fn from_any(any: Any) -> Self;
}

struct Any {
    // holds the data of all fields
    data: Vec<u8>,
    // determinant splits data vector back to fields
    determinants: Vec<usize>,
}

#[derive(PartialEq, Eq, Debug)]
struct Example {
    name: String,
    age: u32,
}

impl AnyImpl for Example {
    // This is just an example, could also be done with a Hashmap or similar
    fn to_any(&self) -> Any {
        let data = self.name.as_bytes();
        let determinants = vec![data.len()];
        let data = [data, &self.age.to_ne_bytes()].concat();
        Any { data, determinants }
    }

    fn from_any(any: Any) -> Self {
        let (name, age) = any.data.split_at(*any.determinants.last().unwrap());
        let name = String::from_utf8(name.to_vec()).unwrap();
        let age = u32::from_ne_bytes(age.try_into().unwrap());
        Self { name, age }
    }
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Any pattern example in Rust],
    )<rust_any_pattern>],
)


#pagebreak()

#subsection("Security")
Developers want to rely on the plugin system in order to focus on their core
systems, however, this puts the burden of development on other developers, which
could potentially have malicious intentions.

Similar concerns can be seen with browser extensions which are also just
plugins, just for the browser itself. Some organizations require reviews from
developers before publishing an extension to a web-based plugin "store", making
it harder for malicious code to be published as an extension. @chrome-policy

While researching systems, two potential mitigations for security concerns could
be of interest for ReSet. The first is simply enforcing plugins to use an open
license. This could be done with a copy-left license which would enforce that
any code utilizing code of ReSet would also need to provide their source code
with the same license. Currently, ReSet is already distributed under the GNU
General Public License V3-or-later, which would apply the copy-left nature.
Issues with this approach occur with legal questions, as enforcing copy-left
licensing is not trivial, nor could code realistically be enforced to be used
while utilizing shared libraries as the plugin system. It is also important to
note that this would not make malicious plugins impossible, but it would signal
to users that any proprietary plugin is by default against the terms of the
license and therefore not to be trusted. @GNU_V3

The second mitigation would require the users' permission in order for a plugin
to be included in ReSet. This could be done by creating a hash of the plugin,
encrypting it with a password chosen by the user and storing this hash within a
database (usually a secrets wallet). Should the plugin hash not be within the
database upon startup, the user would be prompted for permission before loading
the plugin. The challenge with this approach is the inclusion of an
authentication mechanism. In order to facilitate this mechanism, ReSet could
utilize the keyring functionality. This ensures that a user has a singular
database that is not controlled by ReSet. The downside to this would be the
dependency on keyrings themselves. @GNOME-Keyring @Keyring-Rust

//#subsection("Hooks")
//// TODO: which section is it referring to?
//Hooks for the plugin system refer to section in the code where the plugin
//applies its functionality. When looking back at the ABI plugin example in
//@rust_dynamic_libary_loading, this would be the call of the function inside the
//plugin system struct. For the example in @rust_function_overriding it would
//instead be the overridden function.
//
//// TODO: why is this important?
//// TODO: Security concerns? Potential uninitialized resources etc.
//// TODO: Providing a consistent environment for plugins in order for them to not crash
#pagebreak()
#subsection("Testing")
ReSet does not yet have a testing system implemented, only regular Rust tests
are currently implemented, and those do not cover the full usage of the DBus API
specified for ReSet. This is due to a lack of consistency with the features that
ReSet provides. For example, without a mock implementation of the
NetworkManager, it would not be possible to consistently connect to an access
point. For this reason, all DBus interfaces must offer a mock implementation in
order for it to be tested.

The second issue comes with the user interface, here regular Rust tests are
meaningless. ReSet would need to use a GTK-compatible UI-testing toolkit.

After building this testing system, plugins can then also make use of this
system by offering integration and unit tests for their use cases. This ensures
that the plugin does not just work standalone, which would include specific
functionality but also works in the entire system, which would cover the use
inside ReSet by DBus and user interfaces.// TODO: Integration tests

// TODO: How to connect with the rest of the system

In @plugin_integration_test, the architecture of the plugin system integrated
into the testing framework is visualized.
#align(
  center, [#figure(
      img("plugin_integration_test.svg", width: 80%, extension: "files"), caption: [Architecture of the ReSet testing framework],
    )<plugin_integration_test>],
)

#pagebreak()

#subsubsection("GTK Tests")
There is a GTK testing framework for Rust, which is called "gtk-test". This
crate allowed for an easy way of creating tests for the user interface of ReSet.
As an example, the following code snippet is taken from the repository page and
shows how to test the change of a string in a label. @GTKTests

#let code = "
fn main() {
    let (window, label, container) = init_ui();

    assert_text!(label, \"Test\");
    window.activate_focus();
    gtk_test::click(&container);
    gtk_test::wait(1000);
    assert_text!(label, \"Clicked\");
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [gtk-test example],
    )<gtk_test_example>],
)

Unfortunately, that crate does not seem to be maintained anymore and is not
compatible with GTK4 anyway. The general idea behind it was still useful and
could be used to implement a new solution. Instead of returning each UI element
in a tuple, saving it into a singleton would be much easier, especially when
there are many UI widgets or dynamically generated widgets. These can then be
easily accessed and manipulated during the tests.

#let code = "
struct TestSingleton {
    window: Option<Rc<gtk::Window>>,
    buttons: HashMap<String, Rc<gtk::Button>>,
    labels: HashMap<String, Rc<gtk::Label>>,
    checkbox: HashMap<String, Rc<gtk::CheckButton>>,
    comboRow: HashMap<String, Rc<adw::ComboRow>>,
    // ...
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Structure of singleton],
    )<structure_of_singleton>],
)

The idea is to save a reference to each widget that is going to be tested in a
hashmap of its corresponding class with a string to identify it. The special
case is the window because there is only one instance of it.

#let code = "
let main = gtk::Box::new(Horizontal, 5);
let entryRow = Rc::new(EntryRow::new());
let button2 = Rc::new(Button::new());
let button1 = Rc::new(Button::new());
let label = Rc::new(Label::new(Some(\"nothing\")));

entryRow.connect_changed(move |entry| {
    match Ipv4Addr::from_str(entry.text().as_str()) {
        Ok(_) => entry.add_css_class(\"success\"),
        Err(_) => entry.add_css_class(\"error\")
    }
});

let entryRow_ref = entryRow.clone();
let label_ref = label.clone();
button1.connect_activate(move |_| { entryRow_ref.set_text(\"192.168.1.100\"); });
button2.connect_activate(move |_| { label_ref.set_text(\"button clicked\"); });

let window = Rc::new(Window::builder().application(app).child(&main).build());
unsafe {
    SINGLETON.buttons.insert(\"button1\".to_string(), button1.clone());
    SINGLETON.buttons.insert(\"button2\".to_string(), button2.clone());
    SINGLETON.labels.insert(\"testlabel\".to_string(), label.clone());
    SINGLETON.entryRow.insert(\"entryrow\".to_string(), entryRow.clone());
    SINGLETON.window = Some(window.clone());
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Setting up a simple UI],
    )<setting_up_simple_ui>],
)

#let code = "
#[test]
#[gtk::test]
    let func = || unsafe {
        // test label text change after button click
        let label = SINGLETON.labels.get(\"testlabel\").unwrap();
        assert_eq!(label.text(), \"nothing\");
        let button = SINGLETON.buttons.get(\"button2\");
        button.unwrap().activate();
        assert_eq!(label.text(), \"button clicked\");

        // test entryRow css class change after button click
        let entryRow = SINGLETON.entryRow.get(\"entryrow\").unwrap();
        assert_eq!(entryRow.css_classes().len(), 2); // 2 default css classes
        let button1 = SINGLETON.buttons.get(\"button1\");
        button1.unwrap().activate();
        assert_eq!(entryRow.has_css_class(\"success\"), true);
        SINGLETON.window.clone().unwrap().close();
        exit(0);
    };
    setup_gtk(func);
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [UI test],
    )<example_ui_test>],
)

This code creates a few UI widgets with some binding to some signals. These
signals can be activated by calling specific functions. The tests then get the
references in the singleton and call functions that imitate click actions on
buttons.

#pagebreak()

This approach unfortunately suffers from inefficiency due to the amount of
boilerplate code and unnecessary compilation overhead it creates. Storing
references to UI widgets in a singleton may simplify access for tests but is not
needed at all by users.

#subsubsection("GTK Test Macros")
Macros as elaborated in @Macros can be used to abstract the testing framework
from different compilation targets. This means ReSet can drop the testing
apparatus for release binaries which will benefit from better performance
without the debug version suffering from reduced testing capabilities.

In @ui_test_macro_implementation an example macro for the test introduced in
@example_ui_test is visualized.

#let code = "
// debug version
#[cfg(debug_assertions)]
macro_rules! TestButton {
    ( $button_name:expr ) => {{
        let button = Rc::new(gtk::Button::new());
        unsafe {
            SINGLETON.buttons.insert($button_name, button.clone());
        }
    }};
}

// release version
#[cfg(not(debug_assertions))]
macro_rules! TestButton {
    ( $button_name:expr ) => {
        // drop name -> unused
        gtk::Button::new()
    };
}

// usage
let button3 = TestButton!(\"macro_button\".to_string());
unsafe {dbg!(SINGLETON.buttons.clone());}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Macro Implementation],
    )<ui_test_macro_implementation>],
)

After compiling both versions of this test, the results in @macrodebug and
@macrorelease show that the additional button reference in the testing singleton
can no longer be found within the release version. Similarly, it is possible to
also remove the entire singleton, or at least the underlying data for the
release version.

#columns(
  2, [
    #align(
      center, [#figure(
          img("test_macro_debug.png", width: 100%, extension: "figures"), caption: [Macro Debug Version],
        )<macrodebug>],
    )
    #colbreak()
    #v(35pt)
    #align(
      center, [#figure(
          img("test_macro_release.png", width: 100%, extension: "figures"), caption: [Macro Release Version],
        )<macrorelease>],
    )
  ],
)

// todo write stuff macros

