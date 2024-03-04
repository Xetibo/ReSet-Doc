#import "../templates/utils.typ": *
#lsp_placate()

#section("Prelude")
This section covers the required concepts for a plugin system.

#subsection("Mangling")
Mangling is the act of renaming designators by the compiler. Mangling can have
different strategies and reasons. For example, a compiler for languages
such as C++, C and Rust use mangling in order to remove namespaces and
conflicts. Consider the Rust code in @rust_namespaces:

//typstfmt::off
#align(left, [#figure(sourcecode(```rs
pub mod namespace1;
pub mod namespace2;

fn main() {
    let _res1 = namespace1::add(5, 2);
    let _res2 = namespace2::add(5, 2);
    // these get flattened to add and subtract
}

// in namespace1.rs
pub fn add(left: i32, right: i32) -> i32 {
    left + right
}

// in namespace2.rs
pub fn add(left: i32, right: i32) -> i32 {
    left + right
}
```),
kind: "code",
supplement: "Listing",
caption: [Namespaces in Rust])<rust_namespaces>])
//typstfmt::on

This code will be reduced to one namespace during compilation, this means the
concept of "namespace1" or "namespace2" is lost. Without mangling, this would
not work, as both functions have the same name, however, with mangling, functions
will have a seemingly random name and will therefore not clash with each other.

In @assembly_mangling, the difference between regular compilation with mangling
and compilation with the annotation #[no_mangle] is visualized.

//typstfmt::off
#align(left, [#figure(sourcecode(```yasm
; mangled add function
.section .text._ZN4main4main17h51f2041274cfd0bdE,"ax",@progbits

; function without mangle
.section .text.add,"ax",@progbits
```),
kind: "code",
supplement: "Listing",
caption: [Mangling in assembly])<assembly_mangling>])
//typstfmt::on

This approach worked fine with one add function, however trying to achieve the
same with both functions will result in the compiler error visualized in
@mangling_error.

#align(
  center, [#figure(
      img("mangle_error.png", width: 60%, extension: "figures"), caption: [Mangle Error example],
    )<mangling_error>],
)

#subsubsection("Other Applications")
Mangling has other applications than just avoiding compilation issues, one of
these is code obfuscation. This is often used for languages that can't be
reduced to binary files, with an example of this being the obfuscation of
electron JavaScript applications.

JavaScript is an interpreted language, meaning that the code needs to be read by
an interpreter, this disallows the compilation to binary form and requires it to
stay as code. If the source code of this application should still be hidden from
the public, then developers will have to change the code to be intentionally as
unreadable as possible. This obfuscation is often done with existing tools such
as javascript-obfuscator @javascript_obfuscator.

In @obfuscated_code, an example obfuscation of JavaScript code is visualized.

//typstfmt::off
#align(left, [#figure(sourcecode(```js
// unobfuscated code
function penguin() {
  console.log("I like penguins.");
}
penguin();

