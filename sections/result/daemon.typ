#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Daemon Implementation")
This section documents the code for the DBus service part of ReSet.

#subsubsection("Data structure References")
All relevant data structures for this section can be found in the appendix
@Datastructures.

#subsubsection("Main Loop")
The main loop exposes the DBus interface to other applications and responds to
method calls on this API. In order to provide functionality, the main loop
requires a different set of data from different functionalities. This data
is provided as a context and can be accessed only within the main loop.

// typstfmt::off
#figure(sourcecode(```rs
// omitted creation of data -> type is DaemonData
// insert data and features into context
let token = cross.register("org.Xetibo.ReSet.Daemon", |c| {
   c.method(
       "UnregisterClient",
       ("client_name",),
       ("result",),
       move |_, data: &mut DaemonData, (client_name,): (String,)| {
           data.clients.remove(&client_name);
           Ok((true,))
       },
   );
});
cross.insert(DBUS_PATH, &token, data);

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
 caption: [Code snippet from the daemon DBus main loop])<mainloop>

In @mainloop, the daemon registers a function in the org.Xetibo.ReSet.Daemon interface which will provide the function "UnregisterClient".
Whenever this function is called the main loop will execute the registered closure that provides the functionality.

This setup alone would suffice for regular request/response functions,
however, ReSet is also required to implement events as certain technologies like Bluetooth require them.
They are also required to provide instant feedback for a user interface application upon a state change.
For this reason, ReSet also offers a listener for each functionality which will be explained in detail in their respective subsections.

#pagebreak()

#subsubsection("Audio")
As planned in @Architecture, PulseAudio was used to implement the
audio portion of the ReSet daemon. In concrete terms, the library libpulse-binding
@libpulse_binding, which wraps the C PulseAudio functions to Rust was used.

Similarly to the main loop, a listener loop is created for PulseAudio which will
continue to receive events from both the PulseAudio server and the DBus daemon.
PulseAudio events are handled directly by the library listener, which allows
for a listener flag for customized event filters, while the daemon events are
handled via multi-producer multi-consumer message passing
channels provided by the crossbeam library @crossbeam.

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
caption: [Audio main loop and event subscription])<audio_code>

Libpulse-binding features a separate event loop which is created automatically by the context.
Within this loop, all PulseAudio events are handled, which allows for separation between user requests, and events.

#figure(sourcecode(
```rs
// example PulseAudio event
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
```),
kind: "code",
supplement: "Listing",
caption: [Audio event handling])<audio_events>

After the events are processed,
they are directly converted into DBus signals which will be propagated to potential
clients by the thread-safe reference to the DBus connection of the DBus main loop.
This method skips the transfer of data back to the DBus main loop.


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
caption: [Example DBus event])<dbus_event>

For user requests, two channels are required in order to both receive and send messages.
This system is used for every direct request from the daemon and will block the PulseAudio main loop,
however, it does not block the daemon main loop.
Overall this will result in blocked events being queued up and executed when possible.

#figure(sourcecode(
```rs
// example daemon event
// this example is taken from the audio DBus method GetDefaultSource:

// send the request to get the default source
let _ = data.audio_sender.send(AudioRequest::GetDefaultSource);
// wait for the response from the audio listener
let response = data.audio_receiver.recv();

```),
kind: "code",
supplement: "Listing",
caption: [Audio event handling])<audio_dbus_events>

Important to note for audio is that the listener has to be active for the entire lifecycle of the DBus daemon.
This is because the listener is used to provide basic features such as listing of all audio devices,
hence no functionality would be provided without listener.

#pagebreak()

#subsubsection("Bluetooth")
For Bluetooth, no further library was necessary, as bluez, the default Bluetooth
module for Linux is accessed via DBus.

The Bluetooth part is created as a DBus client to bluez that will call DBus
methods, and listen for events on various DBus objects.

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
has to be done via the ObjectManager object provided by the freedesktop DBus
API, while the actual information about these devices is provided by the bluez
DBus API.

#figure(
  columns(2, [
    #align(center, [
      All DBus objects on bluez can either be accessed via events or via a manual method call:
      #image("../../figures/bluez_objectmanager.png", width: 100%)])
    #colbreak()
    #align(center, [
      After fetching the objects, it is now necessary to differentiate between the object types(Adapters and Devices).
      #image("../../figures/bluez_dspy.png", width: 100%)
      ])
  ]),
  caption: [bluez ObjectManager Usage]
)<bluez_objectmanager>

Within the listener for events, the responses can also be sent to DBus directly
with another thread-safe reference to the daemon context as already shown in @dbus_event.

#pagebreak()

#subsubsection("Wireless Network")
The last piece of functionality, Wi-Fi, is also accessible via DBus.

The challenge with NetworkManager is the amount of features it offers.
Besides regular networks, it also offers VPN configuration and usage, as well as
other connections, including older protocols. For now, ReSet only offers
wireless network configuration, however in the future, this may be expanded upon.
The library repository for ReSet (ReSet-Lib @reset_lib) already features entries for both VPN and wired
connections.

The base DBus client usage of Wi-Fi is implemented like Bluetooth with an optional
listener exposed for clients.

#subsubsubsection("Network Manager")
ReSet uses six different parts of NetworkManager. Namely, the base NetworkManager,
the settings manager which handles existing connections and their properties,
the Wi-Fi devices that are used to connect to access points, the access points
themselves, and all currently active connections.

#align(center, [#figure(
    img("wifi_architecture.svg", width: 100%, extension: "files"),
    caption: [Wi-Fi architecture],
  )<wifi_model>])

#pagebreak()

All interactions as well as fetching properties of each DBus object have to be done manually via methods,
therefore, ReSet abstracts this underlying architecture and only provides two data structures to clients.
As an example, the mentioned connection and active connection are both stored within these structures,
which removes the need for an additional call by the client.

As mentioned in @DatastructureReferences, the structures can be found in @Datastructures.

Special for the WifiDevice struct is the event,
originally it was planned to not include this within ReSet,
however due to a lack of events on connection changes from any other source,
the WifiDeviceChanged event was included to provide the missing functionality.

#figure(sourcecode(```rs
// omitted fetching of current access point
// code slightly changed from source to omit unnecessary code
if let Some(parsed_access_point) = access_point {
    // send new access point
    let msg = Message::signal(
        &Path::from(DBUS_PATH),
        &WIRELESS.into(),
        &"WifiDeviceChanged".into(),
    )
    .append1(WifiDevice {
        path: device.dbus_path.clone(),
        name: device.name.clone(),
        active_access_point: parsed_access_point.ssid,
    });
    let _ = active_access_point_changed_ref.send(msg);
} else {
    // omitted: access point removed, notify client
}
```),
kind: "code",
supplement: "Listing",
caption: [WifiDeviceChanged event])<wifidevicechanged_event>

A big difference to the PulseAudio and Bluetooth listener is that the majority of the
functions can be used without the listener, for PulseAudio, *every* function has
to use the listener via the message-passing channel,
while for Bluetooth the technology requires a manual request for scans.
For clients of ReSet, this means that simpler usage without events is possible as well.

