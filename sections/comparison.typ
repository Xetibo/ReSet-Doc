#import "../templates/utils.typ": *
#lsp_placate()

#let language_weights = (
  testability: 2, language_conformity: 1, use_case_overlap: 2, expected_workload: 2, compatibility: 3,
)

#subsection("Plugin System Evaluation")
This section covers the chosen plugin system paradigm for ReSet. Paradigms are
evaluated using a value table, which defines a score between 0 and 2 for each
category. A score of 0 indicates an infeasible requirement, 1 indicates that the
system could work, but not optimally, while a score of 2 indicates an optimal
system for the requirement. Each category is also given a constant weight, in
order to evaluate which paradigm is chosen.\
The weights are as follows: low -> 1, medium -> 2, high -> 3

The following categories are evaluated for programming languages:
- *Testability* | weight: medium\
  This category defines how well the system can be tested and whether plugins can
  also be tested using this system.\
  As testability was problematic with the original work, this thesis intends to
  improve upon this situation. Therefore the weight medium is chosen as it
  represents an important but not critical aspect.
- *Language Conformity* | weight: low\
  Language conformity defines how well a particular system would work with the
  Rust programming language. This category is evaluated by creating small
  prototype implementations of potential systems.\
  The weight low is used due to the impact of this category. While it would be
  beneficial for the system to be easily integrated, it is not a crucial
  requirement.
- *Use Case Overlap* | weight: medium\
  Specific paradigms will favor specific use cases, this point will solely cover
  how well the paradigm would suit the need of ReSet.\
  The weight medium is used as the applicability of the system to the use case
  should overall fit the requirements. More so than integration with Rust, if the
  system does not fit into the architecture of ReSet, substantial work might be
  needed to fulfill the requirements.
- *Expected Workload* | weight: medium\
  This is the evaluation of the authors on how much work is to be expected for
  specific paradigms based on the research of existing plugin systems.\
  The weight medium is used as the workload must overall be in line with the time
  constraints of this thesis.
- *Compatibility* | weight: high\
  Compatibility covers the need for the plugin system to interact with all
  existing third-party libraries. For ReSet, this would include the GTK user
  interface toolkit and the dbus-rs crate, for which the plugin must be suitable.
  This category is considered important, as rewriting ReSet with different
  libraries is not feasible for this thesis. @dbus_rs

Special requirement: All tools used in this project *must be published under a
free and open-source license*, as ReSet will be published under the GPL-3.0
license.

#pagebreak()

#subsubsection("Comparison")
This section covers the comparison of each plugin system implementation when
applied to ReSet.

For this test, only two approaches are considered, the first is the dynamic
library paradigm and the second is the interpreted language paradigm. Paradigms
like function hooks and function overriding are usually just slight variants of
either dynamic libraries or interpreted languages, and would therefore suffer
from similar benefits and downsides.

#subsubsubsection("Testability")
ReSet targets not only to offer testability for the core functionality but also
for the plugins themselves. Considering the architecture of ReSet, this would
require integration into both DBus and GTK.

For all plugin systems, tests would require the dynamic loading of plugins
specified within a configuration file or similar. As Rust allows tests to
execute any arbitrary code, loading of either dynamic libraries or virtual
machines for interpretation is feasible.

For this category, there is no difference between any specific plugin system.
Therefore, both systems receive the result of 1 as neither system works
particularly well.

#subsubsubsection("Language Conformity")
All plugin systems use some form of abstraction compared to just using Rust.
Meaning there is no outright winner. This is especially the case when looking at
differing stable ABI usages and different scripting languages. Rust native
structs, functions and more usually transfer without issue to both a stable ABI
or a scripting language.

For this category, the analysis has not resulted in any meaningful differences
in the architecture. Note, however, that this does not include specific usages
of an architecture. For example, the steel scripting language offers better
language conformity than using lua as the scripting language.

Both systems receive the baseline result of 2.

#subsubsubsection("Use Case Overlap")
ReSet targets solely the expansion of functionality without restrictions. This
means that ReSet neither intends to offer custom hooking functionality, as there
is no underlying system to hook into, nor does ReSet intend to prevent the
plugin developers from using the full range of features of any tooling.

A potential plugin system should also consider the architecture of ReSet, as
ReSet includes a multiprocess architecture. When comparing interpreted languages
to dynamic libraries on this specific point, there is a considerable difference.
As the name suggests interpreted languages require an interpreter, and as ReSet
uses multiple processes, this would require two interpreters, adding an
abstraction to the already distributed architecture of ReSet. With dynamic
libraries, a library loaded into memory can be re-used, this means there is only
one instance of a plugin within memory, which is then used by multiple
processes.

