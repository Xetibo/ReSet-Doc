#import "../../templates/utils.typ": *

#subsection("General Plugin System")

#subsection("Resulting Architecture")
The end resulting architecture is similar to the architecture in
@DynamicLibraries. The only difference is the absence of the C-ABI, which was
omitted in favor of direct usage of rust due to tedious conversion of rust to C.
In @resulting_architecture, the architecture is visualized.

#align(
  center, [#figure(
      img("poster.svg", width: 100%, extension: "files"), caption: [Resulting architecture of ReSet and its plugin system],
    )<resulting_architecture>],
)
#pagebreak()

#subsection("Any-Variant")
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
means that lifetimes, allocation and de-allocation, as well as casting, are
handled automatically and enforced for all safe Java code. With Rust, a garbage
collector does not exist, and virtual tables are an opt-in feature, as using by
default would introduce performance overhead. For the Any variant, this virtual
table is desired, as we would like the original value back when calling the "value"
function.

#let code = "
public interface IAny<T> {
  // public T into_variant();
  // This is not necessary as Java does not support arbitrary interface
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
used to mimic the behavior of Java (enforcement of references).

#subsection("Security")
The initial idea of the ReSet plugin system was to reduce the attack vector by
enforcing a narrow definition for the plugin system. As the ReSet daemon uses
DBus, each plugin can provide its own DBus interface. For DBus, there are three
different levels that a program can and must provide. The first is the DBus
object, these objects then implement interfaces which in return provide
functions for calling programs. ReSet plugins should only provide a name for the
plugin and functions that will be implemented for the interface. This ensures
that the daemon is the sole authority for adding any interface or object, which
ensures that no plugin can override an existing interface, potentially shadowing
a common interface with a malicious one.

The registration and insertion of interfaces is handled with the crossroads DBus
context shown in @dbus_crossroads_register.

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

During the implementation of this system, it was found that the DBus functions
would not be able to be provided by the shared library. Attempting to call
functionality provided by shared libraries would result in the object not being
available. The only way to solve this issue was to provide plugins with a
reference to the crossroads DBus context, which would enable plugins to insert
and register their interfaces.

#subsection("Plugin Testing")
Rust tests are handled by a specific test macro, this flag tells the compiler
that this function is to be used when testing the specific project. This works
well for a single project without dynamic loading of additional functionality,
which for ReSet is the plugin system. While it is possible to call arbitrary
functions within a function marked as a test function, it would also bundle all
functions within the test function into one. If ReSet were to call all plugin
tests from one test function, this would enforce that all plugin tests utilize
the same thread and any error would cancel all remaining plugin tests.

// TODO: code of original testing call

In order to solve this issue, ReSet utilizes a different thread-spawning
mechanism with a separate printing functionality in order to provide feedback
about each plugin test function. This mechanism also allows plugins to be shown
as separate entities with their tests, ensuring that developers receive
appropriate feedback.

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

#subsection("ReSet-Daemon Plugin System")
In this section, the specific implementation of the plugin system in the ReSet
daemon is discussed.

As discussed in @PluginSystemEvaluation, the chosen paradigm is the dynamic
library loading variant. With this paradigm, ReSet is required to provide a set
of functions that a plugin needs to implement.

For the daemon, the specific list of functions is visualized in
@daemon_plugin_functions.

#let code = "
extern \"C\" {
    // functions to create or clean up data
    pub fn backend_startup();
    pub fn backend_shutdown();

    // Reports the capabilities that your plugin will provide.
    // These capabilities will also be reported by the daemon.
    #[allow(improper_ctypes)]
    pub fn capabilities() -> PluginCapabilities;

    // Reports the name of the plugin
    // Mostly used for duplication checks
    #[allow(improper_ctypes)]
    pub fn name() -> String;

    // Inserts your plugin interface into the dbus server.
    #[allow(improper_ctypes)]
    pub fn dbus_interface(cross: &mut Crossroads);

    // import tests from plugins
    pub fn backend_tests();
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [ReSet Daemon plugin functions],
    )<daemon_plugin_functions>],
)

A plugin that implements these functions can now be compiled and copied into the
plugin folder. Additionally, in order to run the plugin, the configuration of
ReSet would need to be updated to include the name of the plugin binary. This is
to ensure that only user-defined plugins are loaded. Note that this does not
offer proper security, it only offers protection against unintentional loading
by the user.

In @plugin_loading_config, the toml configuration in order to load the plugin is
visualized.

#let code = "
plugins = [ \"libreset_monitors.so\", \"libreset_keyboard_plugin.so\" ]
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [ReSet toml configuration for loading plugins],
    )<plugin_loading_config>],
)

The loading of the plugins themselves is handled by the ReSet library which
offers this for both the daemon and the user interface. It also covers the
potential duplication of memory when loading the plugin twice. In other words,
the library will only load the plugin into memory once, as defined in
@DynamicLibraries. The only difference is the fetching of functions from a
plugin, which will be different depending on the daemon or the user interface.

This loading will also be done lazily. This means that the plugin files will
only be loaded when either the daemon or the user interface explicitly call the
plugin.

In @plugin_lib_structures, the structures for loading plugins are visualized.

#let code = "
pub static LIBS_LOADED: AtomicBool = AtomicBool::new(false);
pub static LIBS_LOADING: AtomicBool = AtomicBool::new(false);
pub static mut FRONTEND_PLUGINS: Lazy<Vec<FrontendPluginFunctions>> = Lazy::new(|| {
    SETUP_LIBS();
    setup_frontend_plugins()
});
pub static mut BACKEND_PLUGINS: Lazy<Vec<BackendPluginFunctions>> = Lazy::new(|| {
    SETUP_LIBS();
    setup_backend_plugins()
});
static mut LIBS: Vec<libloading::Library> = Vec::new();
static mut PLUGIN_DIR: Lazy<PathBuf> = Lazy::new(|| PathBuf::from(\"\"));
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Plugin structures within ReSet-Lib],
    )<plugin_lib_structures>],
)

Because both the daemon and the user interface are started up in a
non-deterministic fashion, the plugin library loading will also potentially be
non-deterministic. This enforces an atomic check that both the daemon or the
user interface can see. If the check is already either in loading or loaded, the
other process would simply wait or immediately move on to using the plugin
respectively.

Loading of plugins themselves in both the daemon and the user interface can be
done by iterating over the BACKEND_PLUGINS or FRONTEND_PLUGINS global
respectively. Both of these globals are both static and constant after
initialization, this ensures that plugins cannot be changed later on, while also
being initialized after startup.

In @plugin_loading, the plugin loading within the daemon is visualized.

#let code = "
unsafe {
    thread::scope(|scope| {
        let wrapper = Arc::new(RwLock::new(CrossWrapper::new(&mut cross)));
        for plugin in BACKEND_PLUGINS.iter() {
            let wrapper_loop = wrapper.clone();
            scope.spawn(move || {
                // allocate plugin specific things
                (plugin.startup)();
                // register and insert plugin interfaces
                (plugin.data)(wrapper_loop);
                let name = (plugin.name)();
                LOG!(format!(\"Loaded plugin: {}\", name));
            });
        }
    });
}
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Plugin loading within the ReSet daemon],
    )<plugin_loading>],
)

