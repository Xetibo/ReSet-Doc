#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Keyboard Plugin Implementation")

#subsubsection("Implementations")
In this section, the implementation of the keyboard plugin is discussed.

#subsubsubsection("Hyprland Implementation")
Because there is no hyprlang parser in rust, a separate file is being 
created that holds the keyboard layout setting. This file has to be 
referenced from the main configuration file like in @hyprconf-bind-config.

#let code = "
source=~/Documents/dotfiles/hypr/input.conf
"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "markdown")), kind: "code", supplement: "Listing", 
      caption: [Include separate config file in hypr.conf],
    )<hyprconf-bind-config>],
)

This is because with this solution, ReSet does not need to parse its content, 
but can just override the whole file each time a change is made. A string that
follows the hyprland syntax is built from the keyboard layouts in @reset-keyboard-hypr 
and is written to the file.

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
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", 
      caption: [Convert keyboard layouts to string],
    )<reset-keyboard-hypr>],
)

In @hyprconf-input-config the contents of the input config is shown. Each combination 
of same index from kb_layout and kb_variant represents a keyboard layout.

#let code = "
input {
    kb_layout=ch, jp, gb, fi
    kb_variant=, , , winkeys
}
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "markdown")), kind: "code", supplement: "Listing", 
      caption: [Input configuration],
    )<hyprconf-input-config>],
)

ReSet has to know where the input config is located which has to be provided by the user.
This path can be provided in the local config folder of a user in a file called Reset.toml.
This file contains ReSet relevant configuration. The user has to provide the path to the input
config there like @reset-keyboard-config-hyprland or else ReSet wouldn't know where to write 
the changes to. If the file does not exist, a new one will be created.

#let code = "
[Keyboard]
path = \"/home/felix043/Documents/dotfiles/hypr/input.conf\"
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "toml")), kind: "code", supplement: "Listing", 
      caption: [Path to input configuration in ReSet configuration],
    )<reset-keyboard-config-hyprland>],
)

#subsubsubsection("GNOME Implementation")
The first try was using dconf_rs because GSettings is a frontend API to dconf and 
there was no reason to go through that indirection. In @gnome-get-input-config the
setting string was fetched using dconf which then had to be matched using a Regex
pattern. Unfortunately, it is not possible to use it to set a new keyboard config 
because dconf_rs wraps the value to be set with an apostrophe that cannot be parsed 
by dconf. The only solution is to use a command to set the keyboard layouts as seen 
in @gnome-set-input-config.

#let code = "
let result = dconf_rs::get_string(\"/org/gnome/desktop/input-sources/sources\");
// has format of: [('xkb', 'ch'), ('xkb', 'us'), ('xkb', 'ara+azerty')]

let pattern = Regex::new(r\"[a-zA-Z0-9_+-]+\").unwrap();
let matches = pattern.captures_iter(layouts.as_str())
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", 
      caption: [Parsing GNOME keyboard layouts],
    )<gnome-get-input-config>],
)

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
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", 
      caption: [Set GNOME keyboard layouts],
    )<gnome-set-input-config>],
)

// todo write about how gio was used
Therefore dconf_rs was replaced by gio. The advantages have already been discussed
in @GNOME. Gio provides very convenient bindings to the GSettings API. In 
@gnome-gio-get-input-config the layouts are fetched and its type is checked. If the 
layout_variant isn't an array of two strings an empty array will be returned. Otherwise
a generic get function is called with type Vec<(String, String)>> to parse it into 
desired structure. This solution is a lot more elegant than the Regex because it is more 
human readable and better performant wise as regex processing can be slower due to its
pattern matching which involves operations like backtracking.

#let code = "
let input_sources = gtk::gio::Settings::new(\"org.gnome.desktop.input-sources\");
let layout_variant = input_sources.value(\"sources\");

if layout_variant.type_() != VariantType::new(\"a(ss)\").unwrap() {
  return kb;
}

let layouts = layout_variant.get::<Vec<(String, String)>>().unwrap();
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", 
      caption: [Set GNOME keyboard layouts],
    )<gnome-gio-get-input-config>],
)

In @gnome-gio-set-input-config the code for writing the new keyboard layouts can be seen.

#let code = "
let variant = Variant::from(all_layouts);
let input_sources = gtk::gio::Settings::new(\"org.gnome.desktop.input-sources\");
input_sources.set(\"sources\", variant).expect(\"failed to write layouts\");
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", 
      caption: [Set GNOME keyboard layouts],
    )<gnome-gio-set-input-config>],
)

#subsubsubsection("KDE Implementation")

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


#subsubsection("Nested listing")
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


#subsubsubsection("Testing")
// todo


// moved from existing plugin fucntionality 
// todo somehow integrate this somewhere
//To show users that limitation visually, the first few rows are highlighted,
//while the rest have system colors. This number is set depending on the desktop
//environment because some don't use XKB and therefore could allow more than four
//keyboard layouts.

// #align(
//  center, [#figure(
//      img("highlightedKeyboardLayouts.png", width: 75%, extension: "figures"), 
//      caption: [First four keyboard layouts are colored differently],
//    )<highlighted-keyboard-layouts>],
//)