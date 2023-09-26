#import "../templates/utils.typ": *
#show_glossary()

#subsection("Technologies")
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

#text(12pt, [*UI Toolkit*])* | ReSet uses GTK4 as its UI toolkit.*\
GTK (Gnome [@gnome] toolkit, or formerly Gimp Toolkit) is a well established UI
toolkit under Linux that has seen decades of usage and improvements.\
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
