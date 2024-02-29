#![allow(non_snake_case)]

use adw::EntryRow;
use std::net::Ipv4Addr;
use std::str::FromStr;
use std::{collections::HashMap, process::exit, rc::Rc};

use gtk::Orientation::Horizontal;
pub use gtk::{prelude::*, Button};
use gtk::{Label, Window};
use gtk4 as gtk;
use once_cell::{self, sync::Lazy};

#[cfg(debug_assertions)]
macro_rules! TestButton {
    ( $button_name:expr ) => {{
        let button = Rc::new(gtk::Button::new());
        unsafe {
            SINGLETON.buttons.insert($button_name, button.clone());
        }
    }};
}

#[cfg(not(debug_assertions))]
macro_rules! TestButton {
    ( $button:expr ) => {
        gtk::Button::new()
    };
}

static mut SINGLETON: Lazy<TestSingleton> = Lazy::new(|| TestSingleton {
    window: None,
    buttons: HashMap::new(),
    labels: HashMap::new(),
    checkbox: HashMap::new(),
    entryRow: HashMap::new(),
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
        let main = gtk::Box::new(Horizontal, 5);
        let entryRow = Rc::new(EntryRow::new());
        let button2 = Rc::new(Button::new());
        let button1 = Rc::new(Button::new());
        let label = Rc::new(Label::new(Some("nothing")));

        entryRow.connect_changed(
            move |entry| match Ipv4Addr::from_str(entry.text().as_str()) {
                Ok(_) => entry.add_css_class("success"),
                Err(_) => entry.add_css_class("error"),
            },
        );

        let entryRow_ref = entryRow.clone();
        let label_ref = label.clone();
        button1.connect_activate(move |_| {
            entryRow_ref.set_text("192.168.1.100");
        });
        button2.connect_activate(move |_| {
            label_ref.set_text("button clicked");
        });

        let window = Rc::new(Window::builder().application(app).child(&main).build());
        let button3 = TestButton!("macro_button".to_string());
        unsafe {dbg!(SINGLETON.buttons.clone());}
        // unsafe {
        //     SINGLETON
        //         .buttons
        //         .insert("button1".to_string(), button1.clone());
        //     SINGLETON
        //         .buttons
        //         .insert("button2".to_string(), button2.clone());
        //     SINGLETON
        //         .labels
        //         .insert("testlabel".to_string(), label.clone());
        //     SINGLETON
        //         .entryRow
        //         .insert("entryrow".to_string(), entryRow.clone());
        //     SINGLETON.window = Some(window.clone());
        // }
        main.append(&*button2);
        main.append(&*label);
        main.append(&*entryRow);

        func();
        window.present();
    });

    app.run_with_args(&[""]);
}

#[test]
#[gtk::test]
fn test() {
    let func = || unsafe {
        // test label text change after button click
        let label = SINGLETON.labels.get("testlabel").unwrap();
        assert_eq!(label.text(), "nothing");
        let button = SINGLETON.buttons.get("button2");
        button.unwrap().activate();
        assert_eq!(label.text(), "button clicked");

        // test entryRow css class change after button click
        let entryRow = SINGLETON.entryRow.get("entryrow").unwrap();
        assert_eq!(entryRow.css_classes().len(), 2); // 2 default css classes
        let button1 = SINGLETON.buttons.get("button1");
        button1.unwrap().activate();
        assert_eq!(entryRow.has_css_class("success"), true);
        SINGLETON.window.clone().unwrap().close();
        exit(0);
    };
    setup_gtk(func);
}

struct TestSingleton {
    window: Option<Rc<gtk::Window>>,
    buttons: HashMap<String, Rc<gtk::Button>>,
    labels: HashMap<String, Rc<Label>>,
    checkbox: HashMap<String, Rc<gtk::CheckButton>>,
    entryRow: HashMap<String, Rc<EntryRow>>,
    // ...
}

unsafe impl Send for TestSingleton {}

unsafe impl Sync for TestSingleton {}
