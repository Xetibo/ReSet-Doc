#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Architecture")

#align(
  center, [#figure(
      img("architecture.svg", width: 100%, extension: "files"), caption: [Architecture of ReSet],
    )<domain_model>],
)

#subsubsection("Description")
*Hyprland, GNOME, KDE* | Various desktop environments or window
managers/compositors.\
*PulseAudio* | The de-facto default Linux sound server.\
*bluez* | The standard Linux Bluetooth stack.\
*NetworkManager* | A very popular Linux network stack.\
*ReSet* | The graphic user interface for ReSet.\
*ReSet-Daemon* | The backend process for ReSet that handles functionality.\

Base functionality is provided using well-known Linux system services such as
PulseAudio @pulseaudio for audio, NetworkManager @networkmanager_repo for network and bluez @bluez for Bluetooth. These
services will be either integrated IPC APIs or libraries, depending on the
service. Additional systems will be integrated with a plugin-system which allows
for integration of specific environments.

Interaction with the daemon can either be done with the user interface
application provided by ReSet or with IPC interaction from another source, this
is explicitly done to allow third-party applications to also use ReSet.

The plugins are made via dynamic libraries, which are loaded by both the daemon
and the user interface application. The daemon part handles the functionality of
the plugin, while the user interface application needs a way to display the data
to the user in a suitable manner.

The example environments are only a selection, a plugin could be made for any
environment.
