#import "templates/template.typ": *
#import "templates/riskmatrix.typ": *

#let abstract = { [ This is an abstract ] }
#let acknowledgements = { [ This is acknowledgements ] }

#show: doc => conf(
  author: "Fabio Lenherr / Felix Tran",
  "Dr. Prof. Frieder Loch",
  "ReSet",
  "/figures/ReSet1.png",
  25%,
  "/figures/OST.svg",
  40%,
  "Department for Computer Science",
  "OST Eastern Switzerland University of Applied Sciences",
  abstract,
  acknowledgements,
  doc,
)

#section("Glossary")
#pad(y: 10pt)[]
#glossary_entry(
  "Daemon",
  [
    Background process, most commonly used to handle functionality for a frontend.
  ],
  "Daemon",
)
#glossary_entry(
  "Desktop Environment",
  [
    A collection of software, enabling a graphical user interface experience to do
    general computing tasks.\
    This includes most basic functionality like starting programs, shutting down the
    PC or similar.
  ],
  "DE",
)
#glossary_entry(
  "Language Server Protocol (LSP)",
  [
    Protocol designed to help program software by providing quick-fixes to errors,
    linting, formatting and refactoring.
  ],
  "LSP",
)
#glossary_entry("Target Triple", [
  String used to define compilation target platforms in rust.
], "triple")
#glossary_entry(
  "dbus",
  [
    Low level API providing inter process communication (IPC) on UNIX operating
    systems.
  ],
  "dbus",
)
#glossary_entry(
  "Wayland",
  [
    The current display protocol used on Linux.\
    It replaces the previous X11 protocol, which is no longer in development. (it is
    still maintained for security reasons)
  ],
  "wayland",
)
#glossary_entry(
  "Gnome",
  [
    A Linux desktop environment. 
  ],
  "gnome",
)
#glossary_entry(
  "KDesktop Environment (KDE)",
  [
    A Linux desktop environment.\
    The K has no particular meaning.
  ],
  "kde",
)
#pagebreak()
#section("Motivation")
The Linux ecosystem is well known to be fractured, whether it's the seemingly
endless amount of distributions, or the various different desktop
environments[@DE] there will always be someone who will create something new.\
With this reality comes a challenge to create software that is not dependent on
one singular distribution or environment.\
This project will focus on one specific problem, namely the lack of universality
when interacting with configuration tools.\
Whenever a user would like to connect to a network, they have to do this with
their environment specific tool, should that environment simply not provide one,
then they will have to find one specifically for this task.\
ReSet will make the effort to change this situation by providing a settings
application that works across these distributions and environments, therefore
eliminating the need to install one tool for each task.\
While the UNIX philosophy considers one tool for each task to be the proper
solution, ReSet would argue that this is not the case with a tool featuring user
interfaces, here instead it would lead to unnecessary screen space being used
for no reason.

// no universal app
#subsection("Solution")
ReSet will be a set of 2 applications featuring one user interface application
that will have common settings available for the user.\
The second part of ReSet will be a daemon, which will be used to interact with
necessary services, such as audio servers, configuration files and more.\
This configuration also allows us to deliver an API, with which other
applications can interact with the daemon, this means that ReSet can be used
with applets, status bars and more, which are common in the Linux ecosystem.\
In order to respect accessibility and the requirements of a Linux application,
ReSet will also provide a command line version to interact with the
Reset-Daemon.
// universal app with daemon
#pagebreak()
#subsection("Technologies")
#text(12pt, [*Programming Language*])* | ReSet is written in Rust.*\
Rust was chosen for its speed, low memory usage, memory safe design and robust
ecosystem.\
Wile Rust is more complex to write than languages such as JavaScript, it comes
with a significantly reduced memory cost and with the addition of a proper type
system.\
Compared to other system programming languages, Rust comes with a modern
ecosystem, providing a formatter, a compiler, an LSP[@LSP] server, a code
checking tool and a package manager in one package(rustup).\
This allows for a more streamlined developer experience and standardizes
features, which in return makes more complex tasks like cross-compilation a lot
easier.\
For example, Rust allows one to simply add a so-called "target triple"[@triple],
which is a specific platform.\
Using this triple, it is possible to just build this with "```sh cargo build --target x86_64-linux-unknown-gnu```".\
In other words, it offers modern features while keeping the speed of C or C++.\

