#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Requirements")
#subsubsection("Functional Requirements")
As per Scrum, functional requirements are handled using the user story format
which can be found in the ReSet and ReSet-Daemon repositories respectively.

#subsubsection("Non-Functional Requirements")
#requirement("Seemless UI", "Performance", "High", [
  Settings should load quickly, so the user doesn't feel like the application is lagging
], [
  - Lazy loading of settings
  - Use spinner or similar to indicate loading
  - Use async function in order to keep UI responsive
])

#requirement("Seemless UI", "Usability", "Medium", [
  Users should not easily differentiate between Plugin and Core functionality.
], [
  - Provide a seemless user experience for the user by integrating plugin settings within core settings (e.g add plugin into sidebar)
])

#requirement("User Interface", "Maintainability", "Medium", [
  In case of a plugin crash, the application should not crash. It should try to continue running or at least log the error.
], [
  - Try to disable the crashing plugin and continue the application
  - Provide a log file for the user to view in case of a crash
])

#requirement("Test plugins", "Maintainability", "Medium", [
  Plugins should be tested to ensure they are working correctly.
], [
  - Check version number before running it.
])
#line(start: (0%, 0%), end: (100%, 0%), stroke: black )
