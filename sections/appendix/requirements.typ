#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Requirements")
#subsubsection("Functional Requirements")
As per Scrum, functional requirements are handled using the user story format
which can be found in the ReSet and ReSet-Daemon repositories respectively.

#subsubsection("Non-Functional Requirements")
#requirement(
  "User Interface", "Usability", "Medium", [
    Loading operations should not block the UI and the user should be informed with 
    a loading icon or similar.
  ], [
    - Show loading icons or similar during blocking operations.
      - Restrict actions during the loading period.
    - Use async functions in order to keep UI responsive.
  ],
)
#requirement(
  "User Interface", "Usability", "Medium", [
    Errors should be visible to the user, and the user should be able to solve
    issues accordingly.\
    Example: The user has not installed any Bluetooth software, therefore ReSet should
    inform the user of the situation.
  ], [
    - Provide adequate error handling in the user interface via popups or similar.
      - The same functionality should be available in CLI and API.
    - ReSet should not crash if a dependency is not installed.
  ],
)
#requirement("Code Duplication", "Maintainability", "Low", [
  ReSet should not have the same logic implemented as ReSet-Daemon.\
  In general, ReSet should not have any logic other than necessary.
], [
  - Provide adequate functions over the inter-process connection
  - Well-documented API
])
#pad(x: 0pt, y: 0pt, line(length: 100%))
