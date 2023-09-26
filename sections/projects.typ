#import "../templates/utils.typ": *
#show_glossary()
#section("Existing Projects")
#subsection([#link(
    "https://github.com/GNOME/gnome-control-center",
  )[Gnome Control Settings]])
The Gnome [@gnome] control center is as the name implies the central settings
application for the Gnome desktop environment, it offers plenty of
configuration, from networks, to Bluetooth, to online accounts, default
application and a lot more.\
The application is written in C with the #link("https://www.gtk.org/")[GTK] toolkit
(GTK4) and follows the #link("https://developer.gnome.org/hig/")[Gnome Human Interface Guidelines].\
#align(center, [#figure(
    image("../figures/gnome_control_center.png", width: 80%),
    caption: [Screenshot of the Gnome control center],
  )])<gnome_control_center>
The code structure of the control center is very modular, with each tab having
its own folder and files.\
Although it is hard to immediately understand each use case of each file.\
Certain functionality is hard-coded with libraries, like networks, which uses
the NetworkManager library, while others are implemented via dbus, like
monitors.\

Settings are stored using #link("https://gitlab.gnome.org/GNOME/dconf")[dconf] which
is a key/value system, that is optimized for reading.\
The form of a dconf file is a _binary_ which makes it fast to read for dconf,
but not readable for other systems.

_Gnome control center is not supposed to be used outside the gnome environment,
especially using the wayland [@wayland] protocol.\
Hence not all functionality will be available on other environments._

*Requirement fulfillment*:
//#grid(
//  columns: (auto, auto, auto, auto, auto),
//  rows: (auto, auto, auto, auto, auto),
//  gutter: 0pt,
//  cell("7", bold: true),
//  cell("3", bold: true),
//  cell("8", bold: true),
//  cell("5", bold: true),
//  cell("4", bold: true),
//  cell("Modularity", font_size: 12pt),
//  cell("Cross-Environment", font_size: 12pt),
//  cell("User Interface", font_size: 12pt),
//  cell("Functionality", font_size: 12pt),
//  cell("Maintainability", font_size: 12pt),
//)

#subsection(
  [#link("https://invent.kde.org/plasma/systemsettings")[KDE System Settings]],
)
KDE [@kde] systemsettings is written in C++/QML and is made with the #link("https://www.qt.io/")[QT toolkit].\
It follows the KDE style of applications, featuring a very large variety of
settings (on KDE), and offering other applications a way to integrate into this
application via KConfig Module(KCM).\
#align(center, [#figure(
    image("../figures/kde_systemsettings.png", width: 80%),
    caption: [Screenshot of the KDE systemsettings],
  )])<kde_systemsettings>
The program is by default very slim and does not feature any standard settings
on the repository.\
However, Linux distributions usually ship the KDE standard modules, as KDE is
the intended environment for this application.\
For ReSet, KDE systemsettings is still a very good resource on implementing
modularity with this type of application.\
The only caveat would be the obvious difference in both programming language and
toolkit. This is especially a problem since QT uses its own scripting language
QML, which is based on JavaScript.

Settings are stored by individual modules, which means that a lot of individual
files will be written/read in order to provide all functionality.

_In many cases for KDE systemsettings it is not the application itself that makes
it harder to be used on other environments, but the toolkit and the KDE specific
styling of said toolkit that might not integrate well._

*Requirement fulfillment:*
//#grid(
//  columns: (auto, auto, auto, auto, auto),
//  rows: (auto, auto, auto, auto, auto),
//  gutter: 0pt,
//  cell("10", bold: true),
//  cell("6", bold: true),
//  cell("4", bold: true),
//  cell("9", bold: true),
//  cell("7", bold: true),
//  cell("Modularity", font_size: 12pt),
//  cell("Cross-Environment", font_size: 12pt),
//  cell("User Interface", font_size: 12pt),
//  cell("Functionality", font_size: 12pt),
//  cell("Maintainability", font_size: 12pt),
//)

#subsection("Standalone Settings")
These applications focus on one specific functionality and don't offer anything
else.\
This means one would need to use multiple of these, in order to replicate what
the other 2 discussed programs offer.

#link("https://gitlab.freedesktop.org/pulseaudio/pavucontrol")[*Pavucontrol*] |
Sound Application\
Pavucontrol or Pulseaudio Volume Control is an application that handles both
system wide input/output, per application output and input streams.\
It is under the umbrella of the Free Desktop project and is directly involved in
PulseAudio itself.\
The application itself is written in C++ and GTK3.
#align(center, [#figure(
    image("../figures/pavucontrol.png", width: 80%),
    caption: [Screenshot of pavucontrol],
  )])<pavucontrol>

*Requirement fulfillment:*
//#grid(
//  columns: ( auto, auto, auto, auto),
//  rows: ( auto, auto, auto, auto),
//  gutter: 0pt,
//  cell("8", bold: true),
//  cell("10", bold: true),
//  cell("7", bold: true),
//  cell("6", bold: true),
//  cell("Modularity", font_size: 12pt),
//  cell("Cross-Environment", font_size: 12pt),
//  cell("User Interface", font_size: 12pt),
//  cell("Maintainability", font_size: 12pt),
//)

#link("https://github.com/blueman-project/blueman")[*Blueman*] | Bluetooth
Application\
Blueman allows connecting and managing of bluetooth connections, as well as some
quality of life features like sending of files.\
It works great in functionality, but the buttons are not very expressive in what
they will achieve.\
Blueman is written in Python and GTK3.
#align(center, [#figure(
    image("../figures/bluetooth_manager.png", width: 80%),
    caption: [Screenshot of blueman],
  )])<blueman>

*Requirement fulfillment:*
//#grid(
//  columns: ( auto, auto, auto, auto),
//  rows: ( auto, auto, auto, auto),
//  gutter: 0pt,
//  cell("5", bold: true),
//  cell("10", bold: true),
//  cell("3", bold: true),
//  cell("6", bold: true),
//  cell("Modularity", font_size: 12pt),
//  cell("Cross-Environment", font_size: 12pt),
//  cell("User Interface", font_size: 12pt),
//  cell("Maintainability", font_size: 12pt),
//)

#link(
  "https://gitlab.freedesktop.org/NetworkManager/NetworkManager",
)[*Nmtui*] | Network Application\
Nmtui is what the name suggests, it's a terminal user interface that allows
users to use and edit network connections, including VPN connections.\
Nmtui is located in the same project as network manager itself and is therefore
also shipped as part of the network manager package.\
Both network manager and nmtui are written in C.\
There is a specific lack of standalone user interface applications for network
manger.\
Technically, there exists a #link(
  "https://gitlab.gnome.org/GNOME/network-manager-applet",
)[network manager applet], however this is to be included in status bars and
does not work on its own.
#align(center, [#figure(
    image("../figures/nmtui.png", width: 80%),
    caption: [Screenshot of nmtui],
  )])<nmtui>

*Requirement fulfillment:*
//#grid(
//  columns: ( auto, auto, auto, auto),
//  rows: ( auto, auto, auto, auto),
//  gutter: 0pt,
//  cell("5", bold: true),
//  cell("10", bold: true),
//  cell("2", bold: true),
//  cell("6", bold: true),
//  cell("Modularity", font_size: 12pt),
//  cell("Cross-Environment", font_size: 12pt),
//  cell("User Interface", font_size: 12pt),
//  cell("Maintainability", font_size: 12pt),
//)
