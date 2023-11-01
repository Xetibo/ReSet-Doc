#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Architecture")

#align(center, [#figure(
    image("../../files/architecture.svg", width: 100%),
    caption: [Architecture of ReSet],
  )<domain_model>])

#subsubsection("Description")
Base functionality is provided using well known Linux system services such as
Pipewire for audio, NetworkManager for network and bluez for Bluetooth. These
services will be either integrated direct IPC or libraries, depending on the
service. Additional systems will be integrated with a plugin-system which allows
for integration of specific environments.

Interaction with the daemon can either be done with the user interface frontend,
or with IPC interaction from another source, this is explicitly done to allow
third party applications to also use ReSet.

The plugins are made via dyanmic libraries, which are loaded by both the daemon
and the frontend. The daemon#super([@daemon]) part handles the functionality of the plugin, while
the frontend needs a way to display the data to the user in a suitable manner.

The example environments are only a selection, a plugin could be made for any
environment.
