#import "../../templates/utils.typ": *

#subsection("Resulting Architecture")
The end resulting architecture is similar to the architecture in
@DynArchitecture. The only difference is the absence of the C-ABI, which was
omitted in favor of direct usage of Rust due to tedious conversion of Rust to C.
In @resulting_architecture, the architecture is visualized.

#align(
  center, [#figure(
      img("poster.svg", width: 100%, extension: "files"), caption: [Resulting architecture of ReSet and its plugin system],
    )<resulting_architecture>],
)
#pagebreak()

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
available. The only way to solve this issue would be to provide plugins with a
reference to the crossroads DBus context, which would enable plugins to insert
and register their interfaces.

However, it was possible to wrap the reference in a new type, meaning the
overall goal of separating plugins from both existing functionality and other
plugins is still guaranteed. The DBus object is created with the plugin name
which must be defined as a separate plugin function.

in @dbus_crossroads_register_new, the injection of the interface is visualized.

#let code = "
pub fn setup_dbus_interface(
  cross: &mut RwLockWriteGuard<CrossWrapper>,
) -> dbus_crossroads::IfaceToken<SomePluginData> {
  cross.register::<SomePluginData>(
    \"org.Xetibo.ReSet.SomePlugin\",
    |c: &mut IfaceBuilder<SomePluginData>| {
      // define methods
    },
  )
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Refined interface registration for DBus],
    )<dbus_crossroads_register_new>],
)

While the cross variable in @dbus_crossroads_register_new has the same name as
the variable in @dbus_crossroads_register, the types are different. The original
implementation used the Crossroads type which allows for both register and
insert functionality, the latter of which allows creating new objects and also
overwriting existing objects. The new CrossWrapper only allows plugins to
register interfaces for their assigned object, meaning overriding is not
possible.

#pagebreak()

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
async fn test_plugins() {
    use re_set_lib::utils::plugin::plugin_tests;
    setup();
    unsafe {
        for plugin in BACKEND_PLUGINS.iter() {
            let name = (plugin.name)();
            let tests = (plugin.tests)();
            plugin_tests(name, tests);
        }
    }
}"
// TODO: code of new testing call and system
#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Custom plugin test framework],
    )<custom_plugin_tests>],
)

To write tests for a plugin, the functions backend_tests() and frontend_tests() 
can be implemented as seen in @backend-test. In there, a vector of PluginTestFunc 
must be returned, which contains a list of function references, which contain the 
test logic and a string, which acts as a test name. This works in the same way 
for the frontend tests.

#let code = "
#[no_mangle]
#[allow(improper_ctypes_definitions)]
pub extern \"C\" fn backend_tests() -> Vec<PluginTestFunc> {
    vec![PluginTestFunc::new(dbus_end_point, \"Test DBus endpoint\")]
}
"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", 
      caption: [Example backend test],
    )<backend-test>],
)

In @monitor-dbus-test, the dbus_end_point() function tests the SetMonitors and 
GetMonitors end points of the monitor plugin. If the DBUS calls fails, a 
PluginTestError will be returned that will be printed to the console.

#let code = "
pub fn dbus_end_point() -> Result<(), PluginTestError> {
    let conn = Connection::new_session().unwrap();
    let proxy = conn.with_proxy(
        \"org.Xetibo.ReSet.Daemon\", \"/org/Xetibo/ReSet/Plugins/Monitors\",
    );
    let monitors = vec![
        Monitor { id: 1, ..Default::default() },
        Monitor { id: 2, ..Default::default() },
    ];

    // Call set monitors
    let res: Result<(), Error> =
        proxy.method_call(MONITOR_PATH, \"SetMonitors\", (monitors, ));
    if let Err(error) = res {
        return Err(PluginTestError::new(format!(
            \"DBus call returned error: {}\", error
        )));
    }

    // Call get monitors
    let res: Result<(Vec<Monitor>, ), Error> =
        proxy.method_call(MONITOR_PATH, \"GetMonitors\", ());
    if let Err(error) = res {
        return Err(PluginTestError::new(format!(
            \"DBus call returned error: {}\", error
        )));
    }
    let len = res.unwrap().0.len();
    if len != 2 {
        return Err(PluginTestError::new(format!(
            \"Result was not filled with 2 mock monitors instead got: {}\", len
        )));
    }
    Ok(())
}
"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", 
      caption: [DBus Monitor Endpoint test],
    )<monitor-dbus-test>],
)

The plugin tests can be run with "cargo test -- --nocapture". Normally, Rust
does not print logs when running tests, but with the nocapture flag, this 
behavior can be disabled. In @plugin-test-output-success an output of the 
plugin test can be seen. @plugin-test-output-fail shows how the output looks 
like if a test has failed.

#columns(
  2, [
    #figure(
      img("pluginTestOutputSuccess.png", width: 100%, extension: "figures"), caption: [Plugin test output success],
    )<plugin-test-output-success>
    #colbreak()
    #figure(
      img("pluginTestOutputFail.png", width: 100%, extension: "figures"), caption: [Plugin test output fail],
    )<plugin-test-output-fail>
  ],
)

#pagebreak()
#subsection("Plugin System Implementation")
In this section, the specific implementation of the plugin system in ReSet is
discussed.

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
    pub fn capabilities() -> PluginCapabilities;

    // Reports the name of the plugin
    // Mostly used for duplication checks
    pub fn name() -> String;

    // Inserts your plugin interface into the DBus server.
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

#pagebreak()

#subsection("Any-Variant")
The Any-Variant was originally intended to be used for uniform plugin data which
can then be sent across DBus interfaces. However, this complexity turned out to
not be necessary for plugin data and is hence not used for this use case.
Instead, the Any-Variant is now used to handle command line flags for the
ReSet-Daemon as it allows arbitrary expansion and processing of flags as whole
tokens by utilizing the Any-Variant as tokens.

In @ExampleAnypattern an Any-Variant via byte vectors is covered. For ReSet, a
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

This trait is combined with the struct shown in @Variant.

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

Comparing this to a language like Java highlights both the complexity of Rust and the clear difference in paradigm. In Java, all reference types are
linked to a garbage collector as well as equipped with a virtual table, which
means that lifetimes, allocation and de-allocation, as well as casting, are
handled automatically and enforced for all safe Java code. With Rust, a garbage
collector does not exist, and virtual tables are an opt-in feature, as using it
by default would introduce a performance overhead. For the Any variant, this
virtual table is desired, as we would like the original value back when calling
the "value" function.

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

As mentioned in the start of this section, the Any-Variant is used to tokenize
command line flags. This is stored into a lazily evaluated global accessible
constant which stores the values in key-value pairs.

In @custom_flag and @custom_flag_result, an example custom flag is visualized.

#let code = "
for flag in FLAGS.0.iter() {
  match flag {
    Flag::Other(flag) => {
      LOG!(format!(
        \"Custom flag {}
         with value {:?}\",
        &flag.0,
        flag.1.clone()
      ));
    }
  }
}"
#columns(
  2, [
    #align(
      left, [#figure(
          sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Custom flag in ReSet-Daemon],
        )<custom_flag>],
    )
    #colbreak()
    #align(
      center, [#figure(
          img("../figures/custom_flag_output.png", width: 100%, extension: "figures"), caption: [Output of the Custom Flag in @custom_flag],
        )<custom_flag_result>],
    )
  ],
)

This flag can now be converted into a proper Rust type with the to_variant
function on the Any-Variant. With this, it is extremely easy to create
constraints for command line flags which ensure stability on use.

