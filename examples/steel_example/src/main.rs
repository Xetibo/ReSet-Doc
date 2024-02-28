use gtk::{gio::ActionEntry, ApplicationWindow};
pub use gtk::{prelude::*, Button};
use std::{
    rc::Rc,
    sync::{Arc, RwLock},
};
use steel::steel_vm::engine::Engine;
use steel::steel_vm::register_fn::RegisterFn;

fn main() {
    let vm = Rc::new(RwLock::new(Engine::new()));
    setup_gtk(vm);
}

fn setup_gtk(vm: Rc<RwLock<Engine>>) {
    let app = gtk::Application::builder()
        .application_id("example.example.globi")
        .build();

    app.connect_startup(move |_| {
        gtk::init().unwrap();
    });

    app.connect_activate(move |app| {
        let label = Rc::new(gtk::Label::new(Some("nothing")));
        let label_ref = label.clone();
        let button_func = ActionEntry::builder("test")
            .activate(move |_, _, _| {
                label_ref.set_text("button clicked");
            })
            .build();
        let mainbox = gtk::Box::new(gtk::Orientation::Vertical, 20);
        let window = Rc::new(
            ApplicationWindow::builder()
                .application(app)
                .title("Monitor Portal")
                .child(&mainbox)
                .name("MainWindow")
                .build(),
        );
        window.add_action_entries([button_func]);

        // due to both the VM and GTK being limited to one thread
        // it is necessary to provide thread synchronization
        let nein = Arc::new(ArcWrapper {
            window: window.clone(),
        });
        let gtk_action_function = move || {
            gtk::prelude::ActionGroupExt::activate_action(&*nein.window, "test", None);
        };
        vm.write()
            .unwrap()
            .register_fn("test-function", gtk_action_function);

        let button = Button::new();
        let newvm = vm.clone();
        button.connect_clicked(move |_| {
            newvm.write().unwrap().run("(test-function)").unwrap();
        });

        mainbox.append(&button);
        mainbox.append(&*label);

        window.present();
    });

    app.run_with_args(&[""]);
}

struct ArcWrapper {
    window: Rc<gtk::ApplicationWindow>,
}

unsafe impl Send for ArcWrapper {}
unsafe impl Sync for ArcWrapper {}
