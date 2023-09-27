#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Requirements")
#subsubsection("Functional Requirements")
As per scrum, functional requirements are handled using the user story format
which can be found on the ReSet and ReSet-Daemon repositories respectively.

#subsubsection("Non-Functional Requirements")
#requirement(
  "User Interface",
  "Usability",
  "medium",
  [
    Reaction time should not be noticeable by user, and UI should not be blocked
    during loading operations.
  ],
  [
    - Show loading icons or similar during blocking operations.
      - restrict actions during loading period.
    - Use async functions in order to keep UI responsive. (GTK enforces this)
  ],
)
#requirement(
  "User Interface",
  "Usability",
  "medium",
  [
    Errors should be visible to the user, and the user should be able to solve
    issues accordingly.\
    Example: user has not installed any Bluetooth software, therefore ReSet should
    inform the user of the situation.
  ],
  [
    - Provide adequate error handling in user interface via popups or similar.
      - Same functionality should be available in CLI and API.
    - ReSet should not crash if a dependency is not installed.
  ],
)
#requirement("Code Duplication", "Maintainability", "low", [
  ReSet should not have the same logic implemented as ReSet-Daemon.\
  In general, ReSet should not have any logic other than necessary.
], [
  - Provide adequate functions over inter process connection
  - Well documented API
])
#pad(x: 0pt, y: 0pt, line(length: 100%))
