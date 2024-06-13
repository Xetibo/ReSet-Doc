#import "../templates/utils.typ": *
#lsp_placate()

#section("Conclusion")
In this section, the final result of this thesis is discussed.

This thesis aimed to implement a reliable plugin system for the existing ReSet
application, in order to provide arbitrary extensibility for users. As a result,
this thesis implemented both the plugin itself and two exemplary plugins in order
to prove and test the implementation.

The thesis mentioned goal of a plugin system for the ReSet application has been
achieved with this thesis. Alongside this were two exemplary plugins, as well as
underlying work for the base ReSet application such as refactoring and testing
systems. The underlying work proved to be necessary for the extension of the
plugin system as well as the continuing maintainability of the ReSet
application.

The exemplary plugins prove that the plugin system works as expected and can hold
arbitrary extensions for differing functionality. Alongside the plugin
itself, the plugins prove the viability of the used testing framework for
plugins to be injected into the base application. This results in the expected
behavior of consolidated testing mentioned in @PluginTesting.

#subsection("Limitations")

The implementation of the plugin system lacks ABI stability, as explained in
@ApplicationBinaryInterfaceABI, this means that plugin developers are limited to
the Rust programming language. On top of this, any change in the compiler version
might break the compatibility of a plugin. While this can also occur with major
changes to the ABI conversion, it is at least decoupled from the compiler
itself.\
For this limitation, further work could implement ABI stability with the ABI
stable crate in order to provide a C-compatible layer, which can then be used by
any programming language.
// TODO: reference abi stable

#subsubsection("ReSet Leftovers")
In the original work, multiple potential improvements were mentioned. Some of
these points were addressed in this thesis, such as the testing environment for
DBus, or refactoring several parts of the codebase. However, due to the goal of
this thesis, no work was done to implement further features for the base
application, such as completing the missing parts of both Bluetooth and network
connectivity. Future work could focus on implementing a fully-fledged Bluetooth
and networking solution for ReSet.

Further improvements that were not featured in this thesis are accessibility
concerns for the base application, as well as keyboard movement and animation
improvements.

#subsubsection("Testing")
Similar to the original work, the inclusion of DBus endpoints and GTK
complicated testing heavily. Several special approaches had to be taken in order
to allow testing at all. Overall with more time, a proper GTK testing framework
and mock endpoints for environments such as Wayland protocols and more could be
implemented after careful consideration of the cost-to-gain ratio.

#subsubsection("Monitors")
Due to the current development status of High Dynamic Range within the Linux
desktop sphere, the HDR option for monitors is not implemented. This option
could be added once the development of HDR on Linux stabilizes.

Time constraints and further necessary research pushed color profiles into an
optional feature for the end product, which was omitted in favor of more testing
and further environment support. This feature is preferably implemented
alongside HDR as both options revolve around the same type of functionality.

The current implementation is targeted towards multiple Linux environments with
their specific implementation. This forces the plugin to provide multiple
endpoints to connect to the differing environments, as well as offer multiple 
conversions from the environment data types to the plugin data types. A new
Wayland protocol, offering universal management of monitors, could simplify the
implementation to a single endpoint for all Wayland implementations. The
challenges for this endeavor lie with the universal acceptance of such a
protocol, which would be required in order to gain universal status.

Support for environments is currently limited to Wayland implementations. This
is mainly because Wayland is the current standard, with X11 being phased out 
as time passes. Due to the drastic difference in paradigm, a different plugin 
implementing the X11 solution would be optimal.

#subsubsection("Keyboard")
As mentioned in @KeyboardLimit, the current protocol used within various Linux 
environments limits the active keyboard layouts to four. Hence, future work could
implement a new protocol in order to increase this number and hence, improve
functionality for users.

Even though features such as keyboard shortcuts, keyboard repeats and
user-defined custom layouts were initially planned, they had to be removed
because of time constraints.

#subsection("Potential")
This thesis offers users of ReSet the ability to inject plugins into the base
application, which offers them theoretically unlimited extensibility. Hence, the
biggest potential is likely to be seen in potential plugins for various use
cases. Examples include online account management, device configuration
(controllers, VR-Headsets, etc.), MIME type configuration, and more.