// obfuscated code
(function(_0x29b584,_0x52a642){var _0x2430f6=_0x4396,_0x5aaa83=_0x29b584();
while(!![]){try{var _0xeb9c7d=-parseInt(_0x2430f6(0x88))/0x1*(parseInt(_0x2430f6(0x8d))/0x2)
// multiple lines of unreadable code omitted
penguin();
```),
kind: "code",
supplement: "Listing",
caption: [Example obfuscated code])<obfuscated_code>])
//typstfmt::on

#subsection("Dynamic Libraries")
Dynamic libraries are an interpretation of a binary that can be loaded into
memory and accessed at runtime by another binary. This means that developers can
provide libraries that can be loaded into a program at runtime.

Due to the read-only nature of dynamic libraries, it is possible to use the same
instance of a dynamic library for multiple programs. In other words, the library
is loaded into memory and then accessed by multiple processes. This benefit can
also be used within ReSet with the multiprocess paradigm via DBus.

#subsubsection("Versioning")
In order for dynamic libraries to be sharable, they need to be compatible with
each program using the library. Depending on the system that loads the library,
different tactics are used in order to load dynamic libraries. Under Linux, the
loading behavior depends on the installation variant. System native
installations will always share one instance of a specific library, there may
not be any other version of this specific library. This approach ensures maximum
re-usage of resources and keeps the footprint low. However, at the same, it
requires that all applications installed on this system must be compatible with
this version of the library. Simple versioning such as incrementing the version
number for each small change would make this system infeasible. For example,
simple bug fixes would break compatibility. In order to solve this issue,
semantic versioning is used. This system creates several guarantees for a
library by using multiple different version numbers.

In @semantic_versioning the semantic version of the library Glibc is visualized.

//typstfmt::off
#align(left, [#figure(sourcecode(```sh
# name of library, change would mean different library!
/usr/lib/libglib-2.0.so
# major number, incompatible change
/usr/lib/libglib-2.0.so.0
# minor numbers, compatible change
/usr/lib/libglib-2.0.so.0.7800.4 ```,
),
kind: "code",
supplement: "Listing",
caption: [Semantic versioning],)<semantic_versioning>],)
//typstfmt::on

The minor version of a shared library can have multiple numbers, usually, it will
be two or three. For two, there is no difference between compatible feature
enhancements and compatible bug fixes. With three numbers, the first number is a
compatible feature enhancement, and the last number is a compatible bugfix.

For the Linux system native packages, this ensures the feasibility of a single
shared library, even if the version might be different from the expected one.

For ReSet, flatpak is used as well, this system also tries to re-use libraries
if possible, however, due to the sandboxed nature of flatpaks, it is also
possible to install multiple versions of a specific library, ensuring that each 
program receives the necessary library.

#subsubsection("Virtual Memory and Global Offset Table")
Operating systems do not offer processes direct access to physical memory.
This ensures that processes do not access random memory that is used by other processes.
Virtual memory address mapping enforces this paradigm by creating a pointer map to physical memory.
On this map, the operating system can control the allowed memory space of the application with the Memory Management Unit.
Should the process try to access physical memory which is not offered to this process,
then the Memory Management Unit will cause an MMU fault signal.

When loading a potential shared library plugin for ReSet,
this would result in two virtual address mappings,
one for the ReSet user interface and one for the daemon.
@virtual_to_physical visualized both mappings.

#figure(
    img("virtual_memory.png", width: 80%, extension: "figures"), caption: [Virtual to physical memory mapping],
)<virtual_to_physical>

Loading a shared library can either be done immediately,
meaning all functions of a library are loaded on startup,
or the library functionality can be loaded lazily.
Lazy functions will only be loaded into memory when they are called.
This can be achieved with the global offset table.

The global offset table stores pointers to loaded libraries which will redirect to the library functions.
If the function is not yet loaded, then the global offset will load the function into memory first.

In @global_offset_table an example function call with the global offset table is visualized.
The function to be called will provide an output parameter which will be set by the library function.
This means that the library needs a way to also access memory from the executable, which requires two-way access.

#figure(
    img("global_offset_table.svg", width: 80%, extension: "files"), caption: [Global offset table usage example],
)<global_offset_table>

#subsection("ABI")
Plugin systems based on dynamic libraries require that the plugins themselves
are built against the current version of the ABI.
For each specific change to ReSet and its respective daemon, the ABI might be changed as well.

Compared to an interpreted language, this is different from the fact that an API-compatible change is not necessarily ABI-compatible. For example, changing a
parameter from i64 to i32 would not require a change for the programmer using
the API. However, for the ABI user, this change would likely result in a crash
as the compiled ABI changed.

Changes to function signatures which add or remove parameters or change the
return type to a non-automatic cast would break API as well, meaning plugins
based on an interpreted system would also need to be rewritten.

#subsubsection("Exhibit ABI Compatibility")
Due to ABI instability and specific interpretation of memory,
it is often difficult if not impossible to provide interaction between languages if not used on a stable ABI such as the C language.
In this section, an example of C++ to Rust compatibility is analyzed based on the Hyprland plugin system. @hyprland
A working proof of concept plugin without functionality can be examined in @hyprland_plugin_rust.
Hyprland offers plugins via the C++ ABI, meaning no compatibility with any other language is offered out of the box.

#pagebreak()
Consider the C++ struct in @cpp_struct.
#figure(sourcecode(```cpp
typedef struct {
    std::string name;
    std::string description;
    std::string author;
    std::string version;
} PLUGIN_DESCRIPTION_INFO;
```),
kind: "code",
supplement: "Listing",
caption: [C++ struct]
)<cpp_struct>

Despite both Rust and C++ offering the same datatype, they are not properly compatible.
A single Rust String to C++ std::string is transferrable over a shared library,
however, a struct containing multiple strings is not converted properly and results in a double free,
meaning memory is attempted to be freed twice by C++.

In order for this struct to be consistently compatible,
it would need to be rewritten to use the C ABI,
which can be seen in @C_compatible_cpp.

#figure(sourcecode(```cpp
extern "C" typedef struct {
    char* name;
    char* description;
    char* author;
    char* version;
} PLUGIN_DESCRIPTION_INFO;
```),
kind: "code",
supplement: "Listing",
caption: [C ABI compatible struct in C++]
)<C_compatible_cpp>

The same struct can then be configured in other languages as well,
in @C_compatible_rust the Rust equivalent is visualized.

#figure(sourcecode(```rs
#[repr(C)]
struct PLUGIN_DESCRIPTION_INFO {
  name: *mut libc::c_char,
  description: *mut libc::c_char,
  author: *mut libc::c_char,
  version: *mut libc::c_char,
}
```),
kind: "code",
supplement: "Listing",
caption: [C ABI compatible struct in Rust]
)<C_compatible_rust>

#pagebreak()

#subsubsection("Hourglass pattern")
Using the hourglass pattern it is possible to provide a generalized ABI for which any language can be used to interact with a shared library-based plugin system.
In order to achieve this goal, the application implementing the plugin system needs to provide the entire API as a C API. This API can then be targeted by other languages without knowing the implementation details.
For proprietary applications, this is specifically interesting, since they do not need to provide any other code apart from the C header file.

In @hourglass and @hourglass_picture the architecture of the hourglass pattern is visualized.

#columns(2,[
  #figure(
      img("hourglass.svg", width: 100%, extension: "files"), caption: [Hourglass architecture],
    )<hourglass>
    #colbreak()
  #figure(
      img("hourglass.png", width: 80%, extension: "figures"), caption: [Hourglass visualization],
    )<hourglass_picture>
])

A potential shared library plugin system for ReSet could also implement
this C API in order to provide users of ReSet the possibility to use languages other than Rust.
However, it is important to note that this would also mean including C bindings to DBus and GTK,
which could increase the difficulty.

#subsection("Macros")
Macros are a way to change the code at compile time.
In languages like C or C++, this is often used in order to differentiate different environments,
prohibit duplicate imports or define constants.
Rust macros are inherently different from this.
Rust offers a macro system where the entire language is supported at compile time.
While this does increase the overall complexity of the system,
it also results in a system that does not result in simple text replacement.
In C, all that macros do is replace text, in Rust, the macros will manipulate tokens instead,
this guarantees that invalid tokens are prohibited, and operator precedence is not invalidated.

The book "The Rust Programming Language" offers a valuable example for operator precedence, and visualizes why C macros are often avoided.
Consider the excerpt in @cmacro taken from the book.

#align(left, [#figure(sourcecode(```C
#define FIVE_TIMES(x) 5 * x

int main() {
    printf("%d\n", FIVE_TIMES(2 + 3));
    return 0;
}
```),
kind: "code",
supplement: "Listing",
caption: [C Macro])<cmacro>])

If this was a regular function in C, then the expectation would be 25 as the result, 5 \* (2 + 3).
However, with C macros, the token x is not used as an actual token,
instead, it is just text, so the result is: 5 \* 2 + 3.
Without the parenthesis, the expectation of the result changes from 25 to 13.
Bugs like these are incredibly hard to debug as they happen at compile time.

For comparison, the same macro in Rust in @rustmacro results in the expected 25.

#align(left, [#figure(sourcecode(```rs
macro_rules! five_times {
    ($x:expr) => (5 * $x);
}

fn main() {
    assert_eq!(25, five_times!(2 + 3));
}
```),
kind: "code",
supplement: "Listing",
caption: [Rust Macro])<rustmacro>])

With the Rust version, it is clear that x is not just text, but an expression,
which will be evaluated in full before entering it into the macro.
In other words, the entire expression is multiplied by five, not just the first part of it.

A different approach to Rust would be to offer a flag to use code at compile time.
This approach is used within C++ by adding constexpr or consteval to code.
The difference between constexpr and consteval is the enforcement of compile time.
If the code cannot be run at compile time, constexpr will not generate an error and instead run the code regularly,
consteval would cause a compile time error in this case.

In @consteval the same functionality is visualized in C++.

#align(left, [#figure(sourcecode(```cpp
auto consteval five_times(int x) -> int { return 5 * x; }
int main() { std::cout << five_times(2 + 3) << std::endl; }
```),
kind: "code",
supplement: "Listing",
caption: [C++ Consteval])<consteval>])


// TODO: Why are these important?
// TODO: How to they interact with plugins
