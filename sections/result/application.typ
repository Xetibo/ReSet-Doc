#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Frontend Implementation")
This section covers the implementation of the ReSet user interface application
which interacts with the ReSet daemon.

#subsubsection("GTK Mainloop")
GTK handles its main loop via callbacks, this means users of GTK can
define a function for different scenarios like startup or UI building.
For ReSet, both a startup and a shutdown function was passed to GTK.

#figure(sourcecode(```rs
fn main() {
    let app = Application::builder().application_id(APP_ID).build();

    app.connect_startup(move |_| {
        // libadwaita is a library with predefined GTK modules
        // similar to material UI for various web frameworks
        adw::init().unwrap();
        load_css();
    });

    app.connect_activate(build_ui);
    app.connect_shutdown(shutdown);
    // this will run until user closes the application
    app.run();
}
```), 
kind: "code", 
supplement: "Listing",
caption: [Example GTK application])<example_gtk>

#subsubsection("Modular Design")
In order to provide easier implementation for plugins, ReSet was developed with
a modular user interface, this can be seen with the consistent design language
across the current features. This means that the same container was used for
audio, Bluetooth and wireless networks, and can be used by plugins in the future
to keep the consistent design.

In @reset_settings_box, the currently used box is shown in the code.
The box is technically empty and just serves as a container for each functionality,
similar to a custom div component used in web development.

#figure(sourcecode(```rs
// The container used for every functionality
#[template(resource = "/org/Xetibo/ReSet/resetSettingBox.ui")]
pub struct SettingBox {}

#[glib::object_subclass]
impl ObjectSubclass for SettingBox {
    const ABSTRACT: bool = false;
    const NAME: &'static str = "resetSettingBox";
    type Type = setting_box::SettingBox;
    type ParentType = gtk::Box;
}
```), 
kind: "code", 
supplement: "Listing",
caption: [ReSet settings box])<reset_settings_box>

Alongside this, ReSet uses a GTK native Flowbox which houses the containers.
Using the Flowbox, ReSet can ensure the usage of optimal available screen 
space by dynamically resizing its children. This translates to a window
that doesn't feel empty, even on ultrawide monitors. At the same time, the
flowbox provides the response design aspects that users have gotten used to on
web applications. This means that ReSet can also be used on vertical monitors
without issues.

#subsubsection("Listeners")
Just like in @DaemonImplementation, the listeners are DBus clients that activate
a callback function on receival of an event. The events themselves always have
the same structure with possible events being: added, removed, changed.

// typstfmt::off
#figure(sourcecode(```rs
// Example listener setup(Audio)
// put listener into different thread in order to prevent blocking behavior
gio::spawn_blocking(move || {
    let conn = Connection::new_session().unwrap();
    if listeners.pulse_listener.load(Ordering::SeqCst) {
        // don't start another thread if already running
        return;
    }

    if let Some(sink_box) = sink_box {
        // add events to listen for speakers etc.
        conn = start_output_box_listener(conn, sink_box);
    }
    if let Some(source_box) = source_box {
        // add events to listen for microphones etc.
        conn = start_input_box_listener(conn, source_box);
    }
    listeners.pulse_listener.store(true, Ordering::SeqCst);
    loop {
        // process event -> blocking within thread
        let _ = conn.process(Duration::from_millis(1000));
        if !listeners.pulse_listener.load(Ordering::SeqCst) {
            break;
        }
    }
});

```), 
kind: "code", 
supplement: "Listing",
caption: [Example setup for a DBus listener to the ReSet daemon])<example_listener>

It is important to note that the added and changed events provide structs
from the DBus API defined in @DBusAPI, while removed events provide a DBus
path that denotes the removed structure. The reason for this disparity is the
inability to fetch data from removed DBus objects, hence only the path is
provided.

