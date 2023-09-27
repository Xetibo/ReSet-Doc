#import "../templates/utils.typ": *
#lsp_placate()

#let language_weights = (
  familiarity: 0.4,
  developer_experience: 0.3,
  ecosystem: 0.7,
  runtime_speed: 0.2,
  resource_usage: 0.5,
  development_speed: 0.4,
)
#let toolkit_weights = (
  familiarity: 0.3,
  language_integration: 0.5,
  documentation: 0.7,
  features: 0.3,
)

#subsection("Technologies")
Technologies are evaluated using a value table, which defines a score between 0
and 10 for each category over each tool. Each category is also given a constant
weight(0 to 1), in order to evaluate which tool will be chosen.

The following categories are evaluated for programming languages:
- familiarity | weight: 0.4\
  Indicates how familiar the developers are with a certain tool. More familiarity
  means an easier development process without unexpected surprises.
- developer experience | weight: 0.3\
  This encompasses the entire development cycle, meaning toolchain, LSPs,
  formatters, code coverage tools and more. With a modern developer experience,
  you can guarantee functionality without prolonged setup phases.
- ecosystem | weight: 0.7\
  Ecosystem is defined as the amount and the quality of packages and libraries
  that are available to this tool. For ReSet, this can be a crucial category, as
  many different types of services are used, hence the need for good integration
  with them.\
  Important: The ecosystem is highly dependent on the Linux desktop, which is not
  always favorable for all tools, for example: .NET Maui, which is a very popular
  toolkit is not usable, as it does not run on the Linux desktop.
- runtime speed | weight: 0.2\
  Runtime speed is likely only a concern for the daemon, and even in this case, it
  is unlikely to be too slow with any modern programming language.
- resource usage | weight: 0.5\
  Many computers have enough RAM by now, however, ReSet intends to work on any
  distribution, including lightweight distributions meant for older or lower end
  systems, therefore RAM usage should be a concern, especially for the daemon.
- development speed | weight: 0.4\
  ReSet is limited in time scope, therefore tools with decent progress times
  should be considered. Note, this includes time needed for debugging and
  potential problems, such as undefined behavior or dynamic type issues.

The following categories are evaluated for UI toolkits:
- familiarity | weight: 0.3\
- Language Integration | weight: 0.5\
  This defines how well the chosen language will integrate with the UI toolkit, in
  other words, certain toolkits might get a zero score here, signifying
  incompatibility.
- Documentation | weight: 0.7\
  Defines how well the toolkit is documented. This will be important when going
  beyond the typical "Hello World" for UI programs. A good documented toolkit can
  reduce the development time by a lot.
- Features | weight: 0.3\
  ReSet does not need a many features, however, ReSet does require proper support
  for the platform in question.

//  familiarity: 0.3,
//  language_integration: 0.5,
//  documentation: 0.7,
//  features: 0.7,