The analysis concluded a significant benefit to using dynamic libraries for this
category. As such, dynamic libraries receive the result of 2 while interpreted
languages receive the result of 1.

#pagebreak()

#subsubsubsection("Expected Workload")
Dynamic libraries would likely require the use of macros to ensure the simple
creation of plugins. Considering @Anyrun as an example, this would require
significant overhead for the implementation. However, interpreted languages
could also require additional overhead when considering the integration of
individual parts of the system. In @Helix, an example usage of an interpreted
language is shown. Even with this simple example without integration of DBus, it
already required additional thread synchronization.

For this category, no system has shown any substantial benefits. Both systems
receive the baseline result of 1.

#subsubsubsection("Compatibility")
ReSet uses two libraries that a plugin system must be able to support, namely
GTK and DBus.

For a plugin system utilizing dynamic libraries written in Rust, C or C++, this
would not be an issue. All of these languages offer solid bindings for the
language, or the entire library is already written with that language.

However, for interpreted languages, this would make it more difficult to use.
ReSet could provide pre-defined widgets for the interpreted language in order to
build a UI, however, this would conflict with @UseCaseOverlap, making it
unsuitable. The secondary option is to use an interpreted language that offers
bindings for GTK. This however would limit ReSet to a small amount of languages,
none of which are written with Rust in mind, further complicating integration as
mentioned in @LanguageConformity.

For this category using dynamic libraries offers a substantial benefit. As such,
dynamic libraries receive the result of 2 while interpreted languages receive
the result of 1.

#subsubsection("Results")

#let dynamic_libaries = (
  testability: 1, language_conformity: 2, use_case_overlap: 2, expected_workload: 1, compatibility: 2,
)
#let interpreted_languages = (
  testability: 1, language_conformity: 2, use_case_overlap: 1, expected_workload: 1, compatibility: 1,
)
#grid(
  columns: (auto), rows: (30pt), cell(
    [#figure([], kind: table, caption: [Plugin System paradigms])<pluginsystemparadigms>], bold: true,
  ),
)
#pad(y: -13.1pt, [])

#grid(
  columns: (2fr, 3.5fr, 3.5fr, 1fr), rows: (45pt, 35pt, 35pt, 35pt, 35pt, 35pt), gutter: 0pt, cell("Category", bold: true, use_under: true, cell_align: left), cell("Dynamic Libraries", bold: true, use_under: true), cell("Interpreted Languages", bold: true, use_under: true),
  // cell("Function\nOverriding", bold: true, use_under: true),
  cell("Weight", bold: true, use_under: true), cell("Testability", bold: true, cell_align: left), cell([#dynamic_libaries.testability], bold: true), cell([#interpreted_languages.testability], bold: true),
  // cell([#function_overriding.testability], bold: true),
  cell([#language_weights.testability], bold: true), cell("Language\nConformity", bold: true, fill: silver, cell_align: left), cell([#dynamic_libaries.language_conformity], bold: true, fill: silver), cell([#interpreted_languages.language_conformity], bold: true, fill: silver),
  // cell([#function_overriding.language_conformity], bold: true, fill: silver),
  cell([#language_weights.language_conformity], bold: true, fill: silver), cell("Use Case\nOverlap", bold: true, cell_align: left), cell([#dynamic_libaries.use_case_overlap], bold: true), cell([#interpreted_languages.use_case_overlap], bold: true),
  // cell([#function_overriding.ecosystem], bold: true),
  cell([#language_weights.use_case_overlap], bold: true), cell("Expected\nWorkload", bold: true, fill: silver, cell_align: left), cell([#dynamic_libaries.expected_workload], bold: true, fill: silver), cell([#interpreted_languages.expected_workload], bold: true, fill: silver),
  // cell([#function_overriding.expected_workload], bold: true, fill: silver),
  cell([#language_weights.expected_workload], bold: true, fill: silver), cell("Compatibility", bold: true, cell_align: left), cell([#dynamic_libaries.compatibility], bold: true), cell([#interpreted_languages.compatibility], bold: true),
  // cell([#function_overriding.expected_workload], bold: true),
  cell([#language_weights.compatibility], bold: true), cell("Total", bold: true, fill: silver, cell_align: left), cell(
    [#calculate_total(dynamic_libaries, language_weights)], color: green, bold: true, fill: silver,
  ), cell(
    [#calculate_total(interpreted_languages, language_weights)], bold: true, fill: silver,
  ), cell(" ", bold: true, fill: silver),
)

For Reset, the usage of dynamic plugins is the most suitable option for creating
a plugin system. Not only will this guarantee that any Rust functionality will work, 
but it will also ensure that resources are shared between the daemon and the
user interface.
