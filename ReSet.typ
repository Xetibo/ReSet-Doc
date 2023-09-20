#import "template.typ": *

#show: doc => conf(
  author: "Authors: Fabio Lenherr / Felix Tran",
  "Supervisor: Frieder Loch",
  "ReSet",
  doc,
)

#section("Abstract")
whatver is discussed in @globi s
#pagebreak()


#section("Motivation")
// no universal app
#subsection("Solution")
// universal app with daemon
#subsection("Technologies")
#text(12pt,[*Programming Language*])* | ReSet is written in rust.*\
Rust was chosen for its speed, low memory usage, memory safe design and robust ecosystem.\
Wile Rust is more complex to write than languages such as JavaScript, it comes with a significantly reduced memory cost and with the addition of a proper type system.\
Compared to other system programming languages, rust comes with a modern ecosystem, providing a formatter, a compiler, an LSP server, a code checking tool and a package manager in one package(rustup).\
This allows for a more streamlined developer experience and standardizes features, which in return makes more complex tasks like cross-compilation a lot easier.\
For example, rust allows one to simply add a so-called "target triple", which is a specific platform.\
Using this triple, it is possible to just build this with "```sh cargo build --target x86_64-linux-unknown-gnu```".\
In other words, it offers modern features while keeping the speed of C or C++.\

Another consideration for this language is the wide support for editors.\
With the provided language server, it is possible to use Rust in pretty much any extendable editor.\
Alongside it, even big editors like the JetBrain tools now offer a Rust editor(Rust Rover).

#text(12pt,[*UI Toolkit*])* | ReSet uses GTK4 as it's UI toolkit.*\
GTK(Gnome toolkit, or formerly Gimp Toolkit) is a well established UI toolkit under Linux that has seen decades of usage and improvements.\
While the library itself is written in C, it does offer language bindings for a large set of languages, including Rust via #link("https://gtk-rs.org/")[gtk-rs].\
Compared to native Rust libraries, it offers a more robust set of defined widgets, themes and tools.\
Specifically the toolkit "iced" was considered, however, it currently lacks documentation and needs several library implementations in order to fit with our requirements.

The last consideration is QT, it is a cross-platform toolkit that uses its own form of JavaScript to draw windows.\
In this case it was a lack of familiarity with QT and a lack of semi-official bindings for the toolkit that ended its consideration.
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
_Due to the small team size, no scrum master or product owner is chosen, the work of these positions is done in collaboration._\



#subsection("Time")
#subsection("Scope")
#subsection("Architecture")
#subsection("UI Design")
#pagebreak()

#section("Retrospective")
#pagebreak()

#section("Time Report")
#pagebreak()

