#import "../templates/utils.typ": *
#lsp_placate()

#section("Conclusion")
To summarize, ReSet achieved the vision of a universal Settings
application. It offers basic usage of Bluetooth and Wi-Fi, as well as extensive
audio configuration within one application without bundling with environment specific software.

All functionality is offered using inter process communication as planned and
other applications can use the daemon service to utilize the API.

In terms of user interface, user testing has shown positive feedback,
allowing ReSet to continue with the current design language.


#subsection("Outlook")
This section covers both the features of ReSet not implemented yet as well as
potential improvements to this project.

#subsubsection("Not Implemented Features")

#subsubsubsection("Plugin System")
Due to time constraints, this project will not cover a plugin system. However,
with the implementation currently provided, it should be possible to implement
this without major issues. For example, the current DBus daemon allows for a
trivial addition of an additional API and its own namespace.

#figure(
  sourcecode(
    ```rs
    // Example API addition
    unsafe {
        // using the libloading crate
        let lib = libloading::Library::new("/path/to/liblibrary.so").unwrap();
        let interface: libloading::Symbol<unsafe extern fn() -> u32> =
            lib.get(b"interface").unwrap();
        let name: libloading::Symbol<&'static str> = lib.get(b"name").unwrap();
        feature_strings.push(name);
        features.push(interface);
    }

    features.push(setup_base(&mut cross, feature_strings));
    cross.insert(DBUS_PATH, &features, data);
    ```,
  ), kind: "code", supplement: "Listing", caption: [Example API addition],
)<api_addition>

Each of these entries provides its own DBus namespace which can be used to
provide methods and signals to clients. Here ReSet could later a dynamic list of
entries via loading of dynamic library functions instead of a hard-coded one.

#subsubsubsection("Persistent Settings")
Due to a lack of settings in general as of now, ReSet does not offer persistent
settings storage, although the base code for this feature is implemented.

#subsubsubsection("Customizable Shortcuts")
A common feature for many power users, especially on Linux is the heavy use of
keyboard shortcuts. ReSet intended to provide customizable shortcuts in order to
cater to as many users as possible. This however was also not implemented due to
time limitations and is hence a possible improvement.

#pagebreak()

#subsubsubsection("Further Network Features")
Currently, ReSet only offers basic Wi-Fi settings without any wired or VPN
support. Alongside this, ReSet also only offers a single security option at this
time, WPAPSK, which is effectively a simple password without any certificate
support. Basic code to ease the support for all of this exists in ReSet, however
it is not functional at this point.

#subsubsubsection("Further Bluetooth Features")
For Bluetooth, it would still be possible to implement advanced features such as
a pairing wizard for devices that require a pairing code, as well as making file
transfers possible via ReSet.

#subsubsection("Shortcomings")

#subsubsubsection("Testing")
Testing with ReSet outside of manual integration tests is complicated, this also
means that only a few tests were written and none of these can be run on a
system without the functionality for the settings ReSet provides. In this case a
proper mock system needs to be built that can be used to test both the daemon
and the application without needing real hardware functionality.

A mock system is also not perfect, as it needs to replicate the hardware and
driver behavior in order to provide meaningful tests. During this project all
team members had to first study all these features and how they behave with
their driver and hardware implementations. This means a mock system from the
start would not have been possible.

#subsubsubsection("Code Abstraction")
With both events and manual functions often providing similar but not the same
functionality, some code is currently needlessly duplicated. This code should be
abstracted further for better maintainability and readability.

#figure(
  sourcecode(```rs
  // Example problematic code
  pub fn populate_sources(input_box: Arc<SourceBox>) {
      gio::spawn_blocking(move || {
          let sources = get_sources();
      // ... omitted code
    });
  }
  // same code in SinkBox
  pub fn populate_sinks(output_box: Arc<SinkBox>) {
      gio::spawn_blocking(move || {
          let sinks = get_sinks();
      // ... omitted code
    });
  }
  ```), kind: "code", supplement: "Listing", caption: [Example of problematic code to de-duplicate],
)<code_duplication>

The challenge here is to ensure that ReSet does not compromise on performance
with too many thread-safe references, and while still providing a clean
abstraction. This is especially hard with GTK subclassing, which does not always
work perfectly with Rust features.
