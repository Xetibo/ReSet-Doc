#import "../../templates/utils.typ": *

#subsection("Plugin System Implementation")
This section covers the implementation of the ReSet plugin system.

#subsubsection("General Plugin System")

#subsubsection("Any-Variant")

#subsubsection("Security")

#subsubsection("Testing")
Rust tests are handled by a specific test macro, this flag tells the compiler that this function is to be used when testing the specific project.
This works well for a single project without dynamic loading of additional functionality, e.g. a plugin system.
While it is possible to call arbitrary functions within a function marked as a test function,
it would also bundle all functions within the test function into one. 
If ReSet were to call all plugin tests from one test function,
this would enforce that all plugin tests utilize the same thread and any error would cancel all remaining plugin tests.

// TODO: code of original testing call

In order to solve this issue,
ReSet utilizes a different thread spawning mechanism with a separate printing functionality
in order to provide feedback about each individual plugin test function.
This mechanism also allows plugins to be shown as separate entities with their own tests,
ensuring that developers receive appropriate feedback.

// TODO: code of new testing call and system

#subsubsection("ReSet-Daemon Plugin System")
