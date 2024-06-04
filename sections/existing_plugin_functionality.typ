#import "../templates/utils.typ": *

#section("Exemplary Plugin Analysis")

#subsection("Plugin Ideas")
For this thesis, two common use cases with settings applications were chosen.
This guarantees that all environments offer at least basic configuration of this
functionality which can be implemented as a plugin for ReSet.

The first plugin is a monitor configuration plugin, which would allow users to
create monitor arrangements, change their resolution/refresh rate and more.

The second plugin is a keyboard layout plugin, which allows users to add, remove
and rearrange layouts to their preferred order.

Both of these plugins should offer both a daemon implementation and a graphical
user interface.
// TODO: explain why those 2 were chosen

#include "./existing_plugin_functionality/monitor.typ"
#include "./existing_plugin_functionality/keyboard.typ"
