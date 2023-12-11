#import "../templates/utils.typ": *
#lsp_placate()

#section("Conclusion")

#subsection("UI Design Result")
The final UI design has generally followed our intended vision. The UI is clean
and simple, and the user can easily navigate through the UI. It is also
responsive, which means that it will adjust itself depending on window sizes.

But there are some things that didn't make it into the final design. The first
one is the breadcrumb menu. It was decided that the breadcrumb menu is not
necessary because our UI isn't as nested as we thought initially. The depth of
our UI is only one level deep, which means that a breadcrumb bar would be
redundant. If we ever reach a point where we have a deeply nested UI, we will
reconsider adding a breadcrumb menu. The other one is shortcuts. While there are
some built-in shortcuts provided by GTK, we didn't add any of our own. This is
because we didn't have enough time to implement them, but we will add them in
the future.

#subsection("Improvements")
This section covers both the not yet implemented features of ReSet as well as
potential improvements to this project.

#subsubsection("Not Implemented Features")

#subsubsubsection("Plugin System")
Due to time constraints, this project will not cover a plugin system. However,
with the implementation currently provided, it should be possible to implement
this without major issues. For example, the current DBus daemon allows for a
trivial addition of an additional API and its own namespace.

#figure(sourcecode(```rs
// Example API addition
TODO
```), caption: [Example API addition])<api_addition>

#subsubsubsection("Persistent Settings")
Due to a lack of settings in general as of now, ReSet does not offer persistent
settings storage, although the base code for this features is implemented.

#subsubsubsection("Customizable Shortcuts")
A common feature for many power users, especially on linux is the heavy use of
keyboard shortcuts. ReSet intended to provide customizable shortcuts in order to
cater to as many users as possible. This however was also not implemented due to
time limitations and is hence a possible improvement.

#subsubsection("Shortcomings")

#subsubsubsection("Testing")
Testing with ReSet outside of manual integration tests were extremely hard, this
also means that only few tests were written and none of these can be run on a
system without the functionality for the settings ReSet provides. In this case a
proper mock system needs to be built that can be used to test both the daemon
and the application without needing real hardware functionality.

#subsubsubsection("Code Abstraction")
With both events and manual functions often providing similar but not the same
functionality, some code is currently needlessly duplicated. This code should be
abstracted further for better maintainability and readability.

#figure(sourcecode(```rs
// Example problematic code 
TODO
```), caption: [Example of problematic code to de-duplicate])<code_duplication>

The challenge here is to ensure that ReSet does not compromise on performance
with too many thread-safe references, and while still providing a clean
abstraction. This is especially hard with GTK subclassing, which does not always
work perfectly with rust features.
