#import "../../templates/utils.typ": *

#subsection("Plugin System Implementation")
This section covers the implementation of the ReSet plugin system.

#subsubsection("General Plugin System")

#subsubsection("Any-Variant")

#subsubsection("Security")
The initial idea of the ReSet plugin system was to reduce the attack vector by
enforcing a narrow definition for the plugin system. As the ReSet daemon uses
DBus, each plugin can provide their own DBus interface. For DBus, there are
three different levels which a program can and must provide. The first is the
DBus object, these objects then implement interfaces which in return provide
functions for calling programs. ReSet plugins should only provide a name for the
plugin and functions that will be implemented for the interface. This ensures
that the deamon is the sole authority for adding any interface or object, which
ensures that no plugin can override an existing interface, potentially shadowing
a common interface with a malicious one.

The registration and insertion of interfaces is handled with the crossroads DBus
context shown in figure @dbus_crossroads_register.

#let code = "
let interface = cross.register(interface_name, |c| {
  // functions for DBus
  // provided by plugin -> (plugin.dbus_interface)()
}
cross.insert(dbus_path, &[interface], data);"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Example interface registration for DBus],
    )<dbus_crossroads_register>],
)

During implementation of this system, it was found that the DBus functions would
not be able to be provided by the shared library. Attempting to call
functionality provided by shared libraries would result in the object not being
available. The only way to solve this issue was to provide plugins with a
reference to the crossroads DBus context, which would enable plugins to insert
and register their own interfaces.

#subsubsection("Testing")
Rust tests are handled by a specific test macro, this flag tells the compiler
that this function is to be used when testing the specific project. This works
well for a single project without dynamic loading of additional functionality,
which for ReSet is the plugin system. While it is possible to call arbitrary
functions within a function marked as a test function, it would also bundle all
functions within the test function into one. If ReSet were to call all plugin
tests from one test function, this would enforce that all plugin tests utilize
the same thread and any error would cancel all remaining plugin tests.

// TODO: code of original testing call

In order to solve this issue, ReSet utilizes a different thread spawning
mechanism with a separate printing functionality in order to provide feedback
about each individual plugin test function. This mechanism also allows plugins
to be shown as separate entities with their own tests, ensuring that developers
receive appropriate feedback.

#let code = "
#[tokio::test]
#[cfg(test)]
async fn test_plugins() {
    use re_set_lib::utils::plugin::plugin_tests;
    setup();
    thread::sleep(Duration::from_millis(2000));
    unsafe {
        for plugin in BACKEND_PLUGINS.iter() {
            let name = (plugin.name)();
            let tests = (plugin.tests)();
            plugin_tests(name, tests);
        }
    }
    COUNTER.fetch_sub(1, Ordering::SeqCst);
}"
// TODO: code of new testing call and system
#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Custom plugin test framework],
    )<custom_plugin_tests>],
)

#subsubsection("ReSet-Daemon Plugin System")
