#import "../../../templates/utils.typ": *
#lsp_placate()

#subsubsection("Keyboard Plugin")
#subsubsubsection("Implementations")
In this section, the implementation of the keyboard plugin is discussed.

#subsubsubsubsection("Hyprland Implementation")
The keyboard layouts in Hyprland are stored in a hypr.conf file, which is a
configuration file and can be modified using multiple ways.

One way is to use Hyprctl, a command-line tool that can be used to modify the
setting. The problem with it is that the settings set by Hyprctl are not
persistent. That means that those changes disappear after a restart @hyprctl.

The other method is to write it directly into the hypr.conf file. Because the
configuration file uses a custom configuration language called hyprlang, it's
very hard to make changes in a specific area there because currently no parser
exists for it. The solution to this is that the user is required to create a new
configuration file and link it from the hypr.conf.

#let code = "
source=~/Documents/dotfiles/hypr/input.conf
"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "markdown")), kind: "code", supplement: "Listing", caption: [Include separate config file],
    )<hyprconf-bind-config>],
)

ReSet can then easily override the whole file each time a change is made,
because it only has to build a string together and does not require an
implementation of a parser which would have been out of scope anyway.

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
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Convert keyboard layouts to string],
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
      sourcecode(raw(code, lang: "markdown")), kind: "code", supplement: "Listing", caption: [Input configuration],
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
      sourcecode(raw(code, lang: "toml")), kind: "code", supplement: "Listing", caption: [Path to input configuration in ReSet configuration],
    )<reset-keyboard-config-hyprland>],
)

#subsubsubsubsection("GNOME Implementation")
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

#let code = "
let result = dconf_rs::get_string(\"/org/gnome/desktop/input-sources/sources\");
// has format of: [('xkb', 'ch'), ('xkb', 'us'), ('xkb', 'ara+azerty')]

let pattern = Regex::new(r\"[a-zA-Z0-9_+-]+\").unwrap();
let matches = pattern.captures_iter(layouts.as_str())
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Parsing GNOME keyboard layouts],
    )<gnome-get-input-config>],
)

Unfortunately, it is not possible to use dconf_rs to set a new keyboard config
because dconf_rs wraps the value to be set with an apostrophe that cannot be
parsed by dconf. The only solution is to use a command to set the keyboard
layouts.

#let code = "
Command::new(\"dconf\")
  .arg(\"write\")
  .arg(\"/org/gnome/desktop/input-sources/sources\")
  .arg(all_layouts)
  .status()
  .expect(\"failed to execute command\");
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Set GNOME keyboard layouts],
    )<gnome-set-input-config>],
)

#subsubsubsubsection("KDE Implementation")
KDE stores its keyboard configurations in a file called kxkbrc. This text file
is located in the config folder of the user and can be read using kreadconfig6
and written to using kwriteconfig6. These are tools provided by KDE to modify
settings @kdeconfig.

There was also a dbus interface that could be used to fetch keyboard layouts,
but there was no way to set them. Therefore, the implementation was done using
kreadconfig and kwriteconfig.

#let code = "
let output = Command::new(\"kreadconfig6\")
  .arg(\"--file\")
  .arg(\"kxkbrc\")
  .arg(\"--group\")
  .arg(\"Layout\")
  .arg(\"--key\")
  .arg(\"LayoutList\")
  .output()
  .expect(\"Failed to get saved layouts\");
let kb_layout = parse_setting(output);

let output = Command::new(\"kreadconfig6\")
  .arg(\"--file\")
  .arg(\"kxkbrc\")
  .arg(\"--group\")
  .arg(\"Layout\")
  .arg(\"--key\")
  .arg(\"VariantList\")
  .output()
  .expect(\"Failed to get saved layouts\");
let kb_variant = parse_setting(output);
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Read KDE keyboard layouts],
    )<kde-get-input-config>],
)

An issue with these is that the versions are part of the command. Currently, the
newest version is kreadconfig6 and kwriteconfig6 and have deprecated version 5
for the most part. This also means that if version 7 is being released, the
command needs to be adjusted so that it works for both versions while version 6
is not deprecated.

#subsubsubsubsection("Keyboard Limit")
XKB is a system part of the X Window System and provides an easy way to
configure keyboard layouts. On Wayland, XKB is the recommended way of handling
keyboard input as well @waylandkeyboard. The problem with XKB is that it does
not support more than four keyboard groups at the same time. A group in XKB
consists of symbols, which are a collection of character codes and a group type
that defines the type of symbols, e.g Latin letters, Cyrillic letters etc. and
make up a keyboard layout. It is not possible to just increase that number
because the XKBState field is only 16 bits long and uses bits 13 and 14 to
report the keyboard group. Any attempt to increase the number of groups would
require a change in the representation schema in XKB and other changes that
wouldn't be backwards compatible @xkblimitation.\

To show users that limitation visually, the first few rows are highlighted,
while the rest have system colors. This number is set depending on the desktop
environment because some don't use XKB and therefore could allow more than four
keyboard layouts.

#align(
  center, [#figure(
      img("highlightedKeyboardLayouts.png", width: 75%, extension: "figures"), caption: [First four keyboard layouts are colored differently],
    )<highlighted-keyboard-layouts>],
)

#subsubsubsubsection("Nested listing")
A quality-of-life feature to makes adding keyboard layouts easier is the
addition of nested listing. There are many keyboard variants for the same
layout, for example, German (US), German (Dvorak) etc. which can grouped
together into single entry in the list marked with an arrow symbol because not
all languages have variants.

#align(
  center, [#figure(
      img("keyboardAddLayout.png", width: 75%, extension: "figures"), caption: [Keyboard layouts with variants],
    )<nested-listing>],
)

This feature reduces the list by a significant amount and helps the user to
narrow down the desired language first before looking more detailed for the
specific variant. Clicking on such an entry removes all other keyboard layouts
and only shows the variants for that language.

#align(
  center, [#figure(
      img("keyboardAddLayoutVariants.png", width: 80%, extension: "figures"), caption: [Keyboard layouts with variants],
    )<keyboard-layout-variants>],
)
