#import "../templates/utils.typ": *
#lsp_placate()

#section("Existing Projects")
#subsection("Gnome Control Center")
The #link("https://github.com/GNOME/gnome-control-center")[Gnome control center] [@gnome]
is as the name implies the central settings application for the Gnome desktop
environment, it offers plenty of configuration, from networks, to Bluetooth, to
online accounts, default application and a lot more. The application is written
in C with the #link("https://www.gtk.org/")[GTK] toolkit (GTK4) and follows the #link("https://developer.gnome.org/hig/")[Gnome Human Interface Guidelines].
#align(center, [#figure(
    image("../figures/gnome_control_center.png", width: 80%),
    caption: [Screenshot of the Gnome control center],
  )])<gnome_control_center>
The code structure of the control center is very modular, with each tab having
its own folder and files. Although it is hard to immediately understand each use
case of each file. Certain functionality is hard-coded with libraries, like
networks, which uses the NetworkManager library, while others are implemented
via dbus, like monitors.

Settings are stored using #link("https://gitlab.gnome.org/GNOME/dconf")[dconf] which
is a key/value system, that is optimized for reading. The form of a dconf file
is a _binary_ which makes it fast to read for dconf, but not readable for other
systems.

_Gnome control center is not supposed to be used outside the gnome environment,
especially using the wayland [@wayland] protocol. Hence not all functionality
will be available on other environments._

*Requirement fulfillment*:
#grid(
  columns: (auto, auto, auto),
  rows: (50pt, 50pt, 50pt),
  gutter: 0pt,
  cell("X", bold: true, width: 30pt),
  cell("Interoperability", bold: true, width: 90pt),
  cell(
    [Not all base features of gnome control center work on other environments, and
      gnome exclusive features can't be hidden.],
    cell_align: left,
    bold: false,
    font_size: 11pt,
  ),
  cell("\u{2713}", bold: true, width: 30pt),
  cell("Ease of Use", bold: true, width: 90pt),
  cell(
    [The user interface of gnome control center follows best practices. It has
      consistent design, naming makes sense and accessibility is taken into account.],
    cell_align: left,
    bold: false,
    font_size: 11pt,
  ),
  cell("X", bold: true, width: 30pt),
  cell("Maintainability", bold: true, width: 90pt),
  cell(
    [All features of gnome control center are within one repository, split across
      hundreds of files. This reliance on all these files in one repository creates a
      big maintainability concern.],
    cell_align: left,
    bold: false,
    font_size: 11pt,
  ),
)

#subsection("KDE System Settings")
#link("https://invent.kde.org/plasma/systemsettings")[KDE systemsettings] [@kde]
is written in C++/QML and is made with the #link("https://www.qt.io/")[QT toolkit].
It follows the KDE style of applications, featuring a very large variety of
settings (on KDE), and offering other applications a way to integrate into this
application via KConfig Module(KCM).
#align(center, [#figure(
    image("../figures/kde_systemsettings.png", width: 80%),
    caption: [Screenshot of the KDE systemsettings],
  )])<kde_systemsettings>
The program is by default very slim and does not feature any standard settings
on the repository. However, Linux distributions usually ship the KDE standard
modules, as KDE is the intended environment for this application. For ReSet, KDE
systemsettings is still a very good resource on implementing modularity with
this type of application. The only caveat would be the obvious difference in
both programming language and toolkit. This is especially a problem since QT
uses its own scripting language QML, which is based on JavaScript.

Settings are stored by individual modules, which means that a lot of individual
files will be written/read in order to provide all functionality.

_In many cases for KDE systemsettings it is not the application itself that makes
it harder to be used on other environments, but the toolkit and the KDE specific
styling of said toolkit that might not integrate well._

#grid(
  columns: (auto, auto, auto),
  rows: (auto, auto, auto),
  gutter: 0pt,
  cell("(\u{2713})", bold: true, width: 30pt, height: 90pt),
  cell("Interoperability", bold: true, width: 90pt, height: 90pt),
  cell(
    [KDE systemsettings is built with modularity in mind, meaning it works purely
      with modules that can be built for it. This means that one could create modules
      for systemsettings to enable functionality on other environments. However, QT is
      not as well integrated into other environments as GTK, requiring users to
      potentially change themes for a consistent design. Additionally, the needed
      modules do not exist as of now.],
    cell_align: left,
    bold: false,
    font_size: 11pt,
    height: 90pt,
  ),
  cell("X", bold: true, width: 30pt, height: 60pt),
  cell("Ease of Use", bold: true, width: 90pt, height: 60pt),
  cell(
    [The most common criticism of KDE systemsettings is a convoluted design. This
      stems from the sheer amount of settings the application can provide, alongside
      its heavy use of submenues that can become confusing when searching for
      something specific.],
    cell_align: left,
    bold: false,
    font_size: 11pt,
    height: 60pt,
  ),
  cell("(\u{2713})", bold: true, width: 30pt, height: 80pt),
  cell("Maintainability", bold: true, width: 90pt, height: 80pt),
  cell(
    [The modular design of KDE systemsettings allows for great maintainability on the
      application itself. It is however noteworthy that the configuration files
      created by KCM tends to fill folders with seemingly random files. This means
      that changing settings outside KDE systemsettings can be a challenge.],
    cell_align: left,
    bold: false,
    font_size: 11pt,
    height: 80pt,
  ),
)

