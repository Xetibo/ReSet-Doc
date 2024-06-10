#import "../templates/utils.typ": *
#lsp_placate()

#section("Introduction")
/* This thesis focuses on the improvement of the ReSet settings application. The improvements cover a large variety of topics, including a plugin system/* @plugin_system */, attending accessibility concerns in/* @accessibility */, creating a testing framework for DBus functionality in/* @test_framework */, animations for the ReSet user interface and creating a command line application to interface with ReSet. */
ReSet is a settings application for Linux made with GTK (formerly Gimp toolkit)
and the Rust programming language. The application aims to provide functionality
for all user interfaces (Desktop Environments) on Linux, reducing the need for
first-party applications by the environments themselves or the reliance on
smaller single-utility applications.

ReSet was a semester project for the OST, Eastern Switzerland University of
Applied Sciences. This thesis will expand on the original work, solving existing
issues and expanding its feature set.

#subsection("Objectives")
The focus of this thesis is on the introduction of a plugin system for the
existing ReSet application, which was omitted from the original work due to time
constraints.

The objective of a plugin system for ReSet is to provide a framework for
developers to create their widgets for ReSet in order to provide additional
setting functionality. Currently, ReSet only offers basic features such as
Networking, Bluetooth and Audio. These features are as generic as possible and
are expected to be usable on all Linux environments (considering the hardware
supports the functionality). Further functionality is often implemented on a
per-environment basis. Attempting to apply all these specific implementations to
ReSet would lead to an unmaintainable and likely non-functional product.
Therefore, the plugin system can cover both individual implementations, and
providing dynamic settings for specific hardware or user preferences.

Hardware examples are drawing tablets, virtual reality headsets, accessibility
solutions and more. User preference examples cover the reality that not every
user requires all settings, therefore a plugin system offers the users the
possibility to omit subjectively superfluous settings.

In order to expand the original ReSet application, this thesis will also develop
exemplary plugins. This will ensure the functionality of the plugin system and
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
- *Ease of Use* \
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
  Plugin systems should be stable in both "execution" and "environment". Stable
  execution refers to the system not crashing, while the stable environment refers
  to the plugin system API, which should not break compatibility with existing
  plugins on every update.

#subsection("Additional Objectives")
The original work has limitations which this thesis intends to build upon. As an
example, in the original work, code was often suboptimal with certain parts
being duplicated due to complexity constraints. Another critical section is the
testability of the program, which was omitted from the original work due to time
constraints.

As such, this thesis will include work on the original implementation in order
to facilitate the basis for a reliable plugin system.
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
In order to provide necessary information about technologies used by plugin
systems, various approaches and technologies are analyzed and explained in
@Prelude. Further, differing plugin system implementations were analyzed in
@PluginSystemAnalysis. This information is then used within
@PluginSystemEvaluation in order to evaluate the best plugin system architecture
for this thesis.\
Explicit implementations details for the resulting plugin system are discussed
in @Results.

As explained in @Objectives, this thesis will include exemplary plugins. For
these plugins, existing solutions for specific environments are analyzed in
@ExemplaryPluginAnalysis, which is used to create a mockup in @PluginUIMockups.
This information is used to create the plugins in @ExemplaryPluginAnalysis, with
the results being tested by users in @UserTesting.

At last, the conclusion of this thesis and potential future work is found in
@Conclusion.

// In @PluginSystem, different approaches to the plugin system are listed and
// discussed. Further analysis based on existing implementations is discussed in
// @PluginSystemAnalysis. With this information, the best approach will be chosen
// and explained in @PluginSystemEvaluation. Other features and improvements are
// discussed in/*@sometime*/. The implementation details can be found in/*@somewhere*/.
// The results of this thesis will be discussed in/*@somehow*/
// and potential future work is mentioned in/*@somewhereelse*/.

#subsection("Potential")
This thesis has the potential to introduce new functionality for users of
minimal environments who still wish to use a unified program with both a
graphical and command line interface.

With further work, more plugins can be introduced that could bridge the gap to
full desktop environments as explained in the original ReSet paper. @reset-paper
