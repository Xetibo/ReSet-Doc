#import "../templates/utils.typ": *
#lsp_placate()

#section("Plugin System")
Plugin systems offers both the users and the developers of an application to
provide specific implementations for use-cases. Notably, it does this by neither
putting the burden of development on the application developers, while also
providing users with the functionality they explicitly want to use. The notable
downside to this is the development and performance overhead the system itself
has on the application.

For ReSet, the use case for a plugin system is the wide variety of features that
either a system supports, or the user wants. As an example, it makes no sense to
provide VR Headset configuration for a system that does not support such
devices. At the same, it is also counterproductive to offer settings for users
that will never be used, for example touchpad settings on a desktop, here the
system could either detect available devices and load plugins respectively, or
simply give users the ability to gradually control their used plugins.

#subsection("High Level Architecture")
In @base_plugin_architecture the intended architecture of the plugin system is
visualized.
#align(
  center, [#figure(
      img("architecture.svg", width: 100%, extension: "files"), caption: [Architecture of ReSet],
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
In this section different variants of plugin systems are discussed and compared.

#subsubsection("Interpreted Languages")
Interpreted languages can be run on top of the original application in order to
provide on the fly-expansion of functionality. In this case the included
interpreter uses functions within the application when certain functions are
called by the interpreted language.

#subsubsubsection("Error Handling")
A big benefit with this system is the abstraction between the original
application and the interpreted language. It allows the two parties to exist
relatively independent of each other. This includes errors, which ensures that
an error on the interpreted language does not lead to a full crash of the
application.

As an example, browsers use the same independent error handling for webpages,
hence when a webpage encounters issues, the browser itself is still usable.

#subsubsubsection("Language Requirements")

#subsubsubsection("Architecture")
in @interpreted_languages_plugin the architecture of a plugin system with
interpreted languages is visualized.
#align(
  center, [#figure(
      img("interpreted_languages.svg", width: 100%, extension: "files"), caption: [Architecture of a potential interpreted plugin system.],
    )<interpreted_languages_plugin>],
)

#subsubsection("Code Patching")
Code patching is technically not a plugin system. With code patching, users need
to change the code of the application themselves in order to achieve the
expected functionality. This type of extensibility is found in a specific set of
open-source applications called "suckless".

While not necessarily part of a plugin system, it is still important to note
that this system requires a soft API/ABI stability. If the developers of the
main applications often make radical changes, then these patches need to be
rewritten for each change, which would make this system completely infeasible.

#subsubsection("IPC")
Inter Process Communication can be seen as a soft version of a plugin system.
While it does not allow users to expand the functionality of the program itself,
it does allow users to wrap the program by using the provided IPC and expanding
it with new functions.

ReSet itself is made with this idea in mind, expanding on existing functionality
for Wi-Fi, audio and more.

#subsubsubsection("Architecture")

#subsubsection("Dynamic Libraries")
Dynamic libraries can be used in order to load specific functions during
runtime. This allows developers to load either specific files, or all files
within a folder or similar, which will then be used to execute specified
functions for the application.

In order for this interaction to work, the plugin must implement all functions
that the application requires, meaning the code has to be contained within the
framework of the developer of the application.

// TODO: Explain loader -> ELF loader

#subsubsubsection("Example")
For Rust, the crate "libloading" handles the mapping of C functions to Rust in a
simple fashion. This allows a straight forward usage of dynamic libraries.
Figure @rust_dynamic_libary_loading visualizes a simple dynamic library with a
single function.

//typstfmt::off
#align(left, [#figure(sourcecode(```rs
// code in the calling binary
fn main() {
    unsafe {
        let lib = libloading::Library::new("./testlib/target/debug/libtestlib.so")
            .expect("Could not open library.");
        let func: libloading::Symbol<unsafe extern "C" fn(i32) -> i32> =
            lib.get(b"test_function").expect("Could not load function.");
        assert_eq!(func(2), 4);
        println!("success");
    }
}

