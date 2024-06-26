#import "../../templates/utils.typ": *

#subsection("Plugin UI Mockups")
In this section, two mockups of potential plugins are created. The first plugin
allows the user to change monitor settings and the second plugin allows keyboard
settings. The mockups were created using Mockflow, which is an online tool for
creating mockups. @mockflow

#subsubsection("Monitor Plugin Mockup")
While settings applications offer many different approaches and user interfaces,
the monitor settings look very similar across practically all applications that
were referenced. There is always a drag-and-drop area where the user can align
monitors. Because there are near-infinite variations on how monitors can be
ordered, it makes sense to use a widget where the user can visually see the
result. This makes it very intuitive compared to having users set the offset as
a number. A user is most likely to be familiar with a drag-and-drop feature,
which makes it easy to understand how to use it. @draganddrop\
The "Cancel" and "Apply" buttons are placed at the bottom of the drag-and-drop
area because it follows the natural downward flow of the user. A feature that
can be implemented into that area is the ability to change commonly used monitor
settings inside the area like resolution and orientation. Many applications only
offer these settings after scrolling a bit, which is not very user-friendly.
#align(
  center, [#figure(
      img("../figures/monitorMock.png", width: 85%, extension: "figures"), caption: [Monitor plugin mockup],
    )<monitor-mock>],
)

Below this area, the user can set the main monitor and change other settings
such as the brightness and night mode. The order is inspired by Windows 11. The
further down the user scrolls the less common and more advanced the settings
should become. This should allow users to easily find settings that are often
changed. The order seen in @monitor-mock does not hold much meaning and should
be taken only as a filler. The specific form controls for each setting are not
considered for now.\
There are a few settings that are handled differently or are just plainly not
available in certain desktop environments. To address these variations, the UI
will check which desktop environment is currently running and display the
correct widgets accordingly.

For reference @windows_monitor_settings visualizes the Windows 11 monitor
configuration.

#align(
  center, [#figure(
      img(
        "../figures/windowsMonitorSettings.png", width: 100%, extension: "figures",
      ), caption: [Windows monitor settings],
    )<windows_monitor_settings>],
)

#subsubsection("Keyboard Plugin")
While many keyboard settings can be implemented, only the very basic ones will
be in the mockup. Any further settings can be implemented further down the
navigation page or a group of settings can be moved into a tab to keep the main
page clean and simple.

#align(
  center, [#figure(
      img("../figures/keyboardMock.png", width: 85%, extension: "figures"), caption: [Mock of keyboard plugin],
    )],
)

The keyboard plugin UI starts with a list of currently available keyboard
layouts. Because the user can have multiple keyboard layouts which have to be
sorted by importance, the best form of control for this is a sortable list. This
is because, at the same time, the layout in the first place is also the default
keyboard layout. The usage of such form control can be seen in Windows and GNOME
Settings.\
As defined in @KeyboardLimit, there is a maximum of keyboard layouts a system
can have configured at the same time. For example, if a user has ten keyboard
layouts configured, only the first four can be switched to.// TODO: move to implementation
The switchable keyboard layouts will be colored to indicate if they are active
or not.

In @gnome-keyboard-setting-list, GNOME's keyboard list can be seen.

#align(
  center, [#figure(
      img(
        "../figures/gnomeKeyboardSetting.png", width: 65%, extension: "figures",
      ), caption: [GNOME keyboard layouts],
    )<gnome-keyboard-setting-list>],
)

The user can also add a new layout with "Add layout" button, which places the
new layout at the bottom of the list. By clicking on the three dots on the
right, the user can open a context menu to remove the layout.

The user is shown a list of all available keyboard layouts in the system. The
arrow icon indicates that there are multiple variations of the same keyboard
such as "de-us",
"de-dvorak", "de-mac" and many more. To reduce cluttering, only the main layout
is shown, and all other variations are hidden until the user clicks on the row.
This immediately hides all other layouts and only shows the layout and its
variations. A new back button will be prepended to the list to allow the user to
go back to the main list. This feature is inspired by GNOME Settings and has been expanded upon. GNOME
Settings only has this feature for "English (UK)" and
"English (US)", while all other layouts are shown at the same time. This makes
it harder for the user to find a specific layout because filtering the layouts
with the search bar can still show layouts of another language, which have a
similar name. In @keyboard-add-layout-mock a mockup of this feature can be seen.

#align(
  center, [#figure(
      img(
        "../figures/keyboardAddLayoutMock.png", width: 85%, extension: "figures",
      ), caption: [Mock of keyboard add layout plugin],
    )<keyboard-add-layout-mock>],
)
