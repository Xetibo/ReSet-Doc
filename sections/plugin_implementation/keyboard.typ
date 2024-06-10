#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Keyboard Plugin Implementation")

#subsubsection("Implementations")
In this section, the implementation of the keyboard plugin is discussed.

#subsubsubsection("Hyprland Implementation")
Because there is no hyprlang parser in rust, a separate file is being created
that holds the keyboard layout setting. This file has to be referenced from the
main configuration file like in @hyprconf-bind-config.

#let code = "
source=~/Documents/dotfiles/hypr/input.conf
"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "markdown")), kind: "code", supplement: "Listing", caption: [Include separate config file in hypr.conf],
    )<hyprconf-bind-config>],
)

This is because with this solution, ReSet does not need to parse its content,
but can just override the whole file each time a change is made. A string that
follows the hyprland syntax is built from the keyboard layouts in
@reset-keyboard-hypr and is written to the file.

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

In @hyprconf-input-config the contents of the input config is shown. Each
combination of same index from kb_layout and kb_variant represents a keyboard
layout.

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

ReSet has to know where the input config is located which has to be provided by
the user. This path can be provided in the local config folder of a user in a
file called Reset.toml. This file contains ReSet relevant configuration. The
user has to provide the path to the input config there like
@reset-keyboard-config-hyprland or else ReSet wouldn't know where to write the
changes to. If the file does not exist, a new one will be created.

#let code = "
[Keyboard]
path = \"/home/felix043/Documents/dotfiles/hypr/input.conf\"
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "toml")), kind: "code", supplement: "Listing", caption: [Path to input configuration in ReSet configuration],
    )<reset-keyboard-config-hyprland>],
)

#subsubsubsection("GNOME Implementation")
The first try was using dconf_rs because GSettings is a frontend API to dconf
and there was no reason to go through that indirection. In
@gnome-get-input-config the setting string was fetched using dconf which then
had to be matched using a Regex pattern. Unfortunately, it is not possible to
use it to set a new keyboard config because dconf_rs wraps the value to be set
with an apostrophe that cannot be parsed by dconf. The only solution is to use a
command to set the keyboard layouts as seen in @gnome-set-input-config.

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

Therefore dconf_rs was replaced by GIO. The advantages have already been
discussed in @GNOME. GIO provides very convenient bindings to the GSettings API.
In @gnome-gio-get-input-config the layouts are fetched, and its type is checked.
If the layout_variant is not an array of two strings an empty array will be
returned. Otherwise, a generic get function is called with type Vec\<(String,
String)\>\> to parse it into desired structure. This solution is a lot more
elegant than the Regex because it is more human-readable and better performant 
as regex processing can be slower due to its pattern matching which involves 
operations like backtracking.

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
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Set GNOME keyboard layouts],
    )<gnome-gio-get-input-config>],
)

In @gnome-gio-set-input-config the code for writing the new keyboard layouts can
be seen.

#let code = "
let variant = Variant::from(all_layouts);
let input_sources = gtk::gio::Settings::new(\"org.gnome.desktop.input-sources\");
input_sources.set(\"sources\", variant).expect(\"failed to write layouts\");
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Set GNOME keyboard layouts],
    )<gnome-gio-set-input-config>],
)

#subsubsubsection("KDE Implementation")
To read the keyboard layouts and variants in KDE, kreadconfig6 has to be used.
Unfortunately, no library provides bindings so reading and writing using rust 
commands was necessary. In @kde-get-input-config the command with all its 
arguments can be seen. Writing to the kxkbrc file works exactly the same as
writing with the only difference of adding the new keyboard layout string as an
additional argument and using kwriteconfig6.

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
into a single entry in the list marked with an arrow symbol because not
all languages have variants. An example of how this looks can be seen in
@nested-listing.\

#align(
  center, [#figure(
      img("keyboardAddLayout.png", width: 75%, extension: "figures"), caption: [Keyboard layouts with variants],
    )<nested-listing>],
)

