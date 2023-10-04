#import "../templates/utils.typ": *
#lsp_placate()

#section("Introduction")
The Linux ecosystem is well known to be fractured, whether it's the seemingly
endless amount of distributions, or the various desktop environments[@DE], there
will always be someone who will create something new. With this reality comes a
challenge to create software that is not dependent on one singular distribution
or environment.

The same lack of universality can be seen when interacting with configuration
tools. Whenever a user would like to connect to a network, change their volume,
or connect a Bluetooth device, they have to do this with their environment
specific tool. To a certain degree, this makes sense, users should only see
settings, which they can actually use within their environment. Problems arise
when certain environments don't provide their own application, or perhaps
provide one without the needed functionality.

In this case, users would need to find a variety of different applications that
that combined offer the same functionality. However, due to the split nature of
multiple applications, users end up with different levels of polish and
different user interfaces. Some might argue that this is the point of these
minimal environments, as they sometimes intentionally don't offer this type of
software by default, but there is also a distinct lack of this type of software.

A typical example for a minimal environment is a window manager/compositor @compositor. In
comparison to desktop environments, these do not offer any software other than
window management: creating windows, removing windows, window positioning, etc.
Any additional software needs to be installed separately, like status bars,
editors, media viewers, or in this case settings.

Some specific settings like monitor configuration were once universal with tools
like Xrandr, but with the introduction of the Wayland @wayland display protocol, the
original idea of having a universal display server was abandoned, favoring
individual implementations instead. This leads to a variety of different ways to
configure monitors, very few of them being compatible with each other. In this
case only a plugin system to handle individual implementations could solve this
problem.

#subsection("Motivation")
ReSet will make an effort to change this situation by creating a settings
application that works across these distributions and environments. This means
that both major and specifically smaller environments should be able to use this
application to fill the current gap. This allows users to avoid installing one
tool for each task, while also using one user interface with consistent design.

ReSet should be able to handle audio input and output, network connectivity and
Bluetooth connectivity as a base. For more advanced features, or specific
features, such as monitor configurations for individual compositors, ReSet
should have a plugin system, that allows for modular expansion of the
application. This modularity also allows for interaction with tools such as
status bars or the creation of applets. This expands the functionality beyond
ReSet as a user interface, and instead allows it to be a middleman between
compositor and shell component @shell-component.

#pagebreak()

#subsection("Project Requirements")
For ReSet, 3 different categories will be used to weigh existing projects and
potential solutions.

- #text(size: 11pt, [*Interoperability*])\
  This is the most important aspect, as it was the main driving factor for this
  work. Interoperability for ReSet is defined as the ease of use of a particular
  project in different environments. Important to note, is that multiple factors
  are considered:
  - *amount of working features*
  - *amount of non-working features*\
    This specifically refers to residue entries that would work on the expected
    environment, but not on the currently used environment.
  - *interoperability of toolkit*\
    Depending on the toolkit, it might behave differently with specific modules
    missing from other environments, this would once again increase the amount of
    additional work is needed, in order to get the expected interface.
  - *behavior on different environments*\
    Depending on the environment, applications have different ways of displaying
    themselves with different attributes like a minimum size. These constraints
    might not work well with different types of window management. A tiling window
    manager does not consider the minimum size of an application, as it will place
    it according to its layout rule. Applications with large minimum sizes are
    therefore preferably avoided.
- #text(size: 11pt, [*Ease of use*])\
  While functionality is important, the intention is to provide an application
  that is used by preference, not necessity.
- #text(size: 11pt, [*Maintainability*])\
  Applications with a plethora of functionality will get quickly large. This poses
  a particularly hard challenge for developers to keep the project maintainable.
  Too many features without a well-thought-out architecture will lead to
  potentially faulty code.

// no universal app
//#subsection("Solution")
//ReSet will be a set of 2 applications featuring one user interface application
//that will have common settings available for the user.\
//The second part of ReSet will be a daemon, which will be used to interact with
//necessary services, such as audio servers, configuration files and more.\
//This configuration also allows us to deliver an API, with which other
//applications can interact with the daemon, this means that ReSet can be used
//with applets, status bars and more, which are common in the Linux ecosystem.\
//In order to respect accessibility and the requirements of a Linux application,
//ReSet will also provide a command line version to interact with the
//Reset-Daemon.