// code in the dynamic library
#[no_mangle]
pub extern "C" fn test_function(data: i32) -> i32 {
    data * data
}
```),
kind: "code",
supplement: "Listing",
caption: [Dynamic library loading in Rust])<rust_dynamic_libary_loading>])
//typstfmt::on

In figure @rust_dynamic_libary_loading, the dynamic library has the annotation "no_mangle". This
flag tells the compiler to not change the identity of the specified designator.
Without this, functions and variables will not be found with the original names.
Mangling is further explained in section @Mangling.

Additionally, in both the dynamic library and the calling binary, the flag "extern
C" is used. This is required as Rust does not guarantee ABI stability, meaning
that without this flag, a dynamic library with compiler version A might not
necessarily be compatible with the binary compiled with compiler version B.
Hence, Rust and other languages use the C ABI to ensure ABI stability.

The lack of a stable Rust ABI is also the reason as to why there are no Rust native shared libraries.
Crates as found on crates.io are static libraries which are compiled into the binary,
and all shared libraries are created with the C ABI using "extern C".
Further information about ABI along with examples can be found in @ABI.

#subsubsubsection("Containerization of dynamic libraries")
Plugin systems have a variety of points to hook a dynamic library into the
application. The easiest is to just execute plugin functions at a certain point
in the application. As an example, for loading various settings in ReSet, this
would mean looping through dynamic libraries and loading their respective user
interfaces to show in ReSet. This approach is plausible and proven to work by a
variety of existing plugin systems, however it also has a major shortcoming. The
moment the plugin crashes, the application has to either handle this unknown
error, or worse, if the error is not recoverable, the entire application
crashes. This can lead to potential instability with plugins of different
versions using different ABIs or simply due to bugs in a plugin.

To handle this case, a plugin system can also containerize plugins to run in
their own thread or process to provide independent error handling. This allows
an application to recover even when a plugin exits abnormally while using
resources.

In @rust_thread_panic and @thread_panic_screenshot the use of simple Rust threads guarantees the
continuation of the invoking thread, meaning the underlying application can
still continue to run even though the spawned thread encountered a fatal error.

//typstfmt::off
#align(left, [#figure(sourcecode(```rs
fn main() {
    thread::spawn(|| {
        library_function();
        // encapsulated functionality
    });
    // program should still get this input even if the thread crashes
    let mut buffer = String::new();
    io::stdin().read_line(&mut buffer);
}
```),
kind: "code",
supplement: "Listing",
caption: [Thread panic example])<rust_thread_panic>])
//typstfmt::on

#align(
  center, [#figure(
      img("thread_panic.png", width: 100%, extension: "figures"), caption: [Thread panic result],
    )<thread_panic_screenshot>],
)

While the runtime guarantee is a benefit of this system, it also requires thread
safe synchronization of resources. This would incur a performance penalty on the
entire system as even the native application services would now need to use
synchronization when accessing data.

On top of this, when a plugin encounters a fatal error, this should not only be
communicated to the user, but potential interactions with the now lost plugin
need to be removed. This might happen when plugins communicate with each other,
or when multiple plugin systems are in place.

#pagebreak()

#subsubsubsection("Architecture")
In @dynamic_libraries_plugin_system, the architecture of a plugin system with
dynamic libraries is visualized.
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

An existing plugin system with this variant is the Gnome-Shell. This application
is used on top of the Gnome Compositor to provide users with various user
interfaces such as a status bar, notifications, and more. As Gnome-Shell is
written in JavaScript, the overriding of functions is comparatively straight
forward, meaning there are no type issues with extensions. Compared to using the
ABI for compiled languages, this variant also means that just changing the
integer variant does not break compatibility with existing extensions.

Using JavaScript for this use case also creates a bind, namely, it is no longer
possible to split extensions, as JavaScript is a single-threaded system. This
means that each extension that can possibly crash, would also take down the
Gnome-Shell as collateral.

To visualize the concept, @rust_function_overriding provides an example of
function overriding as parameter in Rust:

//typstfmt::off
#align(left, [#figure(sourcecode(```rs
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
    println!("This is the first function: {}", data);
}

