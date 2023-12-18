#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Datastructures")
This section covers all relevant data structures used within ReSet and its
daemon.

#subsubsection("Audio/PulseAudio")
For PulseAudio, ReSet offers a struct for sinks, sources, sink inputs, source outputs and cards.
These translate to audio outpout device, audio input device, audio output stream, audio intut stream and audio codec profiles respectively.

The datastructures for sink/source and inputstream/outputstream have the same properties.

#figure(
  sourcecode(```rs
// Sink/Source
#[derive(Debug, Clone, Default)]
pub struct Sink {
    pub index: u32,
    pub name: String,
    pub alias: String,
    pub channels: u16,
    pub volume: Vec<u32>,
    pub muted: bool,
    pub active: i32,
}

#[derive(Debug, Clone, Default)]
pub struct InputStream {
    pub index: u32,
    pub name: String,
    pub application_name: String,
    pub sink_index: u32,
    pub channels: u16,
    pub volume: Vec<u32>,
    pub muted: bool,
    pub corked: bool,
}

#[derive(Debug, Clone, Default)]
pub struct Card {
    pub index: u32,
    pub name: String,
    pub profiles: Vec<CardProfile>,
    pub active_profile: String,
}
```), kind: "code", supplement: "Listing", caption: [Bluetooth data structures],
)<audio_structures>

#pagebreak()

#subsubsection("Bluetooth/Bluez")
For bluez, ReSet-Lib offers two structures, the Bluetooth Adapter, which is used to
connect to devices, and the devices themselves.

#figure(
  sourcecode(```rs
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
```), kind: "code", supplement: "Listing", caption: [Bluetooth data structures],
)<bluetooth_structures>

#subsubsection("Wi-Fi/NetworkManager")
For NetworkManager, ReSet offers two structures, WifiDevice and AccessPoint.

#figure(sourcecode(```rs
// Wi-Fi Device
#[derive(Debug, Clone, Default)]
pub struct WifiDevice {
    pub path: Path<'static>,
    pub name: String,
    pub active_access_point: Vec<u8>,
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
