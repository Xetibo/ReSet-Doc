use gtk::Window;
pub use gtk::{prelude::*, Button};
use once_cell::{self, sync::Lazy};
use std::{collections::HashMap, rc::Rc, process::exit};

use gtk4 as gtk;
static mut SINGLETON: Lazy<TestSingleton> = Lazy::new(|| TestSingleton {
    window: None,
    buttons: HashMap::new(),
    labels: HashMap::new(),
});

fn main() {
    let empty = || {};
    setup_gtk(empty);
}

fn setup_gtk(func: fn()) {
    let app = gtk::Application::builder()
        .application_id("example.example.globi")
        .build();

    app.connect_startup(move |_| {
        gtk::init().unwrap();
    });

    app.connect_activate(move |app| {
        let mainbox = gtk::Box::new(gtk::Orientation::Horizontal, 5);
        let button = Rc::new(gtk::Button::new());
        let label = Rc::new(gtk::Label::new(Some("nothing")));
        let label_ref = label.clone();
        button.connect_activate(move |_| {
            label_ref.set_text("button clicked");
        });
        let window = Rc::new(
            Window::builder()
                .application(app)
                .title("Monitor Portal")
                .child(&mainbox)
                .name("MainWindow")
                .build(),
        );
        unsafe {
            SINGLETON
                .buttons
                .insert("testbutton".to_string(), button.clone());
            SINGLETON
                .labels
                .insert("testlabel".to_string(), label.clone());
            SINGLETON.window = Some(window.clone());
        }
        mainbox.append(&*button);
        mainbox.append(&*label);

        (func)();
        window.present();
    });

    app.run_with_args(&[""]);
}

#[test]
#[gtk::test]
fn test() {
    let testfunc = || unsafe {
        let label = SINGLETON.labels.get("testlabel").unwrap();
        assert_eq!(label.text(), "nothing");
        let button = SINGLETON.buttons.get("testbutton");
        button.unwrap().activate();
        assert_eq!(label.text(), "button clicked");
        SINGLETON.window.clone().unwrap().close();
        // exit if successfull -> leads to no output if successfull
        exit(0);
    };
    setup_gtk(testfunc);
}

struct TestSingleton {
    window: Option<Rc<gtk::Window>>,
    buttons: HashMap<String, Rc<gtk::Button>>,
    labels: HashMap<String, Rc<gtk::Label>>,
}

unsafe impl Send for TestSingleton {}
unsafe impl Sync for TestSingleton {}
