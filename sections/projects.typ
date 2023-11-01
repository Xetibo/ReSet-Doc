#import "../templates/utils.typ": *
#lsp_placate()

#section("Analysis of existing applications")

In this chapter, several different applications are analyzed according to the
requirements specified in @PRequirements. Both full settings applications
provided by environments and standalone applications for individual technologies
are compared.

#subsection(custom_tag: "PRequirements", "Requirements")
For ReSet, 3 different categories will be used to weigh existing projects and
potential solutions.

- #text(size: 11pt, [*Interoperability*])\
  This is the most important aspect, as it was the main driving factor for this
  work. Interoperability for ReSet is defined as the ease of use of a particular
  project in different environments. Important to note, is that multiple factors
  are considered:
  - *amount of working features*
  - *amount of non-working features*\
    This specifically refers to residue entries that would work on the expected
    environment, but not on other environments.
  - *interoperability of toolkit*\
    Depending on the toolkit, it might behave differently with specific modules
    missing from other environments, this would once again increase the amount of
    additional work is needed, in order to get the expected interface.
  - *behavior on different environments*\
    Depending on the environment, applications have different ways of displaying
    themselves with different attributes like a minimum size. These constraints
    might not work well with different types of window management. A tiling window
    manager does not consider the minimum size of an application, as it will place
    it according to its layout rule. Applications with large minimum sizes are
    therefore preferably avoided.
- #text(size: 11pt, [*Ease of use*])\
  While functionality is important, the intention is to provide an application
  that is used by preference, not necessity.
- #text(size: 11pt, [*Maintainability*])\
  Applications with a plethora of functionality will get large quickly. This poses
  a particularly hard challenge for developers to keep the project maintainable.
  Too many features without a well-thought-out architecture will lead to
  potentially faulty code.

// no universal app
//#subsection("Solution")
//ReSet will be a set of 2 applications featuring one user interface application
//that will have common settings available for the user.\
//The second part of ReSet will be a daemon, which will be used to interact with
//necessary services, such as audio servers, configuration files and more.\
//This configuration also allows us to deliver an API, with which other
//applications can interact with the daemon, this means that ReSet can be used
//with applets, status bars and more, which are common in the Linux ecosystem.\
//In order to respect accessibility and the requirements of a Linux application,
//ReSet will also provide a command line version to interact with the
//Reset-Daemon.

#pagebreak()

#subsection("Gnome Control Settings")
The #link("https://github.com/gnome/gnome-control-center")[Gnome control center]#super([@Gnome])
is as the name implies the central settings application for the Gnome desktop
environment, it offers plenty of configuration, from networks to Bluetooth, to
online accounts, default application and a lot more. The application is written
in C with the #link("https://www.gtk.org/")[GTK] toolkit (GTK4) and follows the #link("https://developer.Gnome.org/hig/")[Gnome Human Interface Guidelines].
#align(center, [#figure(
    image("../figures/gnome_control_center.png", width: 80%),
    caption: [Screenshot of the Gnome control center],
  )])<Gnome_control_center>
The code structure of the control center is very modular, with each tab having
its own folder and files. Although it is hard to immediately understand each use
case of each file. Certain functionality is hard-coded with libraries, like
networks, which uses the NetworkManager library, while others are implemented
via dbus, like monitors.

Settings are stored using #link("https://gitlab.gnome.org/gnome/dconf")[dconf] which
is a key/value system, that is optimized for reading. The form of a dconf file
is a _binary_ which makes it fast to read for dconf, but not readable for other
systems.

_Gnome control center is not supposed to be used outside the Gnome environment,
especially using the Wayland#super([@wayland]) protocol. Hence, not all functionality
will be available on other environments._

#grid(columns: (auto), rows: (20pt), cell([#figure(
    [],
    kind: table,
    caption: [Gnome Control Center Requirement Fulfillment],
  )<gnomerequirements>], bold: true))
