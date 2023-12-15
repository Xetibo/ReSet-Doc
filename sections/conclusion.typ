#import "../templates/utils.typ": *
#lsp_placate()

#section("Conclusion")

#subsection("UI Design Result")
The final UI design has generally followed the intended vision. The UI is clean
and simple, and the user can easily navigate through the UI. It is also
responsive, which means that it will adjust itself depending on window sizes.

But there are some things that didn't make it into the final design. The first
one is the breadcrumb menu. It was decided that the breadcrumb menu is not
necessary because the UI isn't as nested as thought initially. The depth of
it is only one level deep at max, which means that a breadcrumb bar would be
redundant. If the UI ever gets deeply nested, the breadcrumb bar will be 
reconsidered. The next feature that didn't completely get finished are shortcuts, 
which currently very  basic ones like Ctrl+F. While there are some built-in 
shortcuts provided by GTK, the plan is to add some more in the future. 

#subsection("Improvements")
This section covers both the not yet implemented features of ReSet as well as
potential improvements to this project.

#subsubsection("Not Implemented Features")

#subsubsubsection("Plugin System")
Due to time constraints, this project will not cover a plugin system. However,
with the implementation currently provided, it should be possible to implement
this without major issues. For example, the current DBus daemon allows for a
trivial addition of an additional API and its own namespace.

#figure(sourcecode(```rs
// Example API addition
cross.insert(
    DBUS_PATH,
    &[
        base,
        wireless_manager,
        bluetooth_manager,
        bluetooth_agent,
        audio_manager,
    ],
    data,
);
```), 
kind: "code", 
supplement: "Listing",
caption: [Example API addition])<api_addition>

Each of these entries provide their own DBus namespace which can be used to
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

#subsubsubsection("Further Network Features")
Currently, ReSet only offers basic Wi-Fi settings without any wired or VPN
support. Alongside this, ReSet also only offers a single security option at this
time, WPAPSK, which is effectively a simple password without any certificate
support. Basic code to ease the support for all of this exists in ReSet, however
it is not functional at this point.

#subsubsubsection("Further Bluetooth Features")
For Bluetooth it would still be possible to implement advanced features such as
a pairing wizard for devices that require a pairing code, as well as making file
transfers possible via ReSet.

#subsubsection("Shortcomings")

#subsubsubsection("Testing")
Testing with ReSet outside of manual integration tests is complicated, this also
means that only few tests were written and none of these can be run on a system
without the functionality for the settings ReSet provides. In this case a proper
mock system needs to be built that can be used to test both the daemon and the
application without needing real hardware functionality.

A mock system is also not perfect, as it needs to replicate the hardware and
driver behavior in order to provide meaningful tests. During this project all
team members had to first study all these features and how they behave with
their driver and hardware implementations. This means a mock system from the
start would not have been possible.

#subsubsubsection("Code Abstraction")
With both events and manual functions often providing similar but not the same
functionality, some code is currently needlessly duplicated. This code should be
abstracted further for better maintainability and readability.

#figure(sourcecode(```rs
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
```), 
kind: "code", 
supplement: "Listing",
caption: [Example of problematic code to de-duplicate])<code_duplication>

The challenge here is to ensure that ReSet does not compromise on performance
with too many thread-safe references, and while still providing a clean
abstraction. This is especially hard with GTK subclassing, which does not always
work perfectly with rust features.