In GNOME control setting, every keyboard layout with its variations is shown in
an alphabetically sorted list. The problem with this approach is that there are
variants for layouts that have a very different name where it's not obvious to
which layout it belongs to as seen in an example in
@comparison-reset-gnome-irish.

#align(
  center, [#figure(
      [
        #columns(2, [
          #img("keyboard-reset-irish.png", width: 100%, extension: "figures")
          #colbreak()
          #img("keyboard-gnome-irish.png", width: 100%, extension: "figures")
        ])
      ], caption: [Irish keyboard layouts comparison (ReSet left, GNOME right)],
    )<comparison-reset-gnome-irish>],
)

This feature reduces the list by a significant amount and helps the user to
narrow down the desired language first before looking more detailed at the
specific variant. Clicking on such an entry removes all other keyboard layouts
and only shows the variants for that language as seen in
@keyboard-layout-variants.

#align(
  center, [#figure(
      img("keyboardAddLayoutVariants.png", width: 80%, extension: "figures"), caption: [Keyboard layouts with variants],
    )<keyboard-layout-variants>],
)

To achieve this, a layout that has variants needs to have some code that removes
all other layouts and only shows its variants and a button to show all layouts
again. This is shown in the on-click event listener in @keyboard-show-variants.
The back button removes every element in the list and inserts all layouts back 
into the list.

#let code = "
layout_row.connect_activate(clone!(@strong keyboard_layouts, @weak list, @strong back_row => move |_| {
    // add variants to list
    for keyboard_layout in keyboard_layouts.clone() {
        let layout_row = create_layout_row(keyboard_layout.description.clone());
        list.append(&layout_row);
    }

    list.prepend(&back_row);

    let mut last_row = list.last_child();
    let mut skip = keyboard_layouts.len();

    // remove all but first
    while last_row != None {
        // if we're at top of list, prevent selecting the back button and break
        if list.first_child() == last_row {
            list.grab_focus();
            break;
        }
        // skip rows because it's a variant we want to show
        if skip > 0 {
            last_row = last_row.unwrap().prev_sibling();
            skip -= 1;
            continue;
        }
        // remove row from list
        let temp = last_row.clone().unwrap().prev_sibling();
        list.remove(&last_row.unwrap());
        last_row = temp;
    }
}));
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Code to only show variants of selected layout],
    )<keyboard-show-variants>],
)

#subsubsubsection("Highlight active layouts")
To show users that limitation visually, the first few rows are highlighted,
while the rest have system colors. This number is set depending on the desktop
environment because some don't use XKB and therefore could allow more than four
keyboard layouts. To further clarify it a subtitle for this setting group that
explains the highlight is added.\

#align(
  center, [#figure(
      img("highlightedKeyboardLayouts.png", width: 75%, extension: "figures"), caption: [First few keyboard layouts are colored differently],
    )<highlighted-keyboard-layouts>],
)

Because there are users that use many different themes, it is not possible to
hardcode a single color because it might not fit with other themes. A GTK theme
is defined in a CSS file that contains a list of key-value like pairs of names 
and a color as can be seen in @gtk-theme-definition. These can be accessed from
ReSet with an \@css-name like @keyboard-css-highlight. Because using the color
definition is bound to clash with other UI elements with the same
coloring, color expressions can be used to slightly change color without
having to hardcode it. @gtk-css

#let code = "
@define-color accent_color #a9b1d6;
@define-color accent_bg_color #a9b1d6;
@define-color accent_fg_color rgba(0, 0, 0, 0.87);
@define-color destructive_color #F28B82;
/* many more colors */
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "css")), kind: "code", supplement: "Listing", caption: [Excerpt from GTK default dark theme],
    )<gtk-theme-definition>],
)

#let code = "
row.activeLanguage {
    background-color: darker(darker(darker(@window_fg_color)));
}
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "css")), kind: "code", supplement: "Listing", caption: [Setting the highlight color],
    )<keyboard-css-highlight>],
)
