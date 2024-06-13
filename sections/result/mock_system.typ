#import "../../templates/utils.typ": *

#pagebreak()
#subsection("Mock System Implementation")
The original work did not offer any testing potential, this resulted in a
requirement for manual testing. This work implements a testing system for
plugins covered in @PluginTesting, and the implementation of mock DBus endpoints
for the existing features covered in this section.

The implementations of Bluetooth and Network are straightforward to encapsulate
into a testing interface as the original implementation is also done with DBus.
In contrast, Audio is not implemented with DBus, which complicates the creation
of a mock system significantly. However, Audio is also the only server that does
not require hardware to be present in order to use basic functionality. When no
input or output device is found, PulseAudio automatically creates dummy devices,
which allow changing volume or changing the mute status. For ReSet, no further
mock implementation for Audio will be created, as the default dummy output
covers the vast majority of use cases.

#align(
  center, [#figure(
      img("mock_implementation.svg", width: 100%, extension: "files"), caption: [Architecture of the Mock implementation],
    )<mock_architecture>],
)

The cfg(test) annotation can be used to tell the compiler to include differing
code in test environments. For ReSet, this is used to inject different interface
names for DBus which will be handled at compile time. This means there is zero
performance cost to this system as everything is handled before running the
binary. A user with the release version of ReSet would not even be able to see
this system by decompiling it, as it does not exist within this version.

Further usage of macros with the mock system is covered in @MacroUsage.

#pagebreak()
#subsubsection("Testing the Mock System")
In order to provide tests for the mock system, both the daemon and the mock
implementations need to be available during the testing phase. However, Rust
does not provide an easy way to ensure systems are available on test start,
especially with the fact that tests are by default multithreaded and therefore 
run in a non-deterministic fashion. This forces developers to create their 
synchronization chain in order to create a proper setup for each test. For
ReSet, this was handled by calling the same setup function with all threads and
waiting for both the mock and the daemon with atomic booleans.

In @mock_setup, the setup function for the mock tests is visualized.

#let code = "
fn setup() {
    // only the first test is starting the endpoint and the server
    if COUNTER.fetch_add(1, Ordering::SeqCst) < 1 {
        thread::spawn(|| {
            // create a thread and spawn the mock endpoint
            let rt2 = runtime::Runtime::new().expect(\"Failed to create runtime\");
            rt2.spawn(start_mock_implementation_server(&READY));
            while !READY.load(Ordering::SeqCst) { hint::spin_loop(); }
            // omitted daemon creation
            rt.shutdown_background();
        });
    };
    // wait until the mock endpoint is ready
    while !READY.load(Ordering::SeqCst) { hint::spin_loop(); }
    // omitted wait for daemon
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Mock testing system setup function],
    )<mock_setup>],
)

An example test case that uses the setup function alongside the mock system
tests output can be seen in @mock_test_example and daemon-tests-output
respectively.

#let code = "
#[tokio::test]
async fn test_mock_connection() {
    setup();
    let conn = Connection::new_session().unwrap();
    let proxy = conn.with_proxy(INTERFACE, DBUS_PATH, DURATION);
    let res: Result<(), Error> = proxy.method_call(INTERFACE, \"Test\", ());
    assert!(res.is_ok());
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Mock test example],
    )<mock_test_example>],
)

#align(
  left, [#figure(
      img("daemon_tests.png", width: 100%, extension: "figures"), caption: [Daemon tests output],
    )<daemon-tests-output>],
)

#pagebreak()

#subsubsection("Macro Usage")
The mock system will be used within the session(userspace) DBus, which does not
require any special permissions. However, the actual implementation of
NetworkManager or bluez both exist in the system-wide DBus, as they require
hardware access. This situation requires ReSet to differentiate between session
DBus and system DBus depending on the configuration. Just like in
@PluginTesting, Rust allows the differentiation of testing, debug or release
configuration via compiler flags.

In @dbus_method, the Rust macro for differentiation between session and system
DBus is visualized.

#let code = "
#[cfg(test)]
macro_rules! set_dbus_property {
    (
    $name:expr,
    $object:expr,
    $interface:expr,
    $property:expr,
    $value:expr,
) => {{
    let conn = Connection::new_session().unwrap();
    let proxy = conn.with_proxy($name, $object, Duration::from_millis(1000));
    use dbus::blocking::stdintf::org_freedesktop_dbus::Properties;
    let result: Result<(), dbus::Error> = proxy.set($interface, $property, $value);
    result
  }};
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [DBus method macro for tests],
    )<dbus_method>],
)

This macro alone would not work if used in regular code, Rust requires a
duplicate macro with the same name without the test configuration. In that macro,
the new_session call would be changed to new_system.

The same configuration can be used to target different endpoints of DBus. This
would mean targeting org.Xetibo.Test.NetworkManager instead of
org.freedesktop.NetworkManager. In @dbus_networkmanager_endpoint, both the
regular and the testing macro are visualized.

#let code = "
#[cfg(not(test))]
macro_rules! NM_INTERFACE {
  () => {
    \"org.freedesktop.NetworkManager\"
  };
}

#[cfg(test)]
macro_rules! NM_INTERFACE {
  () => {
    \"org.Xetibo.ReSet.Test.NetworkManager\"
  };
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [NetworkManager macros],
    )<dbus_networkmanager_endpoint>],
)