Another consideration for this language is the wide support for editors.\
With the provided language server, it is possible to use Rust in pretty much any
extendable editor.\
Alongside it, even big editors like the JetBrains tools now offer a Rust editor
(Rust Rover).

#text(12pt, [*UI Toolkit*])* | ReSet uses GTK4 as its UI toolkit.*\
GTK (Gnome [@gnome] toolkit, or formerly Gimp Toolkit) is a well established UI toolkit
under Linux that has seen decades of usage and improvements.\
While the library itself is written in C, it does offer language bindings for a
large set of languages, including Rust via #link("https://gtk-rs.org/")[gtk-rs].\
Compared to native Rust libraries, it offers a more robust set of defined
widgets, themes and tools.\
Specifically the toolkit "iced" was considered, however, it currently lacks
documentation and needs several library implementations in order to fit with our
requirements.

The last consideration is QT, it is a cross-platform toolkit that uses its own
form of JavaScript to draw windows.\
In this case it was a lack of familiarity with QT and a lack of semi-official
bindings for the toolkit that ended its consideration.

#text(12pt, [*Typesetting Language*])* | ReSet-Doc is written with typst.*\
Typst is a modern typesetting system with clean and modern syntax.\
It offers faster compilation compared to latex and does not produce additional
files needed for compilation.\
In Addition, typst already has a modern ecosystem, allowing users to install
typst in a single binary, and immediately start using it.\
For example, Visual Studio Code has an extension that covers everything you
need.\
(Other editors such as Neovim also have an extension/plugin for typst)

It is important to note, that typst is a Turing complete system and not a markup
language, which was specifically avoided, in order to not run into limitations.
#pagebreak()
#subsection("Parallels to similar projects")
#subsubsection("Gnome Control Settings")
The Gnome control center is as the name implies the central settings application
for the Gnome desktop environment, it offers plenty of configuration, from
networks, to Bluetooth, to online accounts, default application and a lot more.\
The application is written in C with the #link("https://www.gtk.org/")[GTK] toolkit
and follows the #link("https://developer.gnome.org/hig/")[Gnome Human Interface Guidelines].\
#align(center, [#figure(
    image("figures/gnome_control_center.png", width: 80%),
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
#pagebreak()

#subsubsection("KDE System Settings")
#link("https://invent.kde.org/plasma/systemsettings")[KDE [@kde] systemsettings] is
written in C++/QML and is made with the #link("https://www.qt.io/")[QT toolkit].\
It follows the KDE style of applications, featuring a very large variety of
settings (on KDE), and offering other applications a way to integrate into this
application via KConfig Module(KCM).\
#align(center, [#figure(
    image("figures/kde_systemsettings.png", width: 80%),
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

#pagebreak()
#subsubsection("Standalone Settings")
These applications focus on one specific functionality and don't offer anything
else.\
This means one would need to use multiple of these, in order to replicate what
the other 2 discussed programs offer.

*PavuControl* | Sound Application

*Bluetooth Manager* | Bluetooth Application

*nmtui* | Network Application

// how did others do it?
// how is this project going to differ?
// what will we improve on?
// gnome settings
// kde settings
// pavucontrol, network settings, bluetooth manager
#subsection("Insights from literature")
// lessons from UI design
// lessons for modularity -> this is a goal here
#pagebreak()

#section("Planning")
#subsection("Methods")
*Project Management* | ReSet is managed using Scrum.\
_Due to the small team size, no scrum master or product owner is chosen, the work
of these positions is done in collaboration._\

#subsection("Time")
Because we do not follow the Waterfall methodology, time management further than
around 2 weeks is not very accurate. For now, we use placeholders in the
Architecture task, but once we get to it, we will expand the diagram
accordingly.
#align(center, [#figure(
    image("figures/ganntTimePlanning.png", width: 100%),
    caption: [Time management],
  )])

#pagebreak()
#section("Risks")
Risks are assessed according to the ISO standard with a risk matrix.

#riskmatrix()