fn second_function(data: i32) {
    println!("This is the second function: {}", data);
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
```),
kind: "code",
supplement: "Listing",
caption: [Function overriding example in Rust])<rust_function_overriding>])

The output of this program is the regular_function and the second_function after
this, both functions get the dummy data 5 passed to it. In a real world example,
this data could potentially be of the "any" type provided by the any pattern,
which would allow plugins to use custom defined types, even with a statically
typed language such as Rust. Important to note however, is that even with the
any pattern, Rust would still break the ABI compatibility, as memory access
depends on the size of a type.

#subsubsubsection("Example Any pattern")
In @rust_any_pattern an example any pattern implementation is visualized.

#align(left, [#figure(sourcecode(```rs
fn main() {
    let penguin = Example {
        name: "penguin".to_string(),
        age: 29,
    };
    let any_penguin = penguin.to_any();
    let restored_penguin = Example::from_any(any_penguin);
    assert_eq!(penguin, restored_penguin);
    println!("Success");
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
}
```),
kind: "code",
supplement: "Listing",
caption: [Any pattern example in Rust])<rust_any_pattern>])
//typstfmt::on

#subsection("Custom Scripting Language")
Creating a custom language just for a plugin system serves two potential use
cases. The first would be security concerns which are explained in @Security.
The idea is that with custom scripting languages, it is possible to limit the
functionality of the language, making it infeasible or harder for malicious
developers to abuse the plugin system. The second use case is the simplification
of functionality for potential plugin developers. For ReSet, this could mean
creating of ReSet specific user interface elements with a single function call.
However, this could also be potentially implemented with a library for an
existing language.

#subsubsection("Turing Complete")
The security aspect is likely the biggest factor for choosing to create a custom
scripting language. Here the use of non-turing complete language is the most
effective. It enforces limited functionality, which can severely limit the
attack vectors compared to a turing complete language. The downside of this
approach is that only plugins with a supported use-case can be created.

#subsection("Security")
Security in plugin systems is not an easy task. Developers want to rely on the
plugin system in order to focus on their core systems, however, this puts the
burden of development on other developers, which could potentially have
malicious intentions.

Similar concerns can be seen with browser extensions which are also just
plugins, just for the browser itself. Some organizations require reviews from
developers before publishing an extension to a web based plugin "store", making
it harder for malicious code to be published as an extension.

#subsection("Hooks")
Hooks for the plugin system refer to section in the code where the plugin
applies its functionality. When looking back at the ABI plugin example in @rust_dynamic_libary_loading,
this would be the call of the function inside the plugin system struct. For the
example in @rust_function_overriding it would instead be the overridden function.

// TODO: why is this important?
// TODO: Security concerns? Potential uninitialized resources etc.
// TODO: Providing a consistent environment for plugins in order for them to not crash
#subsection("Testing")
ReSet does not yet have a testing system implemented, only regular Rust tests
are currently implemented, and those do not cover the full usage of the DBus API
specified for ReSet. This is due to a lack of consistency with the features that
ReSet provides. For example, without a mock implementation of the
NetworkManager, it would not be possible to consistently connect to an access
point. For this reason, all DBus interfaces must offer a mock implementation in
order for it to be tested.

The second issue comes with the user interface, here regular Rust tests are
meaningless. ReSet would need to use a GTK compatible UI-testing toolkit.
Fortunately this exists for the GTK-rs crate, created by the same development
team @GTKTests.

After building this testing system, plugins can then also make use of this
system by offering integration and unit tests for their use cases. This ensures
that the plugin does not just work standalone, which would include specific
functionality, but also works in the entire system, which would cover the use
inside ReSet by DBus and user interfaces.// TODO: Integration tests

// TODO: How to connect with the rest of the system

In @plugin_integration_test, the architecture of the plugin system integrated
into the testing framework is visualized.
#align(
  center, [#figure(
      img("plugin_integration_test.svg", width: 100%, extension: "files"), caption: [Architecture of the ReSet testing framework],
    )<plugin_integration_test>],
)

#subsubsection("GTK Tests")
// TODO

#subsection("Macros")
// TODO: Why are these important?
// TODO: How to they interact with plugins

