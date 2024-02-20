#import "../templates/utils.typ": *
#lsp_placate()

#section("Plugin System")
Plugin systems offers both the users and the developers of an application to
provide specific implementations for use-cases. Notably, it does this by neither
putting the burden of development on the application developers, while also
providing users with the functionality they explicitly want to use. The notable
downside to this is the development and performance overhead the system itself
has on the application.

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

#subsubsection("Code Patching")
Code patching is technically not a plugin system. With code patching, users need
to change the code of the application themselves in order to achieve the
expected functionality. This type of extensibility is found in a specific set of
open-source applications called "suckless".

While not necessarily part of a plugin system, it is still important to note
that this system requires a soft API/ABI stability. If the developers of the
main applications often make radical changes, then these patches need to be
rewritten for each change, which would make this system completely unfeasible.

#subsubsection("IPC")
Inter Process Communication can be seen as a soft version of a plugin system.
While it doesn't allow users to expand the functionality of the program itself,
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

#subsubsubsection("ABI")
Plugin systems based on dynamic libraries require that the plugins themselves
are built against the current system. In other words, for each specific version
of ReSet and its respective daemon, the plugins would need to be recompiled
again.

Compared to an interpreted language, this is different to the fact that an API
compatible change is not necessarily ABI compatible. For example, changing a
parameter from i64 to i32 would not require a change for the programmer using
the API. However, for the ABI user, this change would likely result in a crash
as the compiled ABI changed.

Changes to function signatures which add or remove paramaters or change the
return type to a non-automatic cast would break API as well, meaning plugins
based on an interpreted system would also need to be rewritten.

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

#subsubsubsection("Architecture")

#subsubsection("Function overriding")
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

To visualize the concept, here is an example of function overriding as parameter
in Rust:
```rs
use once_cell::sync::Lazy;
static mut G_PLUGIN_SYSTEM: Lazy<PluginSystem> = Lazy::new(|| PluginSystem {
    function: Box::new(regular_function),
});

fn main() {
    // The reason for unsafe is the mutability with different threads.
    // With static variables it is possible to access the same Plugin System at the same time.
    // For a real system with different threads, it would be required to put mutable access behind
    // a locking mechanism.
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
```
The output of this program is the regular_function and the second_function after
this, both functions get the dummy data 5 passed to it. In a real world example,
this data could potentially be of the "any" type provided by the any pattern,
which would allow plugins to use custom defined types, even with a statically
typed language such as Rust. Important to note however, is that even with the
any pattern, Rust would still break the ABI compatibility, as memory access
depends on the size of a type.

#subsection("Security")
Security in plugin systems is not an easy task. Developers want to rely on the
plugin system in order to focus on their core systems, however, this puts the
burden of development on other developers, which could potentially have
malicious intentions.

Similar concerns can be seen with browser extensions which are also just
plugins, just for the browser itself. Some organizations require reviews from
developers before publishing an extension to a web based plugin "store", while
the Mozilla developed Firefox requires plugins to be open-source, which hinders
malicious developers from hiding their code.

#subsection("Hooks")

// macros
// dylib explanation -> how load works etc
// potential security mitigations
// testing possibilities
// architecture -> pattern usage?

