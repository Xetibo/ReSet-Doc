#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Keyboard Plugin")

#subsubsection("Analysis of different environments")
In this section, the analysis of the keyboard plugin on various environments are
discussed.

#subsubsubsection("Hyprland")
The keyboard layouts in Hyprland are stored in a hypr.conf file, which is a
configuration file and can be modified using multiple ways.

One way is to use Hyprctl, a command-line tool that can be used to modify the
setting. The problem with it is that the settings set by Hyprctl are not
persistent. That means that those changes disappear after a restart @hyprctl.

The other method is to write it directly into the hypr.conf file. Because the
configuration file uses a custom configuration language called hyprlang, it's
very hard to make changes in a specific area there because currently no parser
exists for it that is written in rust.

#subsubsubsection("GNOME")
In GNOME, it is possible to change keyboard layouts with gsettings or dconf.
There are other tools like gconf, but they are replaced by dconf.

GSettings is a high-level API for application settings and serves as a front end
to dconf. The command line tool gsettings (not to be confused with GSettings)
can be used to access the GSettings API @gsettings. Another possibility is to
use GIO, which is a library that provides multiple general purpose functionality
such as bindings to the GSettings API among others @gio. Because GIO is a
dependency of gtk4, it can already be used from the code without any further
setup. The advantage of using GIO instead of gsettings is that it can validate
input and log error messages if something does not work. Another advantage is
that gsettings returns a string that needs to be manually parsed with Regex or
similar. GIO on the other hand returns a Variant object that can be casted into
the desired type as long as it's correct.

Dconf serves as a low-level configuration system for gsettings that stores
key-based configuration details in a single compact binary format database
@dconf. Because gsettings is a layer for dconf, the keyboard plugin directly
uses dconf for setting the keyboard layouts. Combined with the dconf crate,
which provides rust bindings to dconf, the plugin can read the keyboard layouts
@dconf_rs. This returns a string that needs to be parsed to get the keyboard
layout and variant, which can be done with a simple regex.

#subsubsubsection("KDE")
KDE stores its keyboard configurations in a file called kxkbrc. This text file
is located in the config folder of the user and can be read using kreadconfig6
and written to using kwriteconfig6. These are tools provided by KDE to modify
settings @kdeconfig. Unfortunately there is no rust crate that provides bindings
to these tools, so the plugin would have to use the Command

There was also a dbus interface that could be used to fetch keyboard layouts,
but there was no way to set them.

#subsubsection("Keyboard Limit")
XKB is a system part of the X Window System and provides an easy way to
configure keyboard layouts. On Wayland, XKB is the recommended way of handling
keyboard input as well @waylandkeyboard. The problem with XKB is that it does
not support more than four keyboard groups at the same time. A group in XKB
consists of symbols, which are a collection of character codes and a group type
that defines the type of symbols, e.g Latin letters, Cyrillic letters etc. and
make up a keyboard layout.\

In @keyboard-struct-limitation the structure of the XKBState can be seen. The
structure is 16 bits long and contain various informations about the active
state of a keyboard (or keyboards). Because KEYMASK and BUTMASK are not
responsible for saving keyboard layouts and are therefore not explained further.
The important parts are bits 13 and 14 as they keyboard group. It is not
possible to just increase that number because the XKBState field is only 16 bits
long and there is no bits left that could be used. Any attempt to increase the
number of groups would require a change in the representation schema in XKB and
other changes that wouldn't be backwards compatible @xkblimitation.\

#align(
  center, [#figure(
      img(
        "../figures/keyboardLimitationBits.png", width: 85%, extension: "figures",
      ), caption: [XKBState structure],
    )<keyboard-struct-limitation>],
)

#subsubsection("Visualization")
In this section, the different applications are analysed. The main goal is to
keep ReSet aligned with other settings in ReSet as well as other applications
that use the GTK4 library.

#subsubsubsection("GNOME")

In @gnome-keyboard-setting the UI for the keyboard settings from GNOME control
center are shown. They use a drag-and-drop list to order the keyboard layouts
around and mark it with the six dots on the left. These grip indicators are
commonly used in software as well as in physical products to indicate that
something is draggable. The listed is then grouped with a title and subtitle
that explains what it is doing.\
The keyboard layout list is grouped with a title and subtitle that briefly
explains what its purpose is. Multiple of these groups are stacked vertically
and form a scrollable area.

#align(
  center, [#figure(
      img(
        "../figures/gnomeKeyboardSetting.png", width: 55%, extension: "figures",
      ), caption: [Gnome keyboard settings],
    )<gnome-keyboard-setting>],
)

New keyboard layouts can be added added with the button at the very bottom of
the list. It opens a dialog menu as seen in @gnome-add-keyboard-setting that
contains a list of every keyboard layout available in the system. After
selecting a keyboard layout, it can be added with the Add button on the top
right.

#align(
  center, [#figure(
      img(
        "../figures/gnomeAddKeyboardSetting.png", width: 55%, extension: "figures",
      ), caption: [Gnome keyboard settings],
    )<gnome-add-keyboard-setting>],
)

#subsubsubsection("KDE")
In @kde-keyboard-setting the UI for KDE system settings can be seen. The
keyboard layout list is a list that can only be modified using the few buttons
above it. It still allows the same behavior as a drag-and-drop list but is more
explicit because each feature is written out.\
The keyboard list is placed inside a border and is located in a grid-like
fashion with other settings.

#align(
  center, [#figure(
      img("../figures/kdeKeyboardSetting.png", width: 65%, extension: "figures"), caption: [KDE keyboard settings],
    )<kde-keyboard-setting>],
)

The Add button opens a new dialog as seen in @kde-add-keyboard-setting in which
users can search and insert new keyboard layouts from the list. It also has a
preview functionality that allows users to see each key mapping visually.

#align(
  center, [#figure(
      img(
        "../figures/kdeAddKeyboardSetting.png", width: 65%, extension: "figures",
      ), caption: [Gnome keyboard settings],
    )<kde-add-keyboard-setting>],
)
