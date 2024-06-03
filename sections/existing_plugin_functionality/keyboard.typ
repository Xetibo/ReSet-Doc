#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Keyboard Plugin")

#subsubsection("Analysis of different environments")
In this section, the implementation of the keyboard plugin is discussed.

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
can be used to access the GSettings API @gsettings. dconf serves as a low-level
configuration system for gsettings that stores key-based configuration details
in a single compact binary format database @dconf.

Because gsettings is a layer for dconf, the keyboard plugin directly uses dconf
for setting the keyboard layouts. Combined with the dconf crate, which provides
Rust bindings to dconf, the plugin can easily read the keyboard layouts
@dconf_rs. This returns a string that needs to be parsed to get the keyboard
layout and variant, which can be done with a simple regex.

#subsubsubsection("KDE")
KDE stores its keyboard configurations in a file called kxkbrc. This text file
is located in the config folder of the user and can be read using kreadconfig6
and written to using kwriteconfig6. These are tools provided by KDE to modify
settings @kdeconfig. Unfortunately there is no Rust crate that provides bindings
to these tools, so the plugin would have to use the Command 

There was also a dbus interface that could be used to fetch keyboard layouts,
but there was no way to set them.  

#subsubsection("Keyboard Limit")
XKB is a system part of the X Window System and provides an easy way to
configure keyboard layouts. On Wayland, XKB is the recommended way of handling
keyboard input as well @waylandkeyboard. The problem with XKB is that it doesn't
support more than four keyboard groups at the same time. A group in XKB consists
of symbols, which are a collection of character codes and a group type that
defines the type of symbols, e.g Latin letters, Cyrillic letters etc. and make
up a keyboard layout. It is not possible to just increase that number because
the XKBState field is only 16 bits long and uses bits 13 and 14 to report the
keyboard group. Any attempt to increase the number of groups would require a
change in the representation schema in XKB and other changes that wouldn't be
backwards compatible @xkblimitation.\

To show users that limitation visually, the first few rows are highlighted,
while the rest have system colors. This number is set depending on the desktop
environment because some don't use XKB and therefore could allow more than four
keyboard layouts.

#align(
  center, [#figure(
      img("highlightedKeyboardLayouts.png", width: 75%, extension: "figures"), caption: [First four keyboard layouts are colored differently],
    )<highlighted-keyboard-layouts>],
)
