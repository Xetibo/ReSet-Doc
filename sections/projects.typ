#import "../templates/utils.typ": *
#lsp_placate()

#section("Research")
In order to develop ReSet, several existing applications, potential
implementations for features and literature were analyzed.

#subsection(custom_tag: "PRequirements", "Project Requirements")
For ReSet, three different categories will be used to weigh existing projects
and potential solutions.\
Simoultaneously, these are also requirements for ReSet itself.

- #text(size: 11pt, [*Interoperability*])\
  This is the most important aspect, as it was the main driving factor for this
  work. Interoperability for ReSet is defined as the ease of use of a particular
  project in different environments. Important to note, is that multiple factors
  are considered:
  - *Amount of working features*\
    The amount of features of the application that work on every environment.
  - *Amount of non-working features*\
    This specifically refers to residue entries that would work on the expected
    environment, but not in other environments.
  - *Interoperability of toolkit*\
    Depending on the toolkit, it might behave differently with specific modules
    missing from other environments, this would once again increase the amount of
    additional work needed, in order to get the expected interface.
  - *Behavior in different environments*\
    Depending on the environment, applications have different ways of displaying
    themselves with different attributes like a minimum size. These constraints
    might not work well with different types of window management. A tiling window
    manager does not consider the minimum size of an application, as it will place
    the window according to its layout rule. Applications with large minimum sizes
    are therefore preferably avoided.
- #text(size: 11pt, [*Ease of use*])\
  While functionality is important, the intention is to provide an application
  that is used by preference. This means that the application should be intuitive
  and usable without prior knowledge about the application. To achieve this, ReSet
  will use best practices from the GNOME Human Interface Guidelines as well as
  user interface literature described in @UserInterfaceGuidelines.

- #text(size: 11pt, [*Maintainability*])\
  Applications with a plethora of functionality will get large quickly. This poses
  a particularly hard challenge for developers to keep the project maintainable.
  Too many features without a well-thought-out architecture will lead to
  potentially faulty code.

#subsection("Analysis of existing applications")
In this section, several different applications are analyzed according to the
requirements specified in @PRequirements. Both full settings applications
provided by environments and standalone applications for individual technologies
are compared.

Important to note, that for this section, each application will be evaluated with its
default dark theme. For GTK applications, the libadwaita dark theme will be
used. For QT applications, the breeze dark theme will be used, configured via
the QT_QPA_PLATFORMTHEME=gnome environment flag. This configuration is done to
keep a consistent look for all applications, without potentially compromising
their look with non-native themes.

// no universal app
//#subsubsection("Solution")
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

#subsubsection("GNOME Control Settings")
The GNOME control center@gnome_control_center is as the name implies the central
settings application for the GNOME desktop environment, it offers plenty of
configuration, from networks to Bluetooth, to online accounts, default
applications and a lot more. The application is written in C with the GTK@gtk
toolkit (GTK4) and follows the GNOME Human Interface
Guidelines@gnome_human_guidelines.
#align(
  center, [#figure(
      img("gnome_control_center.png", width: 80%), caption: [Appearance setting of GNOME control center],
    )],
)<Gnome_control_center>
The code structure of the control center is very modular, with each tab having
its folder and files. Although it is hard to immediately understand each use
case of each file. Certain functionality is hard-coded with libraries, like
networks, which use the NetworkManager library, while others are implemented via
Dus, like monitors.

Settings are stored using dconf@dconf which is a key/value system, that is
optimized for reading. The form of a dconf file is a _binary_ which makes it
fast to read for dconf, but not readable for other systems.

GNOME control center is not supposed to be used outside the GNOME environment,
especially using the Wayland protocol. Hence, not all functionality will be
available on other environments.

#grid(
  columns: (auto), rows: (20pt), cell(
    [#figure(
        [], kind: table, caption: [GNOME Control Center Requirement Fulfillment],
      )<gnomerequirements>], bold: true,
  ),
)
#grid(
  columns: (3fr, 9fr, 30pt), rows: (auto, 50pt, 50pt, 50pt), gutter: 0pt, cell(
    "Category", bold: true, height: 20pt, cell_align: left, use_under: true,
  ), cell(
    "Justification", bold: true, height: 20pt, cell_align: left, use_under: true,
  ), cell("", bold: true, height: 20pt, cell_align: left, use_under: true), cell("Interoperability", bold: true, cell_align: left), cell(
    [Not all base features of the GNOME control center work on other environments,
      and GNOME exclusive features cannot be hidden.], cell_align: left, bold: false, font_size: 11pt,
  ), cell("X", bold: true, cell_align: center), cell("Ease of Use", bold: true, cell_align: left), cell(
    [The user interface of the GNOME control center follows their own best
      practices.@gnome_human_guidelines It has consistent design, naming makes sense
      and accessibility is taken into account.], cell_align: left, bold: false, font_size: 11pt,
  ), cell("\u{2713}", bold: true, cell_align: left), cell("Maintainability", bold: true, cell_align: left), cell(
    [All features of the Gnome control center are within one repository, which
      results in one project maintaining every feature. This can potentially cause
      complications with increasing size.], cell_align: left, bold: false, font_size: 11pt,
  ), cell("(\u{2713})", bold: true, cell_align: center),
)