#subsection("Standalone Settings")
These applications focus on one specific functionality and don't offer anything
else. This means one would need to use multiple of these, in order to replicate
what the other 2 discussed programs offer.

Interoperability will not be considered for these applications, as they were
made for this use case.

#link("https://gitlab.freedesktop.org/pulseaudio/pavucontrol")[*Pavucontrol*] |
Sound Application\
Pavucontrol or Pulseaudio Volume Control is an application that handles both
system wide input/output, per application output and input streams. It is under
the umbrella of the Free Desktop project and is directly involved in PulseAudio
itself. The application itself is written in C++ and GTK3.
#align(center, [#figure(
    image("../figures/pavucontrol.png", width: 80%),
    caption: [Screenshot of pavucontrol],
  )])<pavucontrol>

#grid(
  columns: (auto, auto, auto),
  rows: (auto, auto),
  gutter: 0pt,
  cell("\u{2713}", bold: true, width: 30pt, height: 50pt),
  cell("Ease of Use", bold: true, width: 90pt, height: 50pt),
  cell(
    [While pavucontrol is generally made for more advanced users, it does follow
      general best practices and integrates well into all environments.],
    cell_align: left,
    bold: false,
    font_size: 11pt,
    height: 50pt,
  ),
  cell("\u{2713}", bold: true, width: 30pt, height: 50pt),
  cell("Maintainability", bold: true, width: 90pt, height: 50pt),
  cell(
    [Pavucontrol is made with a modular codebase, which allows for easier adding of
      features. Note: pavucontrol is feature complete, and will likely not get more
      features in the future.],
    cell_align: left,
    bold: false,
    font_size: 11pt,
    height: 50pt,
  ),
)
#pagebreak()

#link("https://github.com/blueman-project/blueman")[*Blueman*] | Bluetooth
Application\
Blueman allows connecting and managing of Bluetooth connections, as well as some
quality of life features like sending of files. It works great in functionality,
but the buttons are not very expressive in what they will achieve. Blueman is
written in Python and GTK3.
#align(center, [#figure(
    image("../figures/bluetooth_manager.png", width: 80%),
    caption: [Screenshot of blueman],
  )])<blueman>

#grid(
  columns: (auto, auto, auto),
  rows: (auto, auto),
  gutter: 0pt,
  cell("X", bold: true, width: 30pt, height: 70pt),
  cell("Ease of Use", bold: true, width: 90pt, height: 70pt),
  cell(
    [The user interface for blueman can be rather confusing, for example: there is no
      obvious connect button, which might lead to a user trying to re-pair a device
      instead of connecting to it.(pairing is the \u{2713} button)\
      Blueman also tends to look a bit old depending on the icon.],
    cell_align: left,
    bold: false,
    font_size: 11pt,
    height: 70pt,
  ),
  cell("\u{2713}", bold: true, width: 30pt, height: 50pt),
  cell("Maintainability", bold: true, width: 90pt, height: 50pt),
  cell(
    [Blueman follows best practices and can be considered as easily maintainable.],
    cell_align: left,
    bold: false,
    font_size: 11pt,
    height: 50pt,
  ),
)

#pagebreak()

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

#grid(
  columns: (auto, auto, auto),
  rows: (auto, auto),
  gutter: 0pt,
  cell("X", bold: true, width: 30pt, height: 50pt),
  cell("Ease of Use", bold: true, width: 90pt, height: 50pt),
  cell(
    [While terminal user interfaces can be great for the right user, this interface
      is not the most modern, and it does not adapt to resizing.],
    cell_align: left,
    bold: false,
    font_size: 11pt,
    height: 50pt,
  ),
  cell("\u{2713}", bold: true, width: 30pt, height: 50pt),
  cell("Maintainability", bold: true, width: 90pt, height: 50pt),
  cell(
    [The scope of this application is small and depends fully on the parent project,
      it can be considered maintainable.],
    cell_align: left,
    bold: false,
    font_size: 11pt,
    height: 50pt,
  ),
)
