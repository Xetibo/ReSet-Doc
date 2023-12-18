#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Daemon Implementation")
This section documents the code for the backend part of ReSet.

#subsubsection("MainLoop")
The mainloop exposes the DBus interface to other applications, and responds to
method calls on this API. In order to provide functionality, the mainloop
requires a different set of data from the different functinalities. This state
is provided as a context and can be accessed only within the mainloop.

// typstfmt::off
#figure(sourcecode(```rs
// run the mainloop

// omitted base setup

conn.request_name(BASE, false, true, false)
    .await
    .unwrap();
let mut cross = Crossroads::new();

// omitted async context creation
// omitted interface creation

// register added interfaces
cross.insert(
    DBUS_PATH,
    &[
        base,
        wireless_manager,
        bluetooth_manager,
        bluetooth_agent,
        audio_manager,
    ],
    // single struct used to hold all data associated with the daemon
    // see next figure for an overview
    data,
);

// process events until shutdown
conn.start_receive(
    MatchRule::new_method_call(),
    Box::new(move |msg, conn| {
        cross.handle_message(msg, conn).unwrap();
        true
    }),
);
```),
 kind: "code", 
 supplement: "Listing",
 caption: [Code snippet from the daemon DBus mainloop])<mainloop>

#figure(sourcecode(```rs
// the data struct used by the main loop
pub struct DaemonData {
    pub n_devices: Vec<Arc<RwLock<Device>>>, // all wifi devices
    pub current_n_device: Arc<RwLock<Device>>, // current wifi device
    pub b_interface: BluetoothInterface,
    pub bluetooth_agent: BluetoothAgent,
    pub audio_sender: Rc<Sender<AudioRequest>>,
    pub audio_receiver: Rc<Receiver<AudioResponse>>,
    pub audio_listener_active: Arc<AtomicBool>,
    pub network_listener_active: Arc<AtomicBool>,
    pub bluetooth_listener_active: Arc<AtomicBool>,
    pub bluetooth_scan_active: Arc<AtomicBool>,
    pub clients: HashMap<String, usize>,
    pub connection: Arc<SyncConnection>, // connection reference used for event creation
    pub handle: JoinHandle<()>, // used for shutdown
}
```), 
kind: "code", 
supplement: "Listing",
caption: [DaemonData struct used as the sole data storage by the daemon])<daemondata>
// typstfmt::on

With these basic data structures, the daemon would be able to use basic
*synchronous* functions, however, for ReSet, it is necessary to provide
asynchronous functionality such as events, which might be created by an entirely
different software.

For this reason, each base functionality of ReSet is done via listeners, which
can be activated and deactivated via the DBus API. Clients of this API can hence
decide themselves whether they would like to use this asynchronous
functionality.

#subsubsection("Audio")
As planned in @Architecture, the PulseAudio library was used to implement the
audio portion of the ReSet daemon. In concrete terms, the library libpulse-binding
@libpulse_binding, which wraps the C PulseAudio functions to rust was used.

Similarly to the main, a listener loop is created for PulseAudio which will
continue to receive events from both the PulseAudio server and the DBus daemon.
PulseAudio events are handled directly by the library listener, which allows
for a listener flag for customized event filters, while the daemon events are
handled via the rust native multi-producer single-consumer message passing
channel.

#figure(sourcecode(
```rs
// filter for PulseAudio events
let mut mask = InterestMaskSet::empty();
mask.insert(InterestMaskSet::SINK);
mask.insert(InterestMaskSet::SOURCE);
mask.insert(InterestMaskSet::SINK_INPUT);
mask.insert(InterestMaskSet::SOURCE_OUTPUT);
context.borrow_mut().subscribe(mask, |_| {});

