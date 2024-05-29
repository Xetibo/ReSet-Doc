#import "../../templates/utils.typ": *
#lsp_placate()

#section("User Testing")
In this section the ReSet user testing for the exemplary plugins is discussed.

#subsection("Monitor Plugin Feedback")

#subsubsection("Monitor Plugin Tests")
#test(
  "Monitor Plugin Base", "The plugin loads alongside the basic features of ReSet.", [
  ], [
  ],
)
#test(
  "Monitor Plugin Single Settings", "Changing the resolution within the user interface and applying the configuration results in the chosen resolution being applied to the monitor.", [
  ], [
  ],
)
#test(
  "Monitor Plugin Single Settings", "Changing the refresh rate within the user interface and applying the configuration results in the chosen refresh rate being applied to the monitor.", [
  ], [
  ],
)
#test(
  "Monitor Plugin Single Settings", "Changing the rotation(transform) rate within the user interface and applying the configuration results in the chosen rotation(transform) being applied to the monitor.", [
  ], [
  ],
)
#test(
  "Monitor Plugin Single Settings", "Changing the scale rate within the user interface and applying the configuration results in the chosen scale being applied to the monitor.", [
  ], [
  ],
)
#test(
  "Monitor Plugin Special Settings", "Toggling the variable refresh rate button within the user interface and applying the configuration results in the chosen setting being applied to the monitor.", [
  ], [
  ],
)
#test(
  "Monitor Plugin Multi-Monitor Settings", "Enabling/Disabling a monitor within the user interface and applying the configuration results in the chosen setting monitor being enabled/disabled.", [
  ], [
  ],
)
#test(
  "Monitor Plugin Multi-Monitor Settings", "Rearranging the monitors with the mouse and applying the configuration results in the chosen arrangement being applied to the monitors.", [
  ], [
  ],
)
#test(
  "Monitor Plugin Multi-Monitor Special Settings", "Toggling a monitor as a primary monitor on environments such as KDE/GNOME and applying the configuration will set the primary monitor within that environment.", [
  ], [
  ],
)

#subsection("Keyboard Plugin Feedback")

#subsubsection("Keyboard Plugin Tests")
#test(
  "Keyboard Plugin Base", "The plugin loads alongside the basic features of ReSet.", [
  ], [
  ],
)
#test(
  "Keyboard Plugin Settings", "Opening the plugin page within ReSet will show the currently configured keyboard layouts.", [
  ], [
  ],
)
#test(
  "Keyboard Plugin Settings", "Adding a new keyboard layout with the user interface will show a new layout and will be saved to the environment.", [
  ], [
  ],
)
#test(
  "Keyboard Plugin Settings", "Rearranging the order of layouts will be saved to the environment. (A different layout will be active if the first layout is changed)", [
  ], [
  ],
)
#test(
  "Keyboard Plugin Settings", "Removing a layout from the list will also remove the layout within the environment configuration.", [
  ], [
  ],
)

#subsection("Conclusion")

