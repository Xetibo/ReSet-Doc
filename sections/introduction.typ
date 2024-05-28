#import "../templates/utils.typ": *
#lsp_placate()

#section("Introduction")
/* This thesis focuses on the improvement of the ReSet settings application. The improvements cover a large variety of topics, including a plugin system/* @plugin_system */, attending accessibility concerns in/* @accessibility */, creating a testing framework for DBus functionality in/* @test_framework */, animations for the ReSet user interface and creating a command line application to interface with ReSet. */
ReSet is a settings application for Linux made with GTK and the Rust programming
language. The application aims to provide functionality for all user interfaces
(Desktop Environments) on Linux, reducing the need for first party applications
by the environments themselves or the reliance on smaller single utility
applications.

ReSet was a semester project for the OST, Eastern Switzerland University of
Applied Sciences. This thesis will expand on the original work, solving existing
issues and expanding its feature set.

#subsection("Objectives")
The focus of this thesis is the on the introduction of a plugin system for the
existing ReSet application, which was omitted from the original work due time
constraints.

The objective of a plugin system for ReSet is providing a framework for
developers to create their own widget for ReSet in order to provide additional
setting functionality. Currently, ReSet only offers basic features such as
Networking, Bluetooth and Audio. These features are as generic as possible and
are expected to be usable on all Linux environments (considering the hardware
supports the functionality). Further functionality is often implemented on a
per-environment basis. Attempting to apply all these specific implementations to
ReSet would lead to an unmaintainable and likely non-functional product.
Therefore, the plugin system can cover both individual implementations, and
providing dynamic settings for specific hardware or user preferences.

Examples for hardware are drawing tablets, virtual reality headsets,
accessibility solutions and more. User preference examples cover the reality
that not every user requires all settings, therefore a plugin system offers the
users the possibility to omit subjectively superfluous settings.

In order to expand the original ReSet application, this thesis will also develop
exemplary plugins. This will ensure functionality of the plugin system and
allows for testing and potential revisions of the system.

// ReSet will mainly focus on the plugin system, which allows it to expand its
// features repertoire to include keyboard, monitors, status bars and many more
// settings. This expands the functionality beyond ReSet as a user interface, and
// instead allows it to be a middleman between compositor and shell components. It
// also allows for the community to create their own plugin to expand the
// functionalities of ReSet.

#subsection("Challenges")
- *Consistency* \
  With the advent of the plugin system, the importance of a consistent user
  experience is more relevant as creating an application with multiple
  technologies and use cases is not trivial. For this requirement, all plugins
  need to be able to represent themselves as integrated functionality of ReSet in
  order for the user to not notice the plugin system at all.

  This ensures that users will be able to switch from one plugin to another
  without being introduced to new design paradigms or differing concepts.
- *Accessibility* \ // TODO: should be renamed -> this application does not cover accessibility
  Creating a good user experience and making the application accessible to all
  users requires a deep understanding of the user base which could require a lot
  of time.
- *Maintainability* \
  With increasing features, the technical debt might increase and become a
  potential slowdown in development or release cycles.
- *Developer Experience* \
  Plugin systems require rigorous documentation and communication. Developers
  should always be informed about changes without needing to frequently visit the
  codebase.
- *Stability* \
  Plugin systems should be stable in both the "execution" and "environment".
  Stable execution refers to the system not crashing, while the stable environment
  refers to the plugin system API, which should not break compatibility with
  existing plugins on every update.

#subsection("Additional Objectives")
// animations
// Furthermore, ReSet will add animations to improve its user experience which
// helps to better understand the flow of the application, attend to accessibility
// concerns to make it more user-friendly, testing framework for DBus
// functionalities and a command line application to interface with ReSet.
//
// bug fixes
// core features?
// accessibility
// testing framework
// etc

#subsection("Methodology")
In @PluginSystem, different approaches to the plugin system are listed and
discussed. Further analysis based on existing implementations is discussed in
@PluginSystemAnalysis. With this information, the best approach will be chosen
and explained in @PluginSystemEvaluation. Other features and improvements are
discussed in/*@sometime*/. The implementation details can be found in/*@somewhere*/.
The results of this thesis will be discussed in/*@somehow*/
and potential future work are mentioned in/*@somewhereelse*/.