#pagebreak()
#let python = (
  familiarity: 6,
  developer_experience: 7,
  ecosystem: 6,
  runtime_speed: 4,
  resource_usage: 4,
  development_speed: 10,
)
#let typescript = (
  familiarity: 6,
  developer_experience: 8,
  ecosystem: 5,
  runtime_speed: 4,
  resource_usage: 4,
  development_speed: 9,
)
#let csharp = (
  familiarity: 6,
  developer_experience: 6,
  ecosystem: 5,
  runtime_speed: 7,
  resource_usage: 6,
  development_speed: 8,
)
#let cpp = (
  familiarity: 6,
  developer_experience: 3,
  ecosystem: 10,
  runtime_speed: 10,
  resource_usage: 10,
  development_speed: 6,
)
#let rust = (
  familiarity: 6,
  developer_experience: 10,
  ecosystem: 9,
  runtime_speed: 9,
  resource_usage: 10,
  development_speed: 5,
)
#grid(
  columns: (auto),
  rows: (30pt),
  cell([Programming Languages], bold: true),
)
#pad(y: -13pt, [])
#grid(
  columns: (2.3fr, 1fr, 1.2fr, 1fr, 1fr, 1fr, 0.8fr),
  rows: (30pt, 30pt, 30pt, 30pt, 30pt, 30pt, 30pt),
  gutter: 0pt,
  cell("category", bold: true),
  cell("Python", bold: true),
  cell("TypeScript", bold: true),
  cell("C#", bold: true),
  cell("C++", bold: true),
  cell("Rust", bold: true),
  cell("weight", bold: true),
  cell("familiarity", bold: true),
  cell([#python.familiarity], bold: true),
  cell([#typescript.familiarity], bold: true),
  cell([#csharp.familiarity], bold: true),
  cell([#cpp.familiarity], bold: true),
  cell([#rust.familiarity], bold: true),
  cell([#language_weights.familiarity], bold: true),
  cell("developer experience", bold: true),
  cell([#python.developer_experience], bold: true),
  cell([#typescript.developer_experience], bold: true),
  cell([#csharp.developer_experience], bold: true),
  cell([#cpp.developer_experience], bold: true),
  cell([#rust.developer_experience], bold: true),
  cell([#language_weights.developer_experience], bold: true),
  cell("ecosystem", bold: true),
  cell([#python.ecosystem], bold: true),
  cell([#typescript.ecosystem], bold: true),
  cell([#csharp.ecosystem], bold: true),
  cell([#cpp.ecosystem], bold: true),
  cell([#rust.ecosystem], bold: true),
  cell([#language_weights.ecosystem], bold: true),
  cell("runtime speed", bold: true),
  cell([#python.runtime_speed], bold: true),
  cell([#typescript.runtime_speed], bold: true),
  cell([#csharp.runtime_speed], bold: true),
  cell([#cpp.runtime_speed], bold: true),
  cell([#rust.runtime_speed], bold: true),
  cell([#language_weights.runtime_speed], bold: true),
  cell("resource usage", bold: true),
  cell([#python.resource_usage], bold: true),
  cell([#typescript.resource_usage], bold: true),
  cell([#csharp.resource_usage], bold: true),
  cell([#cpp.resource_usage], bold: true),
  cell([#rust.resource_usage], bold: true),
  cell([#language_weights.resource_usage], bold: true),
  cell("development speed", bold: true),
  cell([#python.development_speed], bold: true),
  cell([#typescript.development_speed], bold: true),
  cell([#csharp.development_speed], bold: true),
  cell([#cpp.development_speed], bold: true),
  cell([#rust.development_speed], bold: true),
  cell([#language_weights.development_speed], bold: true),
  cell("Total", bold: true),
  cell([#calculate_total(python, language_weights)], bold: true),
  cell([#calculate_total(typescript, language_weights)], bold: true),
  cell([#calculate_total(csharp, language_weights)], bold: true),
  cell([#calculate_total(cpp, language_weights)], bold: true),
  cell([#calculate_total(rust, language_weights)], bold: true, color: green),
  cell(" ", bold: true),
)

#text(12pt, [*Programming Language*])* | ReSet is written in Rust.*\
Rust was chosen for its speed, low memory usage, memory safe design and robust
ecosystem.\
While Rust is more complex to write than languages such as JavaScript, it comes
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

UI Considerations for Rust are also a big factor, on Linux there are generally 2
big user interface toolkits, GTK and QT. QT is generally used with C++, while
GTK is often used with C or a special GTK developed language called "Vala".
However, for GTK the Rust bindings are above average in quality, compared to
other language bindings, meaning it provides a close to native experience, while
still offering all the benefits of a more modern language.

#pagebreak()

#let gtk = (familiarity: 6, language_integration: 7, documentation: 6, features: 6)
#let iced = (
  familiarity: 4,
  language_integration: 10,
  documentation: 3,
  features: 4,
)
#let qt = (familiarity: 2, language_integration: 6, documentation: 6, features: 7)
#grid(columns: (auto), rows: (30pt), cell([UI Toolkits], bold: true))
#pad(y: -13pt, [])
#grid(
  columns: (2.3fr, 1fr, 1fr, 1fr, 0.8fr),
  rows: (30pt, 30pt, 30pt, 30pt, 30pt),
  gutter: 0pt,
  cell("category", bold: true),
  cell("GTK", bold: true),
  cell("Iced", bold: true),
  cell("QT", bold: true),
  cell("weight", bold: true),
  cell("familiarity", bold: true),
  cell([#gtk.familiarity], bold: true),
  cell([#iced.familiarity], bold: true),
  cell([#qt.familiarity], bold: true),
  cell([#toolkit_weights.familiarity], bold: true),
  cell("Language Integration", bold: true),
  cell([#gtk.language_integration], bold: true),
  cell([#iced.language_integration], bold: true),
  cell([#qt.language_integration], bold: true),
  cell([#toolkit_weights.language_integration], bold: true),
  cell("Documentation", bold: true),
  cell([#gtk.documentation], bold: true),
  cell([#iced.documentation], bold: true),
  cell([#qt.documentation], bold: true),
  cell([#toolkit_weights.documentation], bold: true),
  cell("Features", bold: true),
  cell([#gtk.features], bold: true),
  cell([#iced.features], bold: true),
  cell([#qt.features], bold: true),
  cell([#toolkit_weights.features], bold: true),
  cell("Total", bold: true),
  cell([#calculate_total(gtk, toolkit_weights)], bold: true, color: green),
  cell([#calculate_total(iced, toolkit_weights)], bold: true),
  cell([#calculate_total(qt, toolkit_weights)], bold: true),
  cell(" ", bold: true),
)

#text(12pt, [*UI Toolkit*])* | ReSet uses GTK4 as its UI toolkit.*\
GTK (Gnome [@gnome] toolkit, or formerly Gimp Toolkit) is a well established UI
toolkit under Linux that has seen decades of usage and improvements. While the
library itself is written in C, it does offer stable language bindings for a
large set of languages, including Rust via #link("https://gtk-rs.org/")[gtk-rs].
Compared to native Rust libraries, it offers a more robust set of defined
widgets, themes and tools. Specifically the toolkit "iced" was considered,
however, it currently lacks documentation and needs several library
implementations in order to fit with our requirements.

The last consideration is QT, it is a cross-platform toolkit that uses its own
form of JavaScript(QML) to draw windows. QT is a well known toolkit, however, it
is completely unknown to us, making it a suboptimal choice.\
For QT, there is also the consideration with integration mentioned in @ExistingProjects.

#text(12pt, [*Typesetting Language*])* | ReSet-Doc is written with typst.*\
Typst is a modern typesetting system with clean and modern syntax. It offers
faster compilation compared to latex and does not produce additional files
needed for compilation. In Addition, typst already has a modern ecosystem,
allowing users to install typst in a single binary, and immediately start using
it. For example, Visual Studio Code has an extension that covers everything you
need. (Other editors such as Neovim also have an extension/plugin for typst)

It is important to note, that typst is a Turing complete system and not a markup
language, which was specifically avoided, in order to not run into limitations.