#risk(
  "Toolkit",
  [
    GTK might not be perfectly suitable for our use case, especially considering we
    are using Rust bindings and not C directly.
  ],
  "Medium",
  "Unlikely",
  "Critical",
  [
    Iced can be used as a backup toolkit if GTK turns out to not be usable for the
    project.
  ],
)
#risk(
  "Plugin System",
  [
    The plugin system might be too ambitious and could take too much time to
    realize.
  ],
  "High",
  "Likely",
  "Marginal",
  [
    Instead of a plugin system, dbus[@dbus] or socket connections can be used to
    realize a limited implementation of expected features.
  ],
)
#risk(
  "System Interaction",
  [
    System feature integration like audio, Bluetooth and more might not be as
    seamless as planned.
  ],
  "Low",
  "Rare",
  "Marginal",
  [
    Potential use of alternative integrations.\
    Example: The standard NetworkManager doesn't integrate well → use
    Systemd-networkd instead.
  ],
)
#pad(x: 0pt, y: 0pt, line(length: 100%))
#pagebreak()

#section("Requirements")
#subsection("Functional Requirements")
As per scrum, functional requirements are handled using the user story format
which can be found on the ReSet and ReSet-Daemon repositories respectively.

#subsection("Non-Functional Requirements")
#requirement(
  "User Interface",
  "Usability",
  "medium",
  [
    Reaction time should not be noticeable by user, and UI should not be blocked
    during loading operations.
  ],
  [
    - Show loading icons or similar during blocking operations.
      - restrict actions during loading period.
    - Use async functions in order to keep UI responsive. (GTK enforces this)
  ],
)
#requirement(
  "User Interface",
  "Usability",
  "medium",
  [
    Errors should be visible to the user, and the user should be able to solve
    issues accordingly.\
    Example: user has not installed any Bluetooth software, therefore ReSet should
    inform the user of the situation.
  ],
  [
    - Provide adequate error handling in user interface via popups or similar.
      - Same functionality should be available in CLI and API.
    - ReSet should not crash if a dependency is not installed.
  ],
)
#requirement("Code Duplication", "Maintainability", "low", [
  ReSet should not have the same logic implemented as ReSet-Daemon.\
  In general, ReSet should not have any logic other than necessary.
], [
  - Provide adequate functions over inter process connection
  - Well documented API
])
#pad(x: 0pt, y: 0pt, line(length: 100%))
#pagebreak()

#subsection("Domain Model")
#align(center, [#figure(
    image("files/domain_model.svg", width: 100%),
    caption: [Domain Model of ReSet],
  )<domain_model>])

#subsection("Architecture")

#pagebreak()
#subsection("UI Design")
On the left side, there's a scrollabe window containing a list of settings 
categories. 
Above that is a search bar that allows users to quickly locate specific settings. 
In addition to the search bar, there is a breadcrumb menu similar to file paths 
which can be especially useful when users need to traverse multiple screens or 
submenus, ensuring they can easily backtrack.
#align(center, [#figure(image("figures/wifimock.png", width: 90%),caption: [UI mock of WiFi setting],)<uimock>])
#align(center, [#figure(image("figures/monitormock.png", width: 90%),caption: [UI mock of monitor setting],)<uimock>])
#pagebreak()

#subsubsection("UI Tests")
#test("globi", "globi can connect to wifi", [
  - works
  - easy to see all connections
], [
  - no advanced configuration
  - can't be used with keyboard
], "some notes")

#section("Documentation")
Next to this document, both ReSet and ReSet-Daemon will have their code
documented using the rustdoc functionality.\
This allows inline documentation, which will later be converted to an HTML file.\
The API for ReSet-Daemon will be covered under TBD.

// typstfmt::off
#figure(
  [ #sourcecode(
      ```rs
      /// takes a number and multiplies it with itself x(positive) amount of times.
      /// ‘‘‘
      /// let num = fact(3,2);
      /// assert_eq!(9, numb);
      /// ‘‘‘
      fn pfact(number: i32, exponent: u32) -> i32 {
          if exponent == 0 {
              return 1;
          }
          if exponent == 1 {
              return number;
          }
          let mut result = number;
          for _ in 2..exponent {
              result = result * number;
          }
          result
      }
      ```,
    )
    #align(center, image("figures/rustdoc.png", width: 100%)) ],
  caption: [Rustdoc example entry for code above.],
)<rustdoc>
// typstfmt::on

#pagebreak()
#section("Retrospective")
#pagebreak()

#section("Time Report")
#subsection("Sprint 1: Initial Project Planning")
In this sprint, our goals were building a foundation to work on. This includes tasks such as creating repositories for our code base and documentation, setting up time tracking and doing initial research on our topic. Most of our time in this sprint has been used to write the documentation.
#align(center, [#figure(image("figures/timeReport_01.png", width: 100%),caption: [Time distribution of Sprint 1],)])
#pagebreak()
