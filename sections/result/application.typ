#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Frontend Implementation")
This section covers the implementation of the ReSet user-interface application
which interacts with the ReSet daemon.

#subsubsection("GTK Mainloop")
The GTK mainloop handles its loop via callbacks, this means users of GTK can
define a function for different scenarios like startup or UI building.

#figure(sourcecode(```rs
fn main() {
    let app = Application::builder().application_id(APP_ID).build();

    app.connect_startup(move |_| {
        // adwaita is a library with predefined GTK modules
        // similar to material UI for various web frameworks
        adw::init().unwrap();
        load_css();
    });

    app.connect_activate(build_ui);
    app.connect_shutdown(shutdown);
    // this will run until user closes the application
    app.run();
}
```), caption: [Example GTK application])<example_gtk>

#subsubsection("Modular Design")
In order to provide easier implementation for plugins, ReSet was developed with
a modular user-interface, this can be seen with the consistent design language
across the current features. This means that the same container was used for
audio, Bluetooth and wireless networks, and can be used by plugins in the future
to keep the consistent design.

#figure(sourcecode(```rs
// The container used for every functionality
#[glib::object_subclass]
impl ObjectSubclass for SettingBox {
    const ABSTRACT: bool = false;
    const NAME: &'static str = "resetSettingBox";
    type Type = setting_box::SettingBox;
    type ParentType = gtk::Box;

    fn class_init(klass: &mut Self::Class) {
        klass.bind_template();
    }

    fn instance_init(obj: &glib::subclass::InitializingObject<Self>) {
        obj.init_template();
    }
}
```), caption: [ReSet settings box])<reset_settings_box>

Alongside this, the flowbox which houses the containers was created to always
use the optimal amount of screen space available. This translates to a window
that doesn't feel empty, even on ultrawide monitors. At the same time, the
flowbox provides the response design aspects that users have gotten used to on
web applications. Meaning that ReSet can also be used on vertical monitors
without issue.

#subsubsection("Listeners")
Just like in @DaemonImplementation, the listeners are DBus clients that activate
a callback function on receival of an event. The events themselves always have
the same structure with possible events being: added, removed, changed.

// typstfmt::off
#figure(sourcecode(```rs
// Example listener setup(Audio)
pub fn start_audio_listener(
    listeners: Arc<Listeners>,
    sink_box: Option<Arc<SinkBox>>,
    source_box: Option<Arc<SourceBox>>,
) {
    // put listener into different thread in order to prevent blocking behavior
    gio::spawn_blocking(move || {
        let conn = Connection::new_session().unwrap();
        if listeners.pulse_listener.load(Ordering::SeqCst) {
            // don't start another thread if already running
            return;
        }

        // connection that will be used for the listener events
        let mut conn = start_dbus_audio_listener(conn);

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
            // stop listener via atomic bool
            // creates easy shutdown of listener
            if !listeners.pulse_listener.load(Ordering::SeqCst) {
                stop_dbus_audio_listener(conn);
                break;
            }
        }
    });
}
```), caption: [Example setup for a DBus listener to the ReSet daemon])<example_listener>

It is important to note that the added and changed events provide structs
defined by the DBus API defined in @DBus, while removed events provide a DBus
path that denotes the removed structure. The reason for this disparity is the
inability to fetch data from removed DBus objects, hence only the path is
provided.

#subsubsection("Guidelines")
ReSet is written in idiomatic rust where possible(not always applicable due to C
and GTK architecture), which means that the project uses the standard linter rust
provides, clippy, alongside the default rust tools like rust-analyzer and the
default formatter rustfmt.
