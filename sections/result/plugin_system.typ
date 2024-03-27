#import "../../templates/utils.typ": *

#subsection("Plugin System Implementation")
This section covers the implementation of the ReSet plugin system.

#subsubsection("General Plugin System")

#subsubsection("Any-Variant")
in @ExampleAnypattern an Any-Variant via byte vectors is covered. For ReSet, a
different route was taken to implement the Any variant. Instead of converting
byte vectors, ReSet utilizes polymorphism with types that implement a specific
trait. For ReSet this would be implementing the TVariant trait visualized in
@TVariant.

#let code = "
pub trait TVariant: Debug + Any + Send {
    // enables the type to be converted to the Variant struct
    fn into_variant(self) -> Variant;
    // converts the type to a polymorphic unique pointer
    fn value(&self) -> Box<dyn TVariant>;
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [TVariant trait],
    )<TVariant>],
)

This Trait is combined with the struct shown in @Variant.

#let code = "
#[derive(Debug)]
#[repr(C)]
pub struct Variant {
    // converted value
    value: Box<dyn TVariant>,
    // rusts type id used to check for valid casts
    kind: TypeId,
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Variant struct],
    )<Variant>],
)

Comparing this to a language like Java highlights both the complexity of Rust as
well as the clear difference in paradigm. In Java, all reference types are
linked to a garbage collector as well as equipped with a virtual table, which
means that lifetimes, allocation and de-allocation, as well as casting is
handled automatically and enforced for all safe Java code. With Rust, a garbage
collector does not exist, and virtual tables are an opt-in feature, as using by
default would introduce performance overhead. For the Any variant, this virtual
table is desired, as we would like the original value back when calling the "value"
function.

#let code = "
public interface IAny<T> {
  // public T into_variant();
  // This is not necessary as java doesn't support arbitrary interface
  // implementation for existing types.
  public T value();
}

public class IntAny implements IAny<Integer> {
  private Integer value;

  public IntAny(Integer value) {
    this.value = value;
  }

  @Override
  public Integer value() {
    return this.value;
  }
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "java")), kind: "code", supplement: "Listing", caption: [Any variant in Java],
    )<any_java>],
)

When comparing @Variant and @any_java, there is also the use of the unique
pointer Box<\T\> in Rust. This unique pointer is used to ensure that the Any
variant will always have the same allocation size. Omitting this pointer would
enforce that the values within the variant are stored inside the variant struct
without indirection. Given different possible value types, Rust could no longer
determine the size of a specific variant at compile time, hence a pointer is
used to mimick the behavior of Java (enforcement of references).

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

#subsubsection("Plugin Testing")
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
In this section, the specific implementation of the plugin system in the ReSet
daemon is discussed.

For the daemon, the functions defined in @daemon_plugin_functions are required.

#let code = "
extern \"C\" {
    pub fn backend_startup();
    pub fn backend_shutdown();

    /// Reports the capabilities that your plugin will provide.
    #[allow(improper_ctypes)]
    pub fn capabilities() -> PluginCapabilities;

    /// Reports the name of the plugin
    #[allow(improper_ctypes)]
    pub fn name() -> String;

    /// Inserts your plugin interface into the dbus server.
    #[allow(improper_ctypes)]
    pub fn dbus_interface(cross: &mut Crossroads);

    pub fn backend_tests();
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [ReSet Daemon plugin functions],
    )<daemon_plugin_functions>],
)