#subsubsection("KDE System Settings")
KDE systemsettings@kde_systemsettings_repo is written in C++/QML and is made
with the QT toolkit@qt. It follows the KDE style of applications, featuring a
very large variety of settings (on KDE), and offering other applications a way
to integrate into this application via KConfig Module(KCM)@kcm.
#align(
  center, [#figure(
      img("kde_systemsettings.png", width: 80%), caption: [Appearance setting of KDE systemsettings],
    )],
)<kde_systemsettings>
The program is by default very slim and does not feature any standard settings
on the repository. However, Linux distributions usually ship the KDE standard
modules, as KDE is the intended environment for this application. For ReSet, KDE
systemsettings is still a very good resource for implementing modularity with
this type of application.

Settings are stored by individual modules, which means that a lot of individual
files will be written/read in order to provide all functionality.

In many cases, for KDE systemsettings it is not the application itself that makes
it harder to be used on other environments, but the toolkit and the KDE specific
styling of said toolkit that might not integrate well.

#pagebreak()

#grid(
  columns: (auto), rows: (20pt), cell(
    [#figure([], kind: table, caption: [KDE Systemsettings Requirement Fulfillment])<kderequirements>], bold: true,
  ),
)
#grid(
  columns: (3fr, 9fr, 30pt), rows: (25pt, 110pt, 70pt, 75pt), gutter: 0pt, cell("Category", bold: true, use_under: true, cell_align: left), cell("Justification", bold: true, use_under: true, cell_align: left), cell("", bold: true, use_under: true), cell("Interoperability", bold: true, cell_align: left), cell(
    [KDE systemsettings is built with modularity in mind, meaning it works purely
      with modules that can be built for it. This means that one could create modules
      for systemsettings to enable functionality in other environments. However, QT is
      not as well integrated into other environments as GTK, requiring users to
      potentially change themes for a consistent design. Additionally, the needed
      modules do not exist as of now.], cell_align: left, bold: false, font_size: 11pt,
  ), cell("(\u{2713})", bold: true, cell_align: center), cell("Ease of Use", bold: true, cell_align: left), cell(
    [The most common criticism of KDE systemsettings is a convoluted design. This
      stems from the sheer amount of settings the application can provide, alongside
      its heavy use of submenus that can become confusing when searching for something
      specific.], cell_align: left, bold: false, font_size: 11pt,
  ), cell("X", bold: true, cell_align: center), cell("Maintainability", bold: true, cell_align: left), cell(
    [The modular design of KDE systemsettings allows for great maintainability on the
      application itself. It is however noteworthy that the configuration files
      created by KCM tend to fill folders with seemingly random files. This means that
      changing settings outside KDE systemsettings can be a challenge.], cell_align: left, bold: false, font_size: 11pt,
  ), cell("\u{2713}", bold: true, cell_align: center),
)

#pagebreak()

#subsubsection("Standalone Settings")
These applications focus on one specific functionality and do not offer anything
else. This means one would need to use multiple of these, in order to replicate
what the other 2 discussed programs offer.

Interoperability will not be considered for these applications, as they were
made for a universal use case.

*Pavucontrol* | Sound Application\
Pavucontrol@pavucontrol_repo or PulseAudio Volume Control is an application that
handles both system-wide input/output, per application output and input streams.
It is under the umbrella of the Free Desktop project and is directly involved in
PulseAudio itself. The application itself is written in C++ and GTK3.
#align(
  center, [#figure(
      img("pavucontrol.png", width: 80%), caption: [Output devices of pavucontrol],
    )],
)<pavucontrol>

\

