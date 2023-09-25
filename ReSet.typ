#import "template.typ": *

#show: doc => conf(
  author: "Fabio Lenherr / Felix Tran",
  "Dr. Prof. Frieder Loch",
  "ReSet",
  "figures/ReSet1.png",
  25%,
  "figures/OST.svg",
  40%,
  "Department for Computer Science",
  "OST Eastern Switzerland University of Applied Sciences",
  doc,
)

#section("Abstract")
whatver is discussed in @globi s
#pagebreak()

#section("Glossary")

#pagebreak()
#section("Motivation")
The Linux ecosystem is well known to be fractured, whether it's the seemingly
endless amount of distributions, or the various different desktop environments,
there will always be someone who will create something new.\
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
#subsection("Technologies")
#text(12pt, [*Programming Language*])* | ReSet is written in Rust.*\
Rust was chosen for its speed, low memory usage, memory safe design and robust
ecosystem.\
Wile Rust is more complex to write than languages such as JavaScript, it comes
with a significantly reduced memory cost and with the addition of a proper type
system.\
Compared to other system programming languages, Rust comes with a modern
ecosystem, providing a formatter, a compiler, an LSP server, a code checking
tool and a package manager in one package(rustup).\
This allows for a more streamlined developer experience and standardizes
features, which in return makes more complex tasks like cross-compilation a lot
easier.\
For example, Rust allows one to simply add a so-called "target triple", which is
a specific platform.\
Using this triple, it is possible to just build this with "```sh cargo build --target x86_64-linux-unknown-gnu```".\
In other words, it offers modern features while keeping the speed of C or C++.\

Another consideration for this language is the wide support for editors.\
With the provided language server, it is possible to use Rust in pretty much any
extendable editor.\
Alongside it, even big editors like the JetBrains tools now offer a Rust editor
(Rust Rover).

#pagebreak()
#text(12pt, [*UI Toolkit*])* | ReSet uses GTK4 as its UI toolkit.*\
GTK (Gnome toolkit, or formerly Gimp Toolkit) is a well established UI toolkit
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
#subsection("Parallels to similar projects")

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
Because we do not follow the Waterfall methodology, time management further 
than around 2 weeks is not very accurate. For now, we use placeholders in the 
Architecture task, but once we get to it, we will expand the diagram accordingly.
#align(center, [#figure(image("figures/ganntTimePlanning.png", width: 100%),caption: [Time management],)])
#subsection("Risks")
#requirement("socket or something", "socket no breaky", "low", "socket breaky", [
  - use rust
  - don't use js
  - idk
])
#subsection("Domain Model")
#subsection("Architecture")
#subsection("UI Design")
On the left side, there's a scrollabe window containing a list of settings 
categories. 
Above that is a search bar that allows users to quickly locate specific settings. 
In addition to the search bar, there is a breadcrumb menu similar to file paths 
which can be especially useful when users need to traverse multiple screens or 
submenus, ensuring they can easily backtrack.
#align(center, [#figure(image("figures/uimock.png", width: 90%),caption: [First iteration of UI mock],)<uimock>])
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

#align(
  center,
  [#figure(
      [#sourcecode[```rs
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
                                                  ```]
        #image("figures/rustdoc.png", width: 100%)],
      caption: [Rustdoc example entry for code above.],
    )<rustdoc>],
)

#pagebreak()

#section("Retrospective")
#pagebreak()

#section("Time Report")
#subsection("Sprint 1: Initial Project Planning")
In this sprint, our goals were building a foundation to work on. This includes tasks such as creating repositories for our code base and documentation, setting up time tracking and doing initial research on our topic. Most of our time in this sprint has been used to write the documentation.
#align(center, [#figure(image("figures/timeReport_01.png", width: 100%),caption: [Time distribution of Sprint 1],)])
#pagebreak()