// listener loop
pub fn listen_to_messages(&mut self) {
    loop {
        // handle events from the main loop of the daemon
        let message = self.receiver.recv();
        if let Ok(message) = message {
            self.handle_message(message);
        }
    }
}
```), 
kind: "code", 
supplement: "Listing",
caption: [Audio mainloop and event subscription])<audio_code>

#figure(sourcecode(
```rs
// example PulseAudio event
// these events come directly from PulseAudio
pulse::context::subscribe::Facility::Sink => {
    if operation == Operation::Removed {
        handle_sink_removed(&connection_ref, index);
        return;
    }
    introspector.get_sink_info_by_index(index, move |result| match result {
        ListResult::Item(sink) => {
            handle_sink_events(&connection_sink, Sink::from(sink), operation);
        }
        ListResult::Error => (),
        ListResult::End => (),
    });
}

// example daemon event
// this example is taken from the audio dbus method GetDefaultSource:

// send the request to get the default source
let _ = data.audio_sender.send(AudioRequest::GetDefaultSource);
// wait for the response from the audio listener
let response = data.audio_receiver.recv();

```), 
kind: "code", 
supplement: "Listing",
caption: [Audio event handling])<audio_events>

Actions from the PulseAudio listener are handled either with a reverse message
passing channel for direct requests from the daemon or as a DBus event, for
which the thread-safe connection reference of the daemon is used. This allows
the sending of messages right within the PulseAudio listener.

#figure(sourcecode(```rs
// Example of DBus event
let msg = Message::signal(
    &Path::from(DBUS_PATH),
    &AUDIO.into(),
    &"OutputStreamRemoved".into(),
)
.append1(index);
let _ = conn.send(msg);
```), 
kind: "code", 
supplement: "Listing",
caption: [Bluetooth events])<bluetooth_events>

#subsubsection("Bluetooth")
For Bluetooth, no further library was necessary, as bluez, the default Bluetooth
module for Linux is accessed via DBus.

The Bluetooth part is created as a DBus client to bluez that will call DBus
methods, and potentially listen for events on various DBus objects(if
desired by clients of ReSet).

#figure(sourcecode(```rs
// Bluetooth listener as DBus client
let bluetooth_device_added =
    BluetoothDeviceAdded::match_rule(Some(&"org.bluez".into()), None).static_clone();
let bluetooth_device_removed =
    BluetoothDeviceRemoved::match_rule(Some(&"org.bluez".into()), None).static_clone();
let mut bluetooth_device_changed = PropertiesPropertiesChanged::match_rule(
    Some(&"org.bluez".into()),
    Some(&path.clone()),
)
.static_clone();
// omitted: handling of each event
```), 
kind: "code", 
supplement: "Listing",
caption: [Bluetooth listener code snippet])<bluetooth_listener>

The biggest challenge with the bluez interface is the clean access to all needed
functionality. For example, fetching all currently available Bluetooth devices
have to be done via the ObjectManager object provided by the freedesktop DBus
API, while the actual information about these devices is provided by the bluez
DBus API.

#figure(
  columns(2, [
    #align(center, [
      All DBus objects on bluez can either be accessed via events, or via a manual method call:
      #image("../../figures/bluez_objectmanager.png", width: 100%)])
    #colbreak()
    #align(center, [
      After fetching the objects, it is now necessary to differentiate between the object types(Adapters and Devices).
      #image("../../figures/bluez_dspy.png", width: 100%)
      ])
  ]),
  caption: [bluez ObjectManager Usage]
)<bluez_objectmanager>

A big difference to the PulseAudio listener is that the vast majority of the
functions can be used without the listener, for PulseAudio, *every* function has
to use the listener via the message-passing channel. For clients of ReSet, this
means that simpler usage without events is possible as well.

Within the listener for events, the responses can also be sent to DBus directly
with another thread-safe reference to the daemon context.

#subsubsubsection("Bluez")
For bluez, ReSet-Lib offers two structs, the Bluetooth Adapter, which is used to
connect to devices, and the devices themselves.

#figure(sourcecode(```rs
// Bluetooth Adapter
#[derive(Debug, Clone, Default)]
pub struct BluetoothAdapter {
    pub path: Path<'static>,
    pub alias: String,
    pub powered: bool,
    pub discoverable: bool,
    pub pairable: bool,
}

