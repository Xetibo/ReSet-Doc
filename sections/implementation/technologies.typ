#import "../../templates/utils.typ": *
#lsp_placate()

#let language_weights = (
  familiarity: 2,
  developer_experience: 1,
  ecosystem: 3,
  runtime_speed: 1,
  resource_usage: 2,
  development_speed: 2,
)
#let toolkit_weights = (familiarity: 1, language_integration: 2, documentation: 2, features: 1)

#subsection("Technologies")
Technologies are evaluated using a value table, which defines a score between 0
and 10 for each category over each tool. Each category is also given a constant
weight, in order to evaluate which tool will be chosen.\
The weights are as follows: low -> 1, medium -> 2, high -> 3

The following categories are evaluated for programming languages:
- *Familiarity* | weight: medium\
  Indicates how familiar the developers are with a certain tool. More familiarity
  means an easier development process without surprises. Note that
  familiarity is the subjective relative experience compared to other languages
  and does not indicate a particular level of skill.
- *Developer Experience* | weight: low\
  This encompasses the entire development cycle, meaning toolchain, LSPs,
  formatters, code coverage tools and more. With a modern developer experience,
  you can guarantee functionality without prolonged setup phases.
- *Ecosystem* | weight: high\
  Ecosystem is defined as the amount and the quality of packages and libraries
  that are available for this language. For ReSet, this can be a crucial category, as
  many different types of services are used, hence the need for good integration
  with them.\
  Important: The ecosystem is highly dependent on the Linux desktop, which is not
  always favorable for all tools, for example: .NET MAUI, a very popular user interface toolkit
  is not usable, as it does not run on the Linux desktop @maui_discussion.
- *Runtime speed* | weight: low\
  Runtime speed is likely only a concern for the daemon, and even in this case, it
  is unlikely to be too slow with any modern programming language.
- *Resource usage* | weight: medium\
  Many computers have enough RAM by now, however, ReSet intends to work on any
  distribution, including lightweight distributions meant for older or lower-end
  systems, therefore RAM usage should be a concern, especially for the daemon.
- *Development speed* | weight: medium\
  ReSet is limited in time scope, therefore tools with decent development speed
  should be considered. Note that this includes the time needed for debugging and
  potential problems, such as undefined behavior or dynamic type issues.

Special Requirement: All tools used in this project *must be published under an
open-source license*, as ReSet will be published under the GPL-3.0 license.

