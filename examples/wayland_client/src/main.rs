use wayland_client::{protocol::wl_registry, Connection, Dispatch, QueueHandle};

fn main() {
    println!("{}", get_wl_backend());
}

struct AppData(pub String);
impl Dispatch<wl_registry::WlRegistry, ()> for AppData {
    fn event(
        obj: &mut Self,
        registry: &wl_registry::WlRegistry,
        event: wl_registry::Event,
        data: &(),
        conn: &Connection,
        handle: &QueueHandle<AppData>,
    ) {
        if let wl_registry::Event::Global { interface, .. } = event {
            println!("{}", &interface);
        }
    }
}
pub fn get_wl_backend() -> String {
    let backend = String::from("None");
    let mut data = AppData(backend);
    // connection to wayland server
    let conn = Connection::connect_to_env().unwrap();
    let display = conn.display();
    // queue to handle events
    let mut queue = conn.new_event_queue();
    let handle = queue.handle();
    // creates an event for each wayland protocol available
    display.get_registry(&handle, ());
    queue.blocking_dispatch(&mut data).unwrap();
    data.0
}