#grid(
  columns: (30pt, 3fr, 9fr),
  rows: (auto, 50pt, 50pt, 50pt),
  gutter: 0pt,
  cell("", bold: true, height: 20pt, cell_align: left, use_under: true),
  cell(
    "Category",
    bold: true,
    height: 20pt,
    cell_align: left,
    use_under: true,
  ),
  cell(
    "Justification",
    bold: true,
    height: 20pt,
    cell_align: left,
    use_under: true,
  ),
  cell("X", bold: true, cell_align: left),
  cell("Interoperability", bold: true, cell_align: left),
  cell(
    [Not all base features of Gnome control center work on other environments, and
      Gnome exclusive features can't be hidden.],
    cell_align: left,
    bold: false,
    font_size: 11pt,
  ),
  cell("\u{2713}", bold: true, cell_align: left),
  cell("Ease of Use", bold: true, cell_align: left),
  cell(
    [The user interface of the Gnome control center follows best practices. It has
      consistent design, naming makes sense and accessibility is taken into account.],
    cell_align: left,
    bold: false,
    font_size: 11pt,
  ),
  cell("X", bold: true, cell_align: left),
  cell("Maintainability", bold: true, cell_align: left),
  cell(
    [All features of the Gnome control center are within one repository, split across
      hundreds of files. This reliance on all these files in one repository creates a
      big maintainability concern.],
    cell_align: left,
    bold: false,
    font_size: 11pt,
  ),
)

#subsection("KDE System Settings")
#link("https://invent.kde.org/plasma/systemsettings")[KDE systemsettings]#super([@kde])
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

#pagebreak()

#grid(
  columns: (auto),
  rows: (20pt),
  cell(
    [#figure([], kind: table, caption: [KDE Systemsettings Requirement Fulfillment])<kderequirements>],
    bold: true,
  ),
)
#grid(
  columns: (30pt, 3fr, 9fr),
  rows: (25pt, 110pt, 70pt, 75pt),
  gutter: 0pt,
  cell("", bold: true, use_under: true),
  cell("Category", bold: true, use_under: true, cell_align: left),
  cell("Justification", bold: true, use_under: true, cell_align: left),
  cell("(\u{2713})", bold: true, cell_align: left),
  cell("Interoperability", bold: true, cell_align: left),
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
  ),
  cell("X", bold: true, cell_align: left),
  cell("Ease of Use", bold: true, cell_align: left),
  cell(
    [The most common criticism of KDE systemsettings is a convoluted design. This
      stems from the sheer amount of settings the application can provide, alongside
      its heavy use of submenus that can become confusing when searching for something
      specific.],
    cell_align: left,
    bold: false,
    font_size: 11pt,
  ),
  cell("\u{2713}", bold: true, cell_align: left),
  cell("Maintainability", bold: true, cell_align: left),
  cell(
    [The modular design of KDE systemsettings allows for great maintainability on the
      application itself. It is however noteworthy that the configuration files
      created by KCM tend to fill folders with seemingly random files. This means that
      changing settings outside KDE systemsettings can be a challenge.],
    cell_align: left,
    bold: false,
    font_size: 11pt,
  ),
)

#pagebreak()

#subsection("Standalone Settings")
These applications focus on one specific functionality and don't offer anything
else. This means one would need to use multiple of these, in order to replicate
what the other 2 discussed programs offer.

Interoperability will not be considered for these applications, as they were
made for this use case.

#link("https://gitlab.freedesktop.org/pulseaudio/pavucontrol")[*Pavucontrol*] |
Sound Application\
Pavucontrol or Pulseaudio Volume Control is an application that handles both
system-wide input/output, per application output and input streams. It is under
the umbrella of the Free Desktop project and is directly involved in PulseAudio
itself. The application itself is written in C++ and GTK3.
#align(center, [#figure(
    image("../figures/pavucontrol.png", width: 80%),
    caption: [Screenshot of pavucontrol],
  )])<pavucontrol>

\

