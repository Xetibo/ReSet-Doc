use glib::clone;
use gtk::{gio::ActionEntry, ApplicationWindow, Window};
pub use gtk::{prelude::*, Button};
use once_cell::sync::Lazy;
use std::{
    cell::RefCell, rc::Rc, sync::{Arc, RwLock}
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
        let button_func = ActionEntry::builder("up")
            .activate(move |window: &gtk::ApplicationWindow, _, _| {
                label_ref.set_text("button clicked");
            })
            .build();
        let mainbox = gtk::Box::new(gtk::Orientation::Horizontal, 5);
        let button = Rc::new(gtk::Button::new());
        let window = Arc::new(ApplicationWindow::builder()
            .application(app)
            .title("Monitor Portal")
            .child(&mainbox)
            .name("MainWindow")
            .build());
        let nein = NEIN {window: window.clone()};
        let funceroni = move || {
            let window = nein.window.clone();
            gtk::prelude::ActionGroupExt::activate_action(&*window, "win.up", None);
        };
        vm.write()
            .unwrap()
            .register_fn("test-function", funceroni);
        button.connect_activate(move |button| {
            button.activate_action("win.up",None );
            // (button_func)();
        });

        vm.write().unwrap().run("(test-function)").unwrap();

        window.add_action_entries([
            button_func,
            // clear_initial,
        ]);
        mainbox.append(&*button);
        mainbox.append(&*label);

        window.present();
    });

    app.run_with_args(&[""]);
}

struct NEIN {
    window: Arc<gtk::ApplicationWindow>
}

unsafe impl Send for NEIN {}
unsafe impl Sync for NEIN {}

fn test_function() {
    println!("this is a test");
}
