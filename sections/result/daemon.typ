#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Daemon Implementation")
This section documents the code for the backend part of ReSet.

#subsubsection("MainLoop")
The mainloop exposes the DBus interface to other applications, and responds to
method calls on this API. In order to provide functionality, the mainloop
requires a different set of data from the different functinalities. This state
is provided as a context and can be accessed only within the mainloop.

#figure(sourcecode(```rs
// run the mainloop
TODO

// the data struct used by the mainloop
TODO
```), caption: [Code snippet from the daemon DBus mainloop])<mainloop>

With these basic datastructures, the daemon would be able to use basic
*synchronous* functions, however, for ReSet, it is necessary to provide
asynchronous functionality such as events, which might be created by an entirely
different software.

For this reason, each base functionality of ReSet is done via listeners, which
can be activated and de-activated via the DBus API. Client of this API can hence
decide themselves whether or not they would like to use this asynchronous
functionality.

#subsubsection("Audio")
As planned in @Architecture, the pulseaudio library was used to implement the
audio portion of the ReSet daemon. In concrete terms, the library//@lib_pulse
TODO, which wraps the C pulseudio functions to rust was used.

Similarily to the mainloop, a listener loop is created for pulseaudio which will
continue to recieve events from both the pulseaudio server and the DBus daemon.
Pulseaudio events are handled directly with the library listener, which allows
for a listener flag for customized event filters, while the daemon events are
handled via the rust native multi-producer single-consumer message passing
channel.

#figure(sourcecode(```rs
// filter for pulseaudio events
TODO

// listener loop
TODO

// example pulseaudio event
TODO

// example daemon event
TODO
```), caption: [Audio events and listener loop])<audio_code>

Actions from the pulseaudio listener are handled either with a reverse message
passing channel for direct requests from the daemon, or as a DBus event, for
which the thread-safe connection reference of the daemon is used. This allows
sending of messages right within the pulseuadio listener.

#figure(sourcecode(```rs
// Example of DBus event
TODO
```), caption: [Betooth events])<bluetooth_events>

#subsubsection("Bluetooth")
For bluetooth, no further library was necessary, as bluez, the default bluetooth
module for linux is accessed via DBus.

The Bluetooth part is created as a DBus client to bluez that will call DBus
methods, and potentially listen for events on various different DBus objects(if
desired by clients of ReSet).

#figure(sourcecode(```rs
// Bluetooth listener as DBus client
TODO
```), caption: [Betooth listener code snippet])<bluetooth_listener>

The biggest challenge with these interfaces is the clean access of all needed
functionality. For example, fetching all currently available Bluetooth devices
have to be done via the ObjectManager object provided by the freedesktop DBus
API, while the actual information about these devices are provided by the bluez
DBus API.

#figure(sourcecode(```rs
// Fetching of Bluetooth devices
TODO

// Fetching of Bluetooth device infromation
TODO
```), caption: [Bluetooth fetching methods])<bluetooth_methods>

A big difference to the pulseaudio listener is that the vast majority of the
functions can be used without the listener, for pulseaudio, *every* function has
to use the listener via the message passing channel. For clients of ReSet, this
means that a simpler usage without events is possible as well.

Within the listener for events, the responses can also be sent to DBus directly
with another thread-safe reference to the daemon context.

#subsubsubsection("Bluez")
For bluez ReSet offers two structs, the Bluetooth Adapter, which is used to
connect to devices, and the devices themselves.

#figure(sourcecode(```rs
// Bluetooth Adapter
TODO

// Bluetooth Device
TODO
```), caption: [Bluetooth datastructures])<bluetooth_structures>

#subsubsection("Wireless Network")
The current last piece of functionality is also accessible via DBus.

The challenge with NetworkManager is its vast amount of features it offers,
besides regular networks it also offers VPN configuration and usage, as well as
other connections, including older protocols. For now, ReSet only offers
wireless network configuration, however in the future this may be expanded upon,
the library repository for ReSet already features entries for both VPN and wired
connections.

The rest of the wireless part is implemented like Bluetooth with an optional
listener exposed for clients.

#subsubsubsection("Network Manager")
ReSet uses 5 different parts of NetworkManager. Namely the base NetworkManager,
the settings manager which handles existing connections and their properties,
the wifi devices that are used to connect to access points, the access points
themselves, and all currently active connections.

// TODO architecture of this

#figure(sourcecode(```rs
// Wifi Device
TODO

// Access Point
TODO
```), caption: [Wifi datastructures])<wifi_structures>
In order to provide simplicity, ReSet will only offer two different structs to
clients, a wifi device and an access point. All other information is stored
within these. As an example, the before mentioned associated connection is
stored within the access point itself.
