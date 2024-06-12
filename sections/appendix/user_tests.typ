#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("User Testing")
In this section, the ReSet usability tests for the exemplary plugins are discussed.

#subsubsection("Participants")
In our usability test, a total of 11 participants were involved. In @test-partcipant-experience
the participant's experience with PC and Linux is shown. Most participants are very experienced 
using a PC and have a good understanding of Linux as most are studying computer science. This 
sample might skew the results towards more experienced users.

#align(
  center, [#figure(
      [
        #columns(2, [
          #img("testPCExperience.png", width: 100%, extension: "figures")
          #colbreak()
          #img("testLinuxExperience.png", width: 100%, extension: "figures")
        ])
      ], caption: [Participants' PC and Linux Experience],
    )<test-partcipant-experience>],
)

#subsubsection("Monitor Plugin Tests")
#test(
  "Monitor Plugin Base", 
  "Did you find the monitor page? Did you encounter any issues opening the page?", 
  [
    All participants found the monitor plugin page without any issues.
  ], 
  [
    No improvements were suggested.
  ],
)
#test(
  "Monitor Plugin Single Settings", 
  "Changing the resolution within the user interface and applying the configuration results in the chosen resolution being applied to the monitor.", 
  [
    Most participants were able to change the resolution without any issues. One
    participant had issues with the resolution not being applied if the monitors 
    were not adjacent. The confirmation dialogue with the revert function was praised.
  ], 
  [
    - Name and resolution inside monitor clips through the border
    - The Apply button is not directly visible
  ],
)
#test(
  "Monitor Plugin Single Settings", 
  "Changing the refresh rate within the user interface and applying the configuration results in the chosen refresh rate being applied to the monitor.", 
  [
    All participants were able to change their refresh rate.
  ], 
  [
    No improvements were suggested.
  ],
)
#test(
  "Monitor Plugin Single Settings", 
  "Changing the rotation (transform) rate within the user interface and applying the configuration results in the chosen rotation (transform) being applied to the monitor.", 
  [
    All participants were able to change their monitor rotation. The only changes
    proposed were of cosmetic nature. 
  ],
  [
    - Add ° to numbers (90 -> 90°) or use words instead of degrees
  ],
)
#test(
  "Monitor Plugin Single Settings", 
  "Changing the scale rate within the user interface and applying the configuration results in the chosen scale being applied to the monitor.", 
  [
    All participants were able to change their monitor scale. A few found the shown 
    scale values and its steps a bit confusing. 
  ], 
  [
    - Show percentage values instead of numbers
  ],
)
#test(
  "Monitor Plugin Special Settings", 
  "Toggling the variable refresh rate button within the user interface and applying the configuration results in the chosen setting being applied to the monitor.", 
  [
    Most participants had no VRR support. The ones that had it could not verify the 
    change.
  ], 
  [
    No improvements were suggested.
  ],
)
#test(
  "Monitor Plugin Multi-Monitor Settings", 
  "Enabling/Disabling a monitor within the user interface and applying the configuration results in the chosen setting monitor being enabled/disabled.", 
  [
    The participants that had a multi-monitor setup were able to enable/disable monitors 
    without any issues. One user didn't find the option to enable/disable a monitor.
  ], 
  [
    No improvements were suggested.
  ],
)
#test(
  "Monitor Plugin Multi-Monitor Settings", 
  "Rearranging the monitors with the mouse and applying the configuration results in the chosen arrangement being applied to the monitors.", 
  [
    The participants that had a multi-monitor setup were mostly able to rearrange their 
    monitors. One participant didn't notice that the monitors could be dragged.
  ], 
  [
    - Snapping of monitors could be more lenient
    - Show that monitors can be dragged
    - Disable Apply button when monitors are overlapping instead of snapping
  ],
)
#test(
  "Monitor Plugin Multi-Monitor Special Settings", 
  "Toggling a monitor as a primary monitor on environments such as KDE/GNOME and applying the configuration will set the primary monitor within that environment.", 
  [
    Most participants were able to set their main monitor. One participant reported that 
    it could only be applied once.
  ], 
  [
    No improvements were suggested.
  ],
)

#subsubsection("Keyboard Plugin Tests")
#test(
  "Keyboard Plugin Base", "Did you find the keyboard page? Did you encounter any issues on opening the page?", 
  [
    All participants found the keyboard plugin page without any issues.
  ], 
  [
    No improvements were suggested.
  ],
)
#test(
  "Keyboard Plugin Settings", 
  "Opening the plugin page within ReSet will show the currently configured keyboard layouts.", 
  [
    All participants were able to see their current keyboard layouts. One participant 
    had German shown as the active layout, but the US layout was active.
  ], 
  [
    No improvements were suggested.
  ],
)
#test(
  "Keyboard Plugin Settings", 
  "Adding a new keyboard layout with the user interface will show a new layout and will be saved to the environment.", 
  [
    Some users were able to add a new layout without issues. Others had some crashes 
    when adding a new layout or the layout was not saved.
  ], 
  [
    - Double-click to add a layout
    - Add multiple layouts at once
  ],
)
#test(
  "Keyboard Plugin Settings", 
  "Rearranging the order of layouts will be saved to the environment. (A different layout will be active if the first layout is changed)", 
  [
    Worked for most participants, with some having issues with the default layout not 
    being set.
  ], 
  [
    - Dropping zone is too harsh
    - click doesn't always register
  ],
)
#test(
  "Keyboard Plugin Settings", 
  "Removing a layout from the list will also remove the layout within the environment configuration.", 
  [
    Most participants were able to remove a layout without any issues. One participant 
    crashed the application when removing a layout.
  ], 
  [
    - Context menu pointless with only one option
  ],
)

#subsubsection("Feedback")
In general, the feedback from the participants was predominantly positive. Most participants
did not encounter any big issues. The suggestions for improvements were mostly cosmetic 
or small usability improvements.

#subsubsubsection("Ease of use")
The feedback regarding the ease of use was very positive. Most participants found the plugins
to be very intuitive to use because the UX was familiar. Another point that was mentioned was
it worked with different themes. One participant mentioned that the drag-and-drop feature
for the keyboard plugin was not effortless. In @test-eou-experience the participant's review
scores regarding ease of use are shown.

#align(
  center, [#figure(
      [
        #columns(2, [
          #img("testEoUMonitor.png", width: 100%, extension: "figures")
          #colbreak()
          #img("testEoUKeyboard.png", width: 100%, extension: "figures")
        ])
      ], caption: [Participants' Ease of Use Feedback],
    )<test-eou-experience>],
)

#subsubsubsection("Design")
Participants praised the simple and clean design of the plugins which reminded them of the 
GNOME control settings. Some participants mentioned that the spacing could be improved to 
make the interface feel less cramped and allow for more customization. In @test-design-experience 
the participant's review scores regarding the design are shown.

#align(
  center, [#figure(
      [
        #columns(2, [
          #img("testDesignMonitor.png", width: 100%, extension: "figures")
          #colbreak()
          #img("testDesignKeyboard.png", width: 100%, extension: "figures")
        ])
      ], caption: [Participants' Design Feedback],
    )<test-design-experience>],
)

#subsubsubsection("Conclusion")
In conclusion, most participants found the plugins to be very useful and easy to use. Some 
more general improvements that were suggested were for example translations and automatic 
installation scripts for plugins. Requested features were for example a notification manager 
and a system tray config. A few of the suggestions have already been implemented.