#pagebreak()
#let python = (
  familiarity: 8,
  developer_experience: 7,
  ecosystem: 6,
  runtime_speed: 5,
  resource_usage: 5,
  development_speed: 9,
)
#let typescript = (
  familiarity: 6,
  developer_experience: 9,
  ecosystem: 5,
  runtime_speed: 5,
  resource_usage: 5,
  development_speed: 9,
)
#let csharp = (
  familiarity: 7,
  developer_experience: 7,
  ecosystem: 5,
  runtime_speed: 8,
  resource_usage: 8,
  development_speed: 8,
)
#let cpp = (
  familiarity: 6,
  developer_experience: 3,
  ecosystem: 10,
  runtime_speed: 10,
  resource_usage: 10,
  development_speed: 5,
)
#let Rust = (
  familiarity: 6,
  developer_experience: 10,
  ecosystem: 9,
  runtime_speed: 10,
  resource_usage: 10,
  development_speed: 5,
)
#grid(
  columns: (auto),
  rows: (30pt),
  cell(
    [#figure([], kind: table, caption: [Programming Languages])<programminglanguages>],
    bold: true,
  ),
)
#pad(y: -13.1pt, [])
#grid(
  columns: (2.5fr, 1fr, 1.4fr, 1fr, 1fr, 1fr, 0.8fr),
  rows: (30pt, 30pt, 30pt, 30pt, 30pt, 30pt, 30pt),
  gutter: 0pt,
  cell("Category", bold: true, use_under: true, cell_align: left),
  cell("Python", bold: true, use_under: true),
  cell("TypeScript", bold: true, use_under: true),
  cell("C#", bold: true, use_under: true),
  cell("C++", bold: true, use_under: true),
  cell("Rust", bold: true, use_under: true),
  cell("Weight", bold: true, use_under: true),
  cell("Familiarity", bold: true, cell_align: left),
  cell([#python.familiarity], bold: true),
  cell([#typescript.familiarity], bold: true),
  cell([#csharp.familiarity], bold: true),
  cell([#cpp.familiarity], bold: true),
  cell([#Rust.familiarity], bold: true),
  cell([\*#language_weights.familiarity], bold: true),
  cell("Developer experience", bold: true, fill: silver, cell_align: left),
  cell([#python.developer_experience], bold: true, fill: silver),
  cell([#typescript.developer_experience], bold: true, fill: silver),
  cell([#csharp.developer_experience], bold: true, fill: silver),
  cell([#cpp.developer_experience], bold: true, fill: silver),
  cell([#Rust.developer_experience], bold: true, fill: silver),
  cell([\*#language_weights.developer_experience], bold: true, fill: silver),
  cell("Ecosystem", bold: true, cell_align: left),
  cell([#python.ecosystem], bold: true),
  cell([#typescript.ecosystem], bold: true),
  cell([#csharp.ecosystem], bold: true),
  cell([#cpp.ecosystem], bold: true),
  cell([#Rust.ecosystem], bold: true),
  cell([\*#language_weights.ecosystem], bold: true),
  cell("Runtime speed", bold: true, fill: silver, cell_align: left),
  cell([#python.runtime_speed], bold: true, fill: silver),
  cell([#typescript.runtime_speed], bold: true, fill: silver),
  cell([#csharp.runtime_speed], bold: true, fill: silver),
  cell([#cpp.runtime_speed], bold: true, fill: silver),
  cell([#Rust.runtime_speed], bold: true, fill: silver),
  cell([\*#language_weights.runtime_speed], bold: true, fill: silver),
  cell("Resource usage", bold: true, cell_align: left),
  cell([#python.resource_usage], bold: true),
  cell([#typescript.resource_usage], bold: true),
  cell([#csharp.resource_usage], bold: true),
  cell([#cpp.resource_usage], bold: true),
  cell([#Rust.resource_usage], bold: true),
  cell([\*#language_weights.resource_usage], bold: true),
  cell("Development speed", bold: true, fill: silver, cell_align: left),
  cell([#python.development_speed], bold: true, fill: silver),
  cell([#typescript.development_speed], bold: true, fill: silver),
  cell([#csharp.development_speed], bold: true, fill: silver),
  cell([#cpp.development_speed], bold: true, fill: silver),
  cell([#Rust.development_speed], bold: true, fill: silver),
  cell([\*#language_weights.development_speed], bold: true, fill: silver),
  cell("Total", bold: true, cell_align: left),
  cell([#calculate_total(python, language_weights)], bold: true),
  cell([#calculate_total(typescript, language_weights)], bold: true),
  cell([#calculate_total(csharp, language_weights)], bold: true),
  cell([#calculate_total(cpp, language_weights)], bold: true),
  cell([#calculate_total(Rust, language_weights)], bold: true, color: green),
  cell(" ", bold: true),
)

#text(12pt, [*Programming Language*])* | ReSet is written in Rust.*\
Rust was chosen for its speed, low memory usage, memory-safe design and robust
ecosystem. While Rust is more complex to write than languages such as
JavaScript, it comes with a significantly reduced memory cost and with the
addition of a static type system @Rust_javascript@Rust_javascript2@Rust_types.

Compared to other system programming languages, Rust comes with a modern
ecosystem out of the box, providing a formatter, a compiler, an LSP server,
a code-checking tool and a package manager in one (Rustup) @Rust_tools. This
allows for a more streamlined developer experience and standardizes features,
which in return makes more complex tasks like cross-compilation a lot easier.
For example, Rust allows adding a so-called "target triple",
which is a specific platform. Using this triple, it is possible to build the
project with "```sh cargo build --target x86_64-linux-unknown-gnu #or other platform```".
Similarly, adding packages is also just one command "```sh cargo add gtk```",
which is comparable to npm while still offering C/C++ runtime speed.

Another consideration for this language is the technology stack. For many other
languages, only a specific set of tools allows for a full IDE workflow, including
debugger, LSP and more. With Rust, this is not the case, as it either provides
said tool or uses a well-established open-source tool for each task. This
avoids cases like the official and proprietary C\#
debugger, which only works with
official Microsoft tools @csharp_debugger_notes @csharp_debugger_issue, or the C++ problem of having multiple compilers with different
feature sets. Hence, both languages described will have different experiences
on different platforms and editors/IDEs @cpp_compilers@Rust_compiler.

UI Considerations for Rust also play a big factor, on Linux there are generally 2
big user interface toolkits, GTK and QT. QT is generally used with C++, while
GTK is often used with C or a special GTK-developed language called "Vala" @vala.
However, for GTK the Rust bindings are above average in quality compared to
other language bindings, meaning it provides a close-to-native experience, while
still offering all the benefits of a more modern language @gtk_rs.

#pagebreak()

The following categories are evaluated for UI toolkits:
- *Familiarity* | weight: low\
  Indicates how familiar the developers are with a certain tool. More familiarity means an easier
  development process without surprises. Note that familiarity is the subjective relative experience
  compared to other toolkits and does not indicate a particular level of skill.
- *Language Integration* | weight: medium\
  This defines how well the chosen language will integrate with the UI toolkit, in
  other words, certain toolkits might get a zero score here, signifying
  incompatibility.
- *Documentation* | weight: medium\
  Defines how well the toolkit is documented. This will be important when going
  beyond the typical "Hello World" for UI programs. A well-documented toolkit can
  reduce the development time by magnitudes.
- *Features* | weight: low\
  ReSet does not need many features, however, ReSet does require first-class
  support for the Linux desktop.

#let gtk = (familiarity: 6, language_integration: 7, documentation: 8, features: 8)
#let iced = (
  familiarity: 4,
  language_integration: 10,
  documentation: 4,
  features: 6,
)
#let qt = (
  familiarity: 0,
  language_integration: 6,
  documentation: 8,
  features: 10,
)
#grid(columns: (auto), rows: (30pt), cell(
  [#figure([], kind: table, caption: [UI Toolkits])<uitoolkits>],
  bold: true,
))
#pad(y: -13pt, [])
#grid(
  columns: (1.6fr, 1fr, 1fr, 1fr, 0.8fr),
  rows: (30pt, 30pt, 30pt, 30pt, 30pt),
  gutter: 0pt,
  cell("Category", bold: true, use_under: true, cell_align: left),
  cell("GTK", bold: true, use_under: true),
  cell("Iced", bold: true, use_under: true),
  cell("QT", bold: true, use_under: true),
  cell("Weight", bold: true, use_under: true),
  cell("Familiarity", bold: true, cell_align: left),
  cell([#gtk.familiarity], bold: true),
  cell([#iced.familiarity], bold: true),
  cell([#qt.familiarity], bold: true),
  cell([\*#toolkit_weights.familiarity], bold: true),
  cell("Language Integration", bold: true, fill: silver, cell_align: left),
  cell([#gtk.language_integration], bold: true, fill: silver),
  cell([#iced.language_integration], bold: true, fill: silver),
  cell([#qt.language_integration], bold: true, fill: silver),
  cell([\*#toolkit_weights.language_integration], bold: true, fill: silver),
  cell("Documentation", bold: true, cell_align: left),
  cell([#gtk.documentation], bold: true),
  cell([#iced.documentation], bold: true),
  cell([#qt.documentation], bold: true),
  cell([\*#toolkit_weights.documentation], bold: true),
  cell("Features", bold: true, fill: silver, cell_align: left),
  cell([#gtk.features], bold: true, fill: silver),
  cell([#iced.features], bold: true, fill: silver),
  cell([#qt.features], bold: true, fill: silver),
  cell([\*#toolkit_weights.features], bold: true, fill: silver),
  cell("Total", bold: true, cell_align: left),
  cell([#calculate_total(gtk, toolkit_weights)], bold: true, color: green),
  cell([#calculate_total(iced, toolkit_weights)], bold: true),
  cell([#calculate_total(qt, toolkit_weights)], bold: true),
  cell(" ", bold: true),
)

#text(12pt, [*UI Toolkit*])* | ReSet uses GTK4 as its UI toolkit.*\
GTK (GNOME) toolkit, formerly Gimp Toolkit) is a well-established, LGPLv2.1+ licensed, cross-platform UI toolkit that has seen decades
of usage and improvements @gtk. While the library itself is written in C, it does
offer stable language bindings for a large set of languages, including Rust via gtk-rs @gtk_rs.
Compared to native Rust libraries, it offers a more robust set of defined
widgets, themes and tools. Specifically the toolkit "iced" was considered,
however, it currently lacks documentation and needs several library
implementations in order to fit with ReSet's requirements @iced.

The last consideration is QT, it is a cross-platform toolkit that uses its own
form of JavaScript (QML) to draw windows @qt @qml. QT is a well-known toolkit, however, it
is completely unknown to the project team members, making it a suboptimal choice.\
For QT, there is also the consideration of integration mentioned in
@Analysisofexistingapplications.