#grid(
  columns: (auto),
  rows: (20pt),
  cell(
    [#figure([], kind: table, caption: [Pavucontrol Requirement Fulfillment])<pavurequirements>],
    bold: true,
  ),
)
#grid(
  columns: (30pt, 3fr, 9fr),
  rows: (25pt, 55pt, 40pt),
  gutter: 0pt,
  cell("", bold: true, cell_align: left, use_under: true),
  cell("Category", bold: true, cell_align: left, use_under: true),
  cell("Justification", bold: true, cell_align: left, use_under: true),
  cell("\u{2713}", bold: true, cell_align: left),
  cell("Ease of Use", bold: true, cell_align: left),
  cell(
    [While pavucontrol is generally made for more advanced users, it does follow
      general best practices and integrates well into all environments.],
    cell_align: left,
    bold: false,
    font_size: 11pt,
  ),
  cell("\u{2713}", bold: true, cell_align: left),
  cell("Maintainability", bold: true, cell_align: left),
  cell(
    [Pavucontrol is made with a modular codebase, which allows for easier adding of
      features. Note: pavucontrol is feature complete, and will likely not get more
      features in the future.],
    cell_align: left,
    bold: false,
    font_size: 11pt,
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
    image("../figures/bluetooth_manager_filled.png", width: 80%),
    caption: [Screenshot of blueman],
  )])<blueman>

\

#grid(
  columns: (auto),
  rows: (30pt),
  cell(
    [#figure([], kind: table, caption: [Bluetooth Manager Requirement Fulfillment])<bluetoothrequirements>],
    bold: true,
  ),
)
#grid(
  columns: (30pt, 3fr, 9fr),
  rows: (30pt, 65pt, 40pt),
  gutter: 0pt,
  cell("", bold: true, cell_align: left, use_under: true),
  cell("Category", bold: true, cell_align: left, use_under: true),
  cell("Justification", bold: true, cell_align: left, use_under: true),
  cell("X", bold: true, cell_align: left),
  cell("Ease of Use", bold: true, cell_align: left),
  cell(
    [The user interface for blueman can be rather confusing, for example: there is no
      obvious connect button, which might lead to a user trying to re-pair a device
      instead of connecting to it.(pairing is the \u{2713} button)\
      Blueman also tends to use older icon design.],
    cell_align: left,
    bold: false,
    font_size: 11pt,
  ),
  cell("\u{2713}", bold: true, cell_align: left),
  cell("Maintainability", bold: true, cell_align: left),
  cell(
    [Blueman follows best practices and can be considered as easily maintainable.],
    cell_align: left,
    bold: false,
    font_size: 11pt,
  ),
)

#pagebreak()

#link(
  "https://gitlab.freedesktop.org/NetworkManager/NetworkManager",
)[*Nmtui*] | Network Application\
Nmtui is what the name suggests, it is a terminal user interface that allows
users to use and edit network connections, including VPN connections.\
Nmtui is located in the same project as the network manager itself and is
therefore also shipped as part of the network manager package.\
Both network manager and nmtui are written in C.\
There is a specific lack of standalone user interface applications for network
managers.\
Technically, there exists a #link(
  "https://gitlab.gnome.org/gnome/network-manager-applet",
)[network manager applet], however, this is to be included in status bars and
does not work on its own.
#align(center, [#figure(
    image("../figures/nmtui.png", width: 80%),
    caption: [Screenshot of nmtui],
  )])<nmtui>

#grid(
  columns: (auto),
  rows: (30pt),
  cell(
    [#figure([], kind: table, caption: [Nmtui Requirement Fulfillment])<nmtuirequirements>],
    bold: true,
  ),
)
#grid(
  columns: (30pt, 3fr, 9fr),
  rows: (30pt, 40pt, 30pt),
  gutter: 0pt,
  cell("", bold: true, cell_align: left, use_under: true),
  cell("Category", bold: true, cell_align: left, use_under: true),
  cell("Justification", bold: true, cell_align: left, use_under: true),
  cell("X", bold: true, cell_align: left),
  cell("Ease of Use", bold: true, cell_align: left),
  cell(
    [Resizing the terminal breaks the appearance of the application.\
      There is only a single theme.],
    cell_align: left,
    bold: false,
    font_size: 11pt,
  ),
  cell("\u{2713}", bold: true, cell_align: left),
  cell("Maintainability", bold: true, cell_align: left),
  cell(
    [The scope of this application is small and depends fully on the parent project,
      it can be considered to be maintainable.],
    cell_align: left,
    bold: false,
    font_size: 11pt,
  ),
)
