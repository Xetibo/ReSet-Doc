#import "../../../templates/utils.typ": *
#lsp_placate()

#subsection("Keyboard Plugin")
In this section, the implementation of the keyboard plugin is discussed.

#subsubsubsection("Hyprland Implementation")
The keyboard layouts in Hyprland are stored in a hypr.conf file, which is 
basically a configuration file and can be modified using multiple ways.

One way is to use Hyprctl, a command-line tool that can be used to modify
the setting. The problem with it is that the settings set by Hyprctl are
not persistent. That means that those changes disappear after a restart.

The other method is to write it directly into the hypr.conf file. 
Because the configuration file uses a custom configuration language called 
hyprlang, it's very hard to make changes in a specific area there because 
currently no parser exists for it. The solution to this is that the user 
is required to create a new configuration file and link it from the hypr.conf.

#let code = "
source=~/Documents/dotfiles/hypr/input.conf
"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "markdown")), 
      kind: "code", 
      supplement: "Listing", 
      caption: [Monitor feature flag struct],
    )<hyprconf-bind-config>],
)

ReSet can then easily override the whole file each time a change is made, 
because it only has to build a string together and  doesn't require an 
implementation of a parser.

#let code = "
let mut layout_string = String::new();
let mut variant_string = String::new();
for x in layouts.iter() {
    layout_string += &x.name;
    layout_string += \", \";
    if let Some(var) = &x.variant {
        variant_string += &var;
    }
    variant_string += \", \";
};

layout_string = layout_string.trim_end_matches(\", \").to_string();
variant_string = variant_string.trim_end_matches(\", \").to_string();

let string = format!(\"input {{\n    kb_layout={}\n    kb_variant={}\n}}\", layout_string, variant_string);

input_config.set_len(0).expect(\"Failed to truncate file\");
input_config.write_all(string.as_bytes()).expect(\"Failed to write to file\");
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), 
      kind: "code", 
      supplement: "Listing", 
      caption: [Monitor feature flag struct],
    )<reset-keyboard-hypr>],
)

#let code = "
input {
    kb_layout=ch, jp, gb, fi
    kb_variant=, , , winkeys
}
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "markdown")), 
      kind: "code", 
      supplement: "Listing", 
      caption: [Monitor feature flag struct],
    )<hyprconf-input-config>],
)

The user has to put the path to the input configuration file in the ReSet
config, else ReSet wouldn't know where to write the changes to.

#let code = "
[Keyboard]
path = \"/home/felix043/Documents/dotfiles/hypr/input.conf\"
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "toml")), 
      kind: "code", 
      supplement: "Listing", 
      caption: [Monitor feature flag struct],
    )<reset-keyboard-config-hyprland>],
)

#subsubsubsection("GNOME Implementation")
In GNOME, it is possible to change keyboard layouts with gsettings or 
dconf. There are other tools like gconf, but they are replaced by dconf.
Gsettings is a high-level configuration system intended to be used in 
the command line as front end to dconf. dconf serves as a low-level 
configuration system for gsettings that stores key-based configuration 
details in a single compact binary format database. 

Because gsettings is a layer for dconf, the keyboard plugin directly 
uses dconf for setting the keyboard layouts.
// todo why did we use dconf

#subsubsubsection("KDE Implementation")
KDE stores its keyboard configurations in a file called kxkbrc. This
text file is located in the config folder of the user and can be 
read from using kreadconfig6 and written to using kwriteconfig6. Both 
are part of KConfig, a library provided by KDE to read and write 
configuration files.

There was also a dbus interface which could be used to fetch keyboard 
layouts, but there was no way to set them. Therefore, the implementation
was done using KConfig.