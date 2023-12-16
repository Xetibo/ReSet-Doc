#import "../../templates/utils.typ": *
#lsp_placate()
#subsection("DBus API")

#subsubsection("Base API")

#grid(
  columns: (auto), rows: (20pt), cell(
    [#figure([], kind: table, caption: [Base DBus Table])<wifi_type_table>], bold: true,
  ),
)
#grid(
  columns: (1fr, 2fr), rows: (20pt), gutter: 0pt,
  cell("DBus interface name", bold: true, cell_align: left, fill: silver),
  cell("org.Xetibo.ReSet.Daemon", bold: true,  cell_align: left, fill: silver),
)

#figure(
  ```rs
// Returns all capabilities of the daemon as strings
fn GetCapabilities() -> Vec<String>;
//
// Register the client to the daemon.
// This is mainly useful for clients that want to ensure the daemon is running before
// starting calls.
// Later on this can be expanded for more functionality.
fn RegisterClient(client_name: String) -> bool;
//
// Deletes the entry for this client from the daemon.
fn UnregisterClient(client_name: String) -> bool;
//
// Shuts down the daemon.
fn Shutdown();
  ```, 
  kind: "code", 
  supplement: "Listing",
  caption: [Base DBus API for the ReSet daemon],
)<daemon_api>

#subsubsection("Wi-Fi API")
#grid(
  columns: (auto), rows: (20pt), cell(
    [#figure([], kind: table, caption: [Wi-FI DBus Table])<wifi_type_table>], bold: true,
  ),
)
#grid(
  columns: (1fr, 2fr), rows: (20pt, 40pt, 40pt), gutter: 0pt,
  cell("Type", bold: true, cell_align: left, use_under: true),
  cell("Type Description", bold: true, cell_align: left, use_under: true),
  cell("AccessPoint", bold: true,  cell_align: left),
  cell([
DBus signature: ayyoob\
`Vec<u8>, u8, Path<'static>, Path<'static>, bool`
    ], bold: true,  cell_align: left),
  cell("WifiDevice", bold: true,  cell_align: left, fill: silver),
  cell([
DBus signature: oso\
`Path<'static>,String, Path<'static>`
    ], bold: true,  cell_align: left, fill: silver),
)
#grid(
  columns: (1fr), rows: (20pt, 20pt, 20pt), gutter: 0pt,
  cell("Event", bold: true, cell_align: left, use_under: true),
  cell("AccessPointChanged -> AccessPoint", bold: true,  cell_align: left),
  cell("AccessPointAdded -> AccessPoint", bold: true,  cell_align: left, fill: silver),
  cell("AccessPointRemoved -> Path<'static>", bold: true,  cell_align: left),
  cell("WifiDeviceChanged -> WifiDevice", bold: true,  cell_align: left, fill: silver),
  cell("ResetWifiDevices -> Vec<WifiDevices>", bold: true,  cell_align: left),
)
#grid(
  columns: (1fr, 2fr), rows: (20pt), gutter: 0pt,
  cell("DBus interface name", bold: true, cell_align: left, fill: silver),
  cell("org.Xetibo.ReSet.Wireless", bold: true,  cell_align: left, fill: silver),
)

#figure(
  ```rs
// Returns all access points for the current wireless network device.
fn ListAccessPoints() -> Vec<AccessPoint>;
//
// A check that returns the current status of Wifi.
// Returns a bool as a result of the operation.
fn GetWifiStatus() -> bool;
//
// Enables or disables Wifi for the entire system.
fn SetWifiEnabled(enabled: bool) -> bool;
//
// Returns the dbus path of the current wireless network device, as well as the name.
fn GetCurrentWifiDevice() -> WifiDevice;
//
// Returns all available wireless network devices.
fn GetAllWifiDevices() -> Vec<WifiDevice>;
//
// Sets the current network device based on the dbus path of the device.
// Returns true on success and false on error.
fn SetWifiDevice(device: Path<'static>) -> bool;
//
// Connects to an access point that has a known connection inside the NetworkManager.
// Note, for a new access point, use the ConnectToNewAccessPoint function.
// Returns true on success and false on error.
fn ConnectToKnownAccessPoint(access_point: AccessPoint) -> bool;
//
// Connects to a new access point with a password.
// Returns true on success and false on error.
fn ConnectToNewKnownAccessPoint(access_point: AccessPoint, password: String) -> bool;
//
// Disconnects from the currently connected access point.
// Calling this without a connected access point will return false.
// Returns true on success and false on error.
fn DisconnectFromCurrentAccessPoint() -> bool;
//
// Returns the stored connections for the currently selected wireless device from NetworkManager.
// Returns dbus invalid arguments on error.
fn ListStoredConnections() -> Vec<(Path<'static>, Vec<u8>)>;
//
// Returns the settings of a connection.
// Can be used in combination with the Connection struct in order to provide easy serialization
// and deserialization from and to this hashmap.
// Returns dbus invalid arguments on error.
fn GetConnectionSettings(path: Path<'static>) -> HashMap<String, PropMap>;
//
// Sets the settings of a connection.
// Can be used in combination with the Connection struct in order to provide easy serialization
// and deserialization from and to this hashmap.
// Returns true on success and false on error.
fn SetConnectionSettings(path: Path<'static>, settings: HashMap<String, PropMap>) -> bool;
  ```, 
  kind: "code", 
  supplement: "Listing",
  caption: [Wifi API for the ReSet daemon (part1)],
)<daemon_api1>

#figure(
  ```rs
// Deletes the stored connection given the dbus path.
// Returns true on success and false on error.
fn DeleteConnection(path: Path<'static>) -> bool;
//
// Starts the wireless network listener which provides dbus events on access points and the
// wireless device.
// Repeatedly starting the network listener twice will simply return an error on consecutive
// tries.
// Returns true on success and false on error.
fn StartNetworkListener() -> bool;
//
// Stops the wireless network listener.
// Returns true on success and false on error.
fn StopNetworkListener() -> bool;
  ```, 
  kind: "code", 
  supplement: "Listing",
  caption: [Wifi API for the ReSet daemon (part2)],
)<daemon_api2>

#subsubsection("Bluetooth API")
#grid(
  columns: (auto), rows: (20pt), cell(
    [#figure([], kind: table, caption: [Bluetooth DBus Table])<wifi_type_table>], bold: true,
  ),
)
#grid(
  columns: (1fr, 2fr), rows: (20pt, 60pt, 40pt), gutter: 0pt,
  cell("Type", bold: true, cell_align: left, use_under: true),
  cell("Type Description", bold: true, cell_align: left, use_under: true),
  cell("BluetoothDevice", bold: true,  cell_align: left),
  cell([
DBus signature: onssobbbbbss\
`Path<'static>, u16, String, String, Path<'static>, bool, bool, bool, bool, bool, String, String`
    ], bold: true,  cell_align: left),
  cell("BluetoothAdapter", bold: true,  cell_align: left, fill: silver),
  cell([
DBus signature: osbbb\
`Path<'static>, String, bool, bool, bool`
    ], bold: true,  cell_align: left, fill: silver),
)
#grid(
  columns: (1fr), rows: (20pt, 20pt, 20pt), gutter: 0pt,
  cell("Event", bold: true, cell_align: left, use_under: true),
  cell("BluetoothDeviceAdded -> BluetoothDevice", bold: true,  cell_align: left),
  cell("BluetoothDeviceRemoved -> Path<'static>", bold: true,  cell_align: left, fill: silver),
  cell("BluetoothDeviceChanged -> BluetoothDevice", bold: true,  cell_align: left),
)
#grid(
  columns: (1fr, 2fr), rows: (20pt), gutter: 0pt,
  cell("DBus interface name", bold: true, cell_align: left, fill: silver),
  cell("org.Xetibo.ReSet.Bluetooth", bold: true,  cell_align: left, fill: silver),
)

#figure(
  ```rs
// Starts searching for Bluetooth devices.
// Note this is without a listener, you would have to manually request Bluetooth devices.
fn StartBluetoothSearch();
//
// Stops searching for Bluetooth devices.
fn StopBluetoothSearch();
//
// Starts the listener for Bluetooth events for a specified duration.
// Repeatedly starting the network listener while already active will do nothing.
fn StartBluetoothListener();
//
// Stops the listener for Bluetooth events.
fn StopBluetoothListener();
//
// Returns the currently available Bluetooth adapters.
fn GetBluetoothAdapters() -> Vec<BluetoothAdapter>;
//
// Returns the current default Bluetooth adapter.
fn GetCurrentBluetoothAdapter() -> BluetoothAdapter;
//
// Sets the default Bluetooth adapter.
// The path can be found inside the BluetoothAdapter struct.
fn SetBluetoothAdapter(path: Path<'static>) -> bool;
//
// Sets the discoverability of a specific Bluetooth adapter.
fn SetBluetoothAdapterDiscoverability(path: Path<'static>, enabled: bool) -> bool;
//
// Sets the pairability of a specific Bluetooth adapter.
fn SetBluetoothAdapterPairability(path: Path<'static>, enabled: bool) -> bool;
//
// Connects to a Bluetooth device given the DBus path.
// Note that this requires an existing pairing.
// Returns true on success and false on error.
fn ConnectToBluetoothDevice(path: Path<'static>) -> bool;
//
// Pairs with a Bluetooth device given the DBus path.
// Initiates the pairing process which is handled by the Bluetooth Agent.
// Returns true on success and false on error.
// NOTE: THIS IS CURRENTLY DISABLED!
fn PairWithBluetoothDevice(path: Path<'static>) -> bool;
//
// Disconnects a Bluetooth device given the DBus path.
// Returns true on success and false on error.
fn DisconnectFromBluetoothDevice(path: Path<'static>) -> bool;
//
// This will remove the pairing on the Bluetooth device.
fn RemoveDevicePairing(path: Path<'static>) -> bool;
//
// Returns all connected Bluetooth devices.
// The first part of the HashMap is the DBus path of the object, the second is the object
// itself.
fn GetConnectedBluetoothDevices() -> Vec<BluetoothDevice>;

  ```, 
  kind: "code", 
  supplement: "Listing",
  caption: [Bluetooth DBus API for the ReSet daemon],
)<daemon_api>

#pagebreak()

#subsubsection("Audio API")
#grid(
  columns: (auto), rows: (20pt), cell(
    [#figure([], kind: table, caption: [Audio DBus Table])<wifi_type_table>], bold: true,
  ),
)
#grid(
  columns: (1fr, 2fr), rows: (20pt, 40pt, 40pt, 40pt, 40pt, 60pt), gutter: 0pt,
  cell("Type", bold: true, cell_align: left, use_under: true),
  cell("Type Description", bold: true, cell_align: left, use_under: true),
  cell("Sink", bold: true,  cell_align: left),
  cell([
DBus signature: ussqaubi\
`u32, String, String, u16, Vec<u32>, bool, i32`
    ], bold: true,  cell_align: left),
  cell("Source", bold: true,  cell_align: left, fill: silver),
  cell([
DBus signature: ussqaubi\
`u32, String, String, u16, Vec<u32>, bool, i32`
    ], bold: true,  cell_align: left, fill: silver),
  cell("InputStream", bold: true,  cell_align: left),
  cell([
DBus signature: ussuqaubb\
`u32, String, String, u32, u16, Vec<u32>, bool, bool`
    ], bold: true,  cell_align: left),
  cell("OutputStream", bold: true,  cell_align: left, fill: silver),
  cell([
DBus signature: ussuqaubb\
`u32, String, String, u32, u16, Vec<u32>, bool, bool`
    ], bold: true,  cell_align: left, fill: silver),
  cell("Card", bold: true,  cell_align: left),
  cell([
DBus signature: a(ussuqaubb)\
`Vec<(u32, String, String, u32, u16, Vec<u32>, bool, bool)>`
    ], bold: true,  cell_align: left),
)
#grid(
  columns: (1fr), rows: (20pt, 20pt, 20pt), gutter: 0pt,
  cell("Event", bold: true, cell_align: left, use_under: true),
  cell("SinkAdded -> Sink", bold: true,  cell_align: left),
  cell("SinkRemoved -> Path<'static>", bold: true,  cell_align: left, fill: silver),
  cell("SinkChanged -> Sink", bold: true,  cell_align: left),
  cell("SourceAdded -> Source", bold: true,  cell_align: left, fill: silver),
  cell("SourceRemoved -> Path<'static>", bold: true,  cell_align: left),
  cell("SourceChanged -> Source", bold: true,  cell_align: left, fill: silver),
  cell("InputStreamAdded -> InputStream", bold: true,  cell_align: left),
  cell("InputStreamRemoved -> Path<'static>", bold: true,  cell_align: left, fill: silver),
  cell("InputStreamChanged -> InputStream", bold: true,  cell_align: left),
  cell("OutputStreamAdded -> OutputStream", bold: true,  cell_align: left, fill: silver),
  cell("OutputStreamRemoved -> Path<'static>", bold: true,  cell_align: left),
  cell("OutputStreamChanged -> OutputStream", bold: true,  cell_align: left, fill: silver),
)
#grid(
  columns: (1fr, 2fr), rows: (20pt), gutter: 0pt,
  cell("DBus interface name", bold: true, cell_align: left, fill: silver),
  cell("org.Xetibo.ReSet.Audio", bold: true,  cell_align: left, fill: silver),
)
#figure(
  ```rs
// Starts the event listener and the worker for audio.
// Repeatedly starting the network listener twice will not do anything.
fn StartAudioListener();
//
// Stop the audio event listener.
// Returns true on success and false on error.
fn StopAudioListener();
//
// Returns the default sink(speaker, headphones, etc.) from pulseaudio.
fn GetDefaultSink() -> Sink;
//
// Returns the default sink name(speaker, headphones, etc.) from pulseaudio.
// This is mainly useful for checking if an event-given sink is the default one, as this
// information is not within the sink struct for performance reasons.
fn GetDefaultSinkName() -> String;
//
// Returns the default source(microphone) from pulseaudio.
fn GetDefaultSource() -> Source;
//
// Returns the default source name(microphone) from pulseaudio.
// This is mainly useful for checking if an event-given source is the default one, as this
// information is not within the source struct for performance reasons.
fn GetDefaultSourceName() -> String;
//
// Sets the default sink via name.(this is a pulse audio definition!)
// The name can be found inside the Sink struct after calling ListSinks() or by listening to
// events.
fn SetDefaultSink(sink: String) -> Sink;
//
// Sets the default sink via name.(this is a pulse audio definition!)
// The name can be found inside the Sink struct after calling ListSinks() or by listening to
// events.
fn SetDefaultSource(source: String) -> Source;
//
// Returns all current sinks.
fn ListSinks() -> Vec<Sink>;
//
// Returns all current sources.
fn ListSources() -> Vec<Source>;
//
// Returns all streams that are responsible for playing audio, e.g. applications.
fn ListInputStreams() -> Vec<InputStream>;
//
// Returns all streams that are responsible for recording audio, e.g. OBS, voice chat applications.
fn ListOutputStreams() -> Vec<OutputStream>;
//
// Returns the PulseAudio cards for every device. (The card holds information about all possible
// audio profiles and whether or not the device is disabled.)
fn ListCards() -> Vec<Card>;
```, 
kind: "code", 
supplement: "Listing",
caption: [Audio DBus API for the ReSet daemon (part1)],
)<daemon_api1>

#figure(
  ```rs
// Sets the default volume of the sink on all channels to the specified value.
// Currently ReSet does not offer individual channel volumes. (This will be added later)
// The index can be found within the Sink data structure.
fn SetSinkVolume(index: u32, channels: u16, volume: u32);
//
// Sets the mute state of the sink.
// True -> muted, False -> unmuted
// The index can be found within the Sink data structure.
fn SetSinkMute(index: u32, muted: bool);
//
// Sets the default volume of the source on all channels to the specified value.
// Currently ReSet does not offer individual channel volumes. (This will be added later)
// The index can be found within the Source data structure.
fn SetSourceVolume(index: u32, channels: u16, volume: u32);
//
// Sets the mute state of the source.
// True -> muted, False -> unmuted
// The index can be found within the Source data structure.
fn SetSourceMute(index: u32, muted: bool);
//
// Sets the default volume of the input_stream on all channels to the specified value.
// Currently ReSet does not offer individual channel volumes. (This will be added later)
// The index can be found within the InputStream data structure.
fn SetSinkOfInputStream(input_stream: u32, sink: u32);
//
// Sets the default volume of the input stream on all channels to the specified value.
// Currently ReSet does not offer individual channel volumes. (This will be added later)
// The index can be found within the InputStream data structure.
fn SetInputStreamVolume(index: u32, channels: u16, volume: u32);
//
// Sets the mute state of the input stream.
// True -> muted, False -> unmuted
// The index can be found within the InputStream data structure.
fn SetInputStreamMute(index: u32, muted: bool);
//
// Sets the target source of an output stream. 
// (The target input device for an application)
// Both the output stream and the source are indexes, 
// they can be found within their respective data structure.
fn SetSourceOfOutputStream(output_stream: u32, source: u32);
//
// Sets the default volume of the output stream on all channels to the specified value.
// Currently ReSet does not offer individual channel volumes. (This will be added later)
// The index can be found within the OutputStream data structure.
fn SetOutputStreamVolume(index: u32, channels: u16, volume: u32);
//
// Sets the mute state of the output stream.
// True -> muted, False -> unmuted
// The index can be found within the OutputStream data structure.
fn SetOutputStreamMute(index: u32, muted: bool);
//
// Sets the profile for a device according to the name of the profile.
// The available profile names can be found on the card of the device, 
// which can be received with the ListCards() function.
// The index of the device can be found in the Device data structure.
fn SetCardOfDevice(device_index: u32, profile_name: String);
```, 
kind: "code", 
supplement: "Listing",
caption: [Audio DBus API for the ReSet daemon (part2)],
)<daemon_api2>

