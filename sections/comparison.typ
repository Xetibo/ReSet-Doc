#import "../templates/utils.typ": *
#lsp_placate()

#let language_weights = (
  familiarity: 0, developer_experience: 0, ecosystem: 0, runtime_speed: 0, resource_usage: 0,
)

#section("Plugin System Paradigms")
This section covers the chosen plugin system paradigm for ReSet. Paradigms are
evaluated using a value table, which defines a score between 0 and 10 for each
category over each tool. Each category is also given a constant weight, in order
to evaluate which paradigm is chosen.\
The weights are as follows: low -> 1, medium -> 2, high -> 3

The following categories are evaluated for programming languages:
- *Existing Solutions* | weight: low\
  This section covers how many other applications have implemented such a paradigm
  and the evaluation of the authors on how easily these implementations could be
  applied to ReSet.
- *Language Conformity* | weight: low\
  Language conformity defines how well a particular system would work with the
  Rust programming language. This category is evaluated by existing plugin systems
  written specifically for Rust projects.
- *Use Case Overlap* | weight: medium\
  Specific Paradigms will favor specific use cases, this point will solely cover
  how well the paradigm would suit the need of ReSet.
- *Expected Workload* | weight: medium\
  This is the evaluation of the authors on how much work is to be expected for a
  specific paradigm based research of existing plugin systems.
- *Toolkit Compatibility* | weight: high\
  Toolkit compatibility covers the need for the plugin system to interact with all
  existing third party libraries. For ReSet, this would include the GTK user
  interface toolkit, for which the plugin must be suitable. This category is
  considered important, as rewriting ReSet to another toolkit is not feasible for
  this thesis.

Special Requirement: All tools used in this project *must be published under an
open-source license*, as ReSet will be published under the GPL-3.0 license.

#pagebreak()
#let dynamic_libaries = (
  familiarity: 0, developer_experience: 0, ecosystem: 0, runtime_speed: 0, resource_usage: 0,
)
#let interpreted_languages = (
  familiarity: 0, developer_experience: 0, ecosystem: 0, runtime_speed: 0, resource_usage: 0,
)
#let function_overriding = (
  familiarity: 0, developer_experience: 0, ecosystem: 0, runtime_speed: 0, resource_usage: 0,
)
#grid(
  columns: (auto), rows: (30pt), cell(
    [#figure([], kind: table, caption: [Plugin System paradigms])<pluginsystemparadigms>], bold: true,
  ),
)
#pad(y: -13.1pt, [])
//typstfmt::off
#grid(
  columns: (2fr, 2fr, 2fr, 2fr, 1fr),
  rows: (45pt, 30pt, 30pt, 30pt, 30pt, 30pt),
  gutter: 0pt,
  cell("Category", bold: true, use_under: true, cell_align: left),
  cell("Dynamic Libraries", bold: true, use_under: true),
  cell("Interpreted Languages", bold: true, use_under: true),
  cell("Function Overriding", bold: true, use_under: true),
  cell("Weight", bold: true, use_under: true),
  cell("Existing Solutions",bold: true, cell_align: left),
  cell([#dynamic_libaries.familiarity], bold: true),
  cell([#interpreted_languages.familiarity], bold: true),
  cell([#function_overriding.familiarity], bold: true),
  cell([\*#language_weights.familiarity],bold: true),
  cell("Language Conformity", bold: true, fill: silver, cell_align: left),
  cell([#dynamic_libaries.developer_experience],bold: true,fill: silver),
  cell([#interpreted_languages.developer_experience], bold: true, fill: silver),
  cell([#function_overriding.developer_experience], bold: true, fill: silver),
  cell([\*#language_weights.developer_experience], bold: true, fill: silver),
  cell("Use Case Overlap", bold: true, cell_align: left),
  cell([#dynamic_libaries.ecosystem], bold: true),
  cell([#interpreted_languages.ecosystem], bold: true),
  cell([#function_overriding.ecosystem], bold: true),
  cell([\*#language_weights.ecosystem], bold: true),
  cell("Expected Workload", bold: true, fill: silver, cell_align: left),
  cell([#dynamic_libaries.runtime_speed], bold: true, fill: silver),
  cell([#interpreted_languages.runtime_speed], bold: true, fill: silver),
  cell([#function_overriding.runtime_speed], bold: true, fill: silver),
  cell([\*#language_weights.runtime_speed], bold: true, fill: silver),
  cell("Toolkit Compatibility", bold: true, cell_align: left),
  cell([#dynamic_libaries.resource_usage], bold: true),
  cell([#interpreted_languages.resource_usage], bold: true),
  cell([#function_overriding.resource_usage], bold: true),
  cell([\*#language_weights.resource_usage], bold: true),
  cell("Total", bold: true, fill: silver, cell_align: left),
  cell([#calculate_total(dynamic_libaries, language_weights)], bold: true, fill: silver),
  cell([#calculate_total(interpreted_languages, language_weights)], bold: true, fill: silver),
  cell([#calculate_total(function_overriding, language_weights)], bold: true, fill: silver),
  cell(" ", bold: true, fill: silver),
)
//typstfmt::on
