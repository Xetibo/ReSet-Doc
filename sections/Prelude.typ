#import "../templates/utils.typ": *
#lsp_placate()

#section("Prelude")
This section covers required concepts for a plugin system.

#subsection("Mangling")
Mangling is the act of renaming designators by the compiler. Mangling can have
various different strategies and reasons. For example, a compiler for languages
such as C++, C and Rust use mangling in order to remove namespaces and
conflicts. Consider the Rust code in/* TODO */:
```rs
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
```
This code will be reduced to one namespace during compilation, this means the
concept of "namespace1" or "namespace2" are lost. Without mangling, this would
not work, as both functions have the same name, however with mangling, functions
will have a seemingly random name and will therefore not clash with each other.

In/* TODO */, the difference between regular compilation with mangling and
compilation with the annotation #[no_mangle] is visualized.

// TODO
// the result of mangling the function is this:
// assembly code
// .section  .text._ZN4main4main17h51f2041274cfd0bdE,"ax",@progbits
```yasm
; mangled add function
.section  .text._ZN4main4main17h51f2041274cfd0bdE,"ax",@progbits

; function without mangle
.section  .text.add,"ax",@progbits
```

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

Dynamic libraries provide multiple benefits such as a smaller binary size,
re-usable libraries and independent updates.

The first two are intertwined, due to the fact that developers don't necessarily
ship needed libraries, the binary of an application is reduced in size, however
this does still require the library itself. In other words, if a library is only
used by a single application, it might slightly increase the storage usage,
however, due to the fact that applications can use the same library at the same
time, it will reduce the size of a binary overall.

#subsubsection("Structure")

#subsubsection("Loading and Interaction")

