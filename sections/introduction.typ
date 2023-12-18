#import "../templates/utils.typ": *
#lsp_placate()

#section("Introduction")
The Linux ecosystem is well known to be fractured, whether it is the seemingly
endless amount of distributions, or the various desktop environments,
there will always be someone who will create something new. With this reality
comes a challenge to create software that is not dependent on one singular
distribution or environment.

The same lack of universality can be seen when interacting with configuration
tools. Whenever a user would like to connect to a network, change their volume,
or connect a Bluetooth device, they have to do this with their environment
specific tool. To a certain degree, this makes sense, users should only see
settings, which they can actually use within their environment. Problems arise
when certain environments don't provide their own application, or perhaps
provide one without the needed functionality.

In this case, users would need to find a variety of different applications which
combined offer the same functionality. However, due to the split nature of
multiple applications, users end up with different levels of polish and
different user interfaces. Some might argue that this is the point of these
minimal environments, as they sometimes intentionally don't offer this type of
software by default, but there is also a distinct lack of this type of software.

A typical example for a minimal environment is a window manager/compositor.
In comparison to desktop environments, these do not offer any software other
than window management: creating windows, removing windows, window positioning,
etc. Any additional software needs to be installed separately, like status bars,
editors, media viewers, or in this case settings.

Some specific settings like monitor configuration were once universal with tools
like Xrandr, but with the introduction of the Wayland display
protocol, the original idea of having a universal display server was abandoned,
favoring individual implementations instead. This leads to a variety of
different ways to configure monitors, very few of them being compatible with
each other. In this case only a plugin system to handle individual
implementations could solve this problem.@wayland_documentation

#subsection("Objectives")
ReSet will make an effort to change this situation by creating a settings
application that works across these distributions and environments. This means
that both major and specifically smaller environments should be able to use this
application to fill the current gap. This allows users to avoid installing one
tool for each task, while also using one user interface with consistent design.

ReSet should be able to handle basic audio input and output, network and
Bluetooth connectivity for starters. For more advanced features, or specific
features, such as monitor configurations for individual compositors, ReSet
should have a plugin system, that allows for modular expansion of the
application. This modularity also allows for interaction with tools such as
status bars or the creation of applets. This expands the functionality beyond
ReSet as a user interface, and instead allows it to be a middleman between
compositor and shell components.

#pagebreak()

#subsection("Challenges")
- *Consistency*\
  As discussed in @Objectives, multiple applications will not necessarily create
  a consistent experience, however, even with a single application, creating a
  consistent application with multiple technologies and use-cases is not trivial.
- *Interoperability*\
  The reason for environment specific applications is the ease of integration. If
  one has control over the environment, it is easier to implement advanced
  features, however, without this control, there is a significant overhead for
  each feature.
- *Features*\
  In order for ReSet to be a viable alternative to existing solutions, it would
  need to cover the majority of use-cases, this means supporting as many features
  as possible, or providing a plugin system for modular expansion.
- *Maintainability*\
  With increasing scope, the overhead for developers will increase, causing
  potential slowdowns in development, or release cycles.

The challenges specified in combination with a smaller user base for minimal
environments are likely the cause for a missing universal solution. The previous
solutions are functional, just not optimal.

#subsection("Methodology")
This project was created by first evaluating existing projects in
@Analysisofexistingapplications and including techniques from literature in
@UserInterfaces. Further, technologies and potential solutions to
implementations were evaluated in @Implementation. With this information, the
implementation is documented starting at @Architecture. At the end, the solution
is discussed in @Conclusion, and potential further improvements mentioned in
@Improvements.