#grid(
  columns: (auto), rows: (20pt), cell(
    [#figure([], kind: table, caption: [Pavucontrol Requirement Fulfillment])<pavurequirements>], bold: true,
  ),
)
#grid(
  columns: (3fr, 9fr, 30pt), rows: (25pt, 55pt, 55pt), gutter: 0pt, cell("Category", bold: true, cell_align: left, use_under: true), cell("Justification", bold: true, cell_align: left, use_under: true), cell("", bold: true, cell_align: left, use_under: true), cell("Ease of Use", bold: true, cell_align: left), cell(
    [While pavucontrol is generally made for more advanced users, it does offer a
      consistent design with appropriate icons/naming and integrates well into all
      environments.], cell_align: left, bold: false, font_size: 11pt,
  ), cell("\u{2713}", bold: true, cell_align: center), cell("Maintainability", bold: true, cell_align: left), cell(
    [Pavucontrol is made with a modular codebase, which allows for easier adding of
      features.\
      Note: pavucontrol is feature complete, and will likely not get more features in
      the future.], cell_align: left, bold: false, font_size: 11pt,
  ), cell("\u{2713}", bold: true, cell_align: center),
)

#pagebreak()

*Blueman* | Bluetooth Application\
Blueman@blueman_repo allows connecting and managing of Bluetooth connections, as
well as some quality-of-life features like file transfer. It works great in
functionality, but the buttons are not very expressive of what they will
achieve. Blueman is written in Python and GTK3.
#align(
  center, [#figure(
      img("bluetooth_manager_filled.png", width: 80%), caption: [Main window of blueman],
    )],
)<blueman>

\

#grid(
  columns: (auto), rows: (30pt), cell(
    [#figure([], kind: table, caption: [Bluetooth Manager Requirement Fulfillment])<bluetoothrequirements>], bold: true,
  ),
)
#grid(
  columns: (3fr, 9fr, 30pt), rows: (30pt, 65pt, 40pt), gutter: 0pt, cell("Category", bold: true, cell_align: left, use_under: true), cell("Justification", bold: true, cell_align: left, use_under: true), cell("", bold: true, cell_align: left, use_under: true), cell("Ease of Use", bold: true, cell_align: left), cell(
    [The user interface for Blueman can be rather confusing, for example: there is no
      obvious connect button, which might lead to a user trying to mark a device as
      trusted instead of connecting to it. (trusted is the \u{2713} button). Blueman
      also tends to use older icon designs.], cell_align: left, bold: false, font_size: 11pt,
  ), cell("X", bold: true, cell_align: center), cell("Maintainability", bold: true, cell_align: left), cell(
    [Blueman is created in a modular fashion and can be considered easily maintainable.], cell_align: left, bold: false, font_size: 11pt,
  ), cell("\u{2713}", bold: true, cell_align: center),
)

#pagebreak()

*Nmtui* | Network Application\
Nmtui@networkmanager_repo is what the name suggests, it is a terminal user
interface that allows users to use and edit network connections, including VPN
connections. Nmtui is located in the same project as the network manager itself 
and is therefore also shipped as part of the network manager package. Both 
network manager and nmtui are written in C. There is a specific lack of 
standalone user interface applications for network managers. Technically, 
the "network-manager-applet"@network_manager_applet by GNOME exists, however, 
this is to be included in a system tray within status bars and does not work on 
its own.
#align(
  center, [#figure(img("nmtui.png", width: 80%), caption: [Wi-Fi connections in nmtui])],
)<nmtui>

#grid(
  columns: (auto), rows: (30pt), cell(
    [#figure([], kind: table, caption: [Nmtui Requirement Fulfillment])<nmtuirequirements>], bold: true,
  ),
)
#grid(
  columns: (3fr, 9fr, 30pt), rows: (30pt, 80pt, 30pt), gutter: 0pt, cell("Category", bold: true, cell_align: left, use_under: true), cell("Justification", bold: true, cell_align: left, use_under: true), cell("", bold: true, cell_align: left, use_under: true), cell("Ease of Use", bold: true, cell_align: left), cell(
    [Resizing the terminal breaks the appearance of the application.\
      There is only a single theme.\
      Users unfamiliar to terminal user interfaces might be unable to use this
      application.\
      Mouse support is missing.], cell_align: left, bold: false, font_size: 11pt,
  ), cell("X", bold: true, cell_align: center), cell("Maintainability", bold: true, cell_align: left), cell(
    [The scope of this application is small and depends fully on the parent project,
      it can be considered to be maintainable.], cell_align: left, bold: false, font_size: 11pt,
  ), cell("\u{2713}", bold: true, cell_align: center),
)
