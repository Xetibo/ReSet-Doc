#import "../templates/utils.typ": *
#lsp_placate()

#section("Prelude")
This section covers required concepts for a plugin system.

#subsection("Mangling")
Mangling is the act of renaming designators by the compiler. Mangling can have
various different strategies and reasons. For example, a compiler for languages
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
concept of "namespace1" or "namespace2" are lost. Without mangling, this would
not work, as both functions have the same name, however with mangling, functions
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
reduced to binary files, with an example for this being the obfuscation of
electron JavaScript applications.

JavaScript is an interpreted language, meaning that the code needs to be read by
an interpreter, this disallows the compilation to binary form and requires it to
stay as code. If the source code of this application should still be hidden from
the public, then developers will have to change the code to be intentionally as
unreadable as possible. This obfuscation is often done with existing tools such
as. // TODO

#subsection("Dynamic Libraries")
Dynamic libraries are an interpretation of a binary which can be loaded into
memory and accessed at runtime by another binary. This means that developers can
provide libraries which can be loaded into a program at runtime.

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
simple bugfixes would break compatibility. In order to solve this issue,
semantic versioning is used. This system creates a number of guarantees for a
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

The minor version of a shared library can have multiple numbers, usually it will
be two, or three. For two, there is no difference between compatible feature
enhancements and compatible bugfixes. With three numbers, the first number is a
compatible feature enhancement, and the last number is a compatible bugfix.

For the Linux system native packages, this ensures the feasibility of a single
shared library, even if the version might be different to the expected one.

For ReSet, flatpak is used as well, this system also tries to re-use libraries
if possible, however, due to the sandboxed nature of flatpaks, it is also
possible to install multiple versions of a specific library, ensuring that each
program receives the necessary library.

#subsubsection("Structure")

#subsubsection("Loading and Interaction")