// Bluetooth Device
#[derive(Debug, Clone, Default)]
pub struct BluetoothDevice {
    pub path: Path<'static>,
    pub rssi: i16,
    pub alias: String,
    pub name: String,
    pub adapter: Path<'static>,
    pub trusted: bool,
    pub bonded: bool,
    pub paired: bool,
    pub blocked: bool,
    pub connected: bool,
    pub icon: String,
    pub address: String,
}
```), 
kind: "code", 
supplement: "Listing",
caption: [Bluetooth data structures])<bluetooth_structures>

#pagebreak()

#subsubsection("Wireless Network")
The current last piece of functionality is also accessible via DBus.

The challenge with NetworkManager is the vast amount of features it offers,
besides regular networks, it also offers VPN configuration and usage, as well as
other connections, including older protocols. For now, ReSet only offers
wireless network configuration, however in the future this may be expanded upon,
the library repository for ReSet already features entries for both VPN and wired
connections.

The rest of the wireless part is implemented like Bluetooth with an optional
listener exposed for clients.

#subsubsubsection("Network Manager")
ReSet uses five different parts of NetworkManager. Namely, the base NetworkManager,
the settings manager which handles existing connections and their properties,
the Wi-Fi devices that are used to connect to access points, the access points
themselves, and all currently active connections.

#align(center, [#figure(
    img("wifi_architecture.svg", width: 100%, extension: "files"),
    caption: [Wi-Fi architecture],
  )<wifi_model>])

All interactions as well as fetching properties of each DBus object have to be done manually via methods,
therefore, ReSet abstracts this underlying architecture and only provides two data structures to clients.
As an example, the mentioned connection and active connection are both stored within these structures,
which removes the need for an additional call by the client.

#figure(sourcecode(```rs
// Wi-Fi Device
#[derive(Debug, Clone, Default)]
pub struct WifiDevice {
    pub path: Path<'static>,
    pub name: String,
    pub active_access_point: Path<'static>,
}

// Access Point
#[derive(Debug, Clone, Default)]
pub struct AccessPoint {
    pub ssid: Vec<u8>,
    pub strength: u8,
    pub associated_connection: Path<'static>,
    pub dbus_path: Path<'static>,
    pub stored: bool,
}
```), 
kind: "code", 
supplement: "Listing",
caption: [Wi-Fi data structures])<wifi_structures>

Special for the WifiDevice struct is the event,
originally it was planned to not include this within ReSet,
however due to a lack of events on connection changes from any other source,
the WifiDeviceChanged event was included to provide the missing functionality.

#figure(sourcecode(```rs
// get current access point
let active_access_point: Option<&Path<'static>> =
    prop_cast(&ir.changed_properties, "ActiveAccessPoint");
if let Some(active_access_point) = active_access_point {
    let active_access_point = active_access_point.clone();
    // check if a new connection is an access point or if it has been removed
    if active_access_point != Path::from("/") {
        let parsed_access_point = get_access_point_properties(active_access_point);
        let mut device = device_ref.write().unwrap();
        device.access_point = Some(parsed_access_point.clone());
        // send new access point
        let msg = Message::signal(
            &Path::from(DBUS_PATH),
            &WIRELESS.into(),
            &"WifiDeviceChanged".into(),
        )
        .append1(WifiDevice {
            path: device.dbus_path.clone(),
            name: device.name.clone(),
            active_access_point: parsed_access_point.dbus_path,
        });
        let _ = active_access_point_changed_ref.send(msg);
    } else {
        // omitted: access point removed, notify client
    }
}
```), 
kind: "code", 
supplement: "Listing",
caption: [WifiDeviceChanged event])<wifidevicechanged_event>

