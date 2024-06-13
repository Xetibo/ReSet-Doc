#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Monitor Plugin")
In this section, the implementations of monitor configurations are discussed.

For the monitor plugin, the following environments are considered: KDE, GNOME,
wlroots-based compositors and KWin-based compositors. This selection covers a
large section of the Wayland compositors except the cosmic desktop, which will
be released after this thesis. @cosmic-release

When discussing implementations from other environments, they were tested on an
EndeavourOS virtual machine with their respective dark themes applied.
@endeavourOS

#subsubsection("Environment Differences")
The introduction of Wayland complicates the fetching of the data needed for
configuring monitors. This is because many Wayland environments have their
custom implementation of applying monitor configuration and will hence not be
compatible with each other. For example, the wlroots implementation of applying
a monitor configuration is defined by the Wayland protocol extension
zwlr_output_manager_v1. @wlr-output-management As the name suggests, this is
made solely for environments using wlroots as their library. Similarly, KDE also
offers its protocol, while GNOME chose the DBus route, providing a handy
DisplayConfig endpoint. @kde-output-management @mutter-display-config

For the X11 protocol, there is only one endpoint for fetching, as close to every
environment uses the same display server (Xorg) in order to implement their
stack.

#pagebreak()

#subsubsubsection("Hyprland Implementation")
Hyprland's monitors can be configured by three different approaches. The first
would be to just use the inbuilt hyprctl tool, which provides a monitor command
that can either display monitors in a human-readable way or output it directly
to JSON. For this, it would be necessary to spawn the tool within the plugin and
convert the output with serde, a serialization/deserialization framework for
Rust. In @Hyprland-Monitor-Conversion, the conversion from JSON to the generic
monitor struct is visualized.

#let code = "
// The tool is always installed for hyprland.
pub fn hy_get_monitor_information() -> Vec<Monitor> {
    let mut monitors = Vec::new();
    let json_string = String::from_utf8(get_json());
    if let Ok(json_string) = json_string {
        let hypr_monitors: Result<Vec<HyprMonitor>, _> =
          serde_json::from_str(&json_string);
        // omitted error handling
        for monitor in hypr_monitors.unwrap() {
            let monitor = monitor.convert_to_regular_monitor();
            monitors.push(monitor);
        }
    }
    // omitted error handling

    monitors
}
";
#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Hyprland monitor conversion],
    )<Hyprland-Monitor-Conversion>],
)

The second approach is to directly use Hyprland's Unix sockets, which are fully
replicated in hyprctl, meaning both solutions will lead to the same outcome. For
sockets, the same conversion as with hyprctl would be required.

The third approach is to use the zwlr_output_manager_v1 protocol in order to
apply the configuration. @wlr-output-management Hyprland uses a fork of wlroots
as a foundation library. A benefit with this would be the automatic support for
any other environment that supports this protocol, the downside is that this
protocol might not fully replicate Hyprland's features in the future, as this
protocol specifically targets wlroots.

#subsubsubsection("Wlroots Implementation")
As mentioned in @HyprlandImplementation, the wlroots implementation can only be
implemented via Wayland protocols and is as such also limited to the used
protocol. Hence, the wlroots implementation does not offer persistent storing of
monitor configurations, instead only offering the application of a specific 
configuration.

However, unlike the first and second Hyprland implementations, it is compositor 
independent and will work as long as the zwlr_output_manager_v1 protocol is
implemented.

In order to connect to a compositor using Wayland protocols, a wayland-client is
used. This client would then connect to the "server" which is the compositor.
Wayland-client implementations are provided either directly by the Wayland
project as a C library or by third parties such as smithay which implements the
client and server part for Rust. @wayland-repo @wayland-rs

In @wayland-architecture, the base Wayland architecture is visualized.

#figure(
  img("wayland_architecture.svg", width: 100%, extension: "files"), caption: [Wayland architecture],
)<wayland-architecture>

As such, it is now possible to create a client for a Wayland server and generate
requests for it. The server will then respond with events that the client can
process and interact with.

In @Wayland-Connection, an example client that requests all implemented protocols 
from the Wayland compositor is visualized.

#let code = "
struct AppData(pub String);
impl Dispatch<wl_registry::WlRegistry, ()> for AppData {
    fn event(
        obj: &mut Self,
        registry: &wl_registry::WlRegistry,
        event: wl_registry::Event,
        data: &(),
        conn: &Connection,
        handle: &QueueHandle<AppData>,
    ) {
        if let wl_registry::Event::Global { interface, .. } = event {
          // print the protocol name
          println!(\"{}\", &interface);
        }
    }
}
pub fn get_wl_backend() -> String {
    let backend = String::from(\"None\");
    let mut data = AppData(backend);
    // connection to wayland server
    let conn = Connection::connect_to_env().unwrap();
    let display = conn.display();
    // queue to handle events
    let mut queue = conn.new_event_queue();
    let handle = queue.handle();
    // creates an event for each wayland protocol available
    display.get_registry(&handle, ());
    queue.blocking_dispatch(&mut data).unwrap();
    data.0
}
";
#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Example Wayland connection with Smithay],
    )<Wayland-Connection>],
)

// In @wayland_client_protocols a section of the output of @Wayland-Connection on
// Hyprland is shown.
//
// #align(
//   center, [#figure(
//       img("wayland-protocols.png", width: 40%, extension: "figures"), caption: [Screenshot of a portion of available wayland protocols on Hyprland],
//     )<wayland_client_protocols>],
// )

#pagebreak()

#subsubsubsection("KDE Implementation")
Similar to Hyprland, KDE offers both a custom tool and a Wayland protocol to
handle monitor configuration.

Also like with Hyprland, both solutions were implemented, for KDE the reason is
simply to include support for both the X11 implementation of KDE and the Wayland
version. If this plugin were to target the KWin protocol exclusively, then X11
support would not be included and would have to be implemented separately.

The protocol variant requires the implementation of two protocols that will
interact with each other. The first is the kde_output_device_v2 protocol, which
defines the data structure responsible for holding the necessary data for each
monitor. This protocol closely resembles the Wayland core protocol "wl_output"
which offers a way to fetch the currently active monitors with all their data.
The only noticeable difference is the lack of data for potential changes a user
can make. In other words, it only offers data about what is currently active,
including refresh rate, resolution and more, but does not provide any data about
what other refresh rates or resolutions, etc. the monitor supports.
@kde-output-device-v2 @wl-output

The combinations of the kde_output_device_v2 protocol and the KDE output
management v2 protocol enables the same functionality as with the implementation
of wlroots in @WlrootsImplementation.

The KDE environment also offers an optional monitor module which provides the
Kscreen-doctor tool. This tool allows for a quick fetch of data that can be
output via JSON and then deserialized into a monitor data structure.
@kscreen-doctor

#subsubsubsection("GNOME Implementation")
GNOME separates hardware monitors from logical monitors. The logical monitors
represent the representation of the real-world monitor within GNOME with the x
and y coordinates of the position added. @mutter-display-config These
coordinates will define which monitor will be considered "on the left", or "on
the right" within GNOME.

The conversion for GNOME displays is trivial other than the challenges with
experimental features. As of GNOME 46, features such as fractional scaling and
variable refresh rates are still experimental features within GNOME. In order to
still accommodate the features for GNOME users, ReSet has to check for the
availability of these features not only within the monitor capabilities but also
within the GNOME configuration. GNOME stores its configuration within a custom
binary blob file which stores key/value pairs. ReSet already uses GTK, which can
also read DConf variables, meaning there is no additional dependency for ReSet.

In @Fractional-Scale-Gnome the value for fractional scaling is read via
DConf.
#let code = "
fn get_fractional_scale_support() -> bool {
    let settings = gtk::gio::Settings::new(\"org.gnome.mutter\");
    let features = settings.strv(\"experimental-features\");
    for value in features {
        if value == \"scale-monitor-framebuffer\" {
            return true;
        }
    }
    false
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [GNOME fetching of Fractional Scale support],
    )<Fractional-Scale-Gnome>],
)

#subsubsection("Visualization")
For the visual representation, ReSet aims to be aligned with other configuration
tools within the Linux ecosystem in order to provide users with a seamless
transition. Notable for this visualization is the use of drag-and-drop for
monitor positioning. This paradigm allows users to quickly place monitors on
their preferred side or height.

In @kde-monitor, the KDE variant of the monitor configuration is shown.

#align(
  center, [#figure(
      img("kde-monitor.png", width: 70%, extension: "figures"), caption: [Screenshot of the monitor configuration within KDE],
    )<kde-monitor>],
)

// TODO: Comment on KDEs implementation
KDE opted for a per-monitor paradigm, meaning settings are shown for the current
monitor, with global settings being separated by a visual separator. The indication 
of which monitor is currently selected is shown by a blue indicator while other
monitors are uncolored. The selected color is suitable for color blindness as
different shades of blue are less susceptible to color blindness. People with
monochromatic sight (full colorblindness) will also still be able to tell the
difference based on shade, making this an optimal color defined in figure 16
Colorblind barrier-free color pallet by Color Universal Design (CUD).
@color-universal-design @color-blindness @data-visualization-with-flying-colors

//https://en.wikipedia.org/wiki/Color_blindness

In @gnome-monitor, the GNOME variant of the monitor configuration is shown.
#align(
  center, [#figure(
      img("gnome-monitor.png", width: 70%, extension: "figures"), caption: [Screenshot of the monitor configuration within GNOME],
    )<gnome-monitor>],
)

Visible for GNOMEs implementation is the lack of direct configuration with
multiple monitors. Instead, GNOME relies on submenus in order to change values
such as resolution or refresh rate. At the same time, monitor independent
settings like primary monitor or joining/mirroring displays are also shown in
the overall menu. Noteworthy is also the lack of an apply or reset button when
no actions have been taken. This is in contrast to the KDE implementation in
@kde-monitor, which disables the buttons instead while still showing them
visually. Another difference is the placing of the buttons when visible, KDE
opted to show the reset and apply buttons at the bottom, while GNOME shows them
at the top.

// TODO: Comment on GNOMEs implementation
// TODO: show GNOMES apply and reset buttons
//
// TODO: windows?
//This is also in contrast to operating systems like Microsoft Windows

#pagebreak()
#subsubsubsection("Gaps in Configuration")
While testing for environment differences, a significant difference between 
wlroots-based compositors to both KDE and GNOME was detected. Using a compositor
like Hyprland, it is possible to create gaps between monitors to disallow direct
mouse movement from one monitor to another. However, in both KDE and GNOME, a
configuration with gaps results in an error which makes the configuration not
applicable.

In @kde-gaps and @gnome-gaps, the error messages for gaps in GNOME and KDE are
visualized.

#align(
  center, [#figure(
      img("kde-gaps.png", width: 90%, extension: "figures"), caption: [Screenshot of the gaps error within KDE],
    )<kde-gaps>],
)
#align(
  center, [#figure(
      img("gnome-gaps.png", width: 70%, extension: "figures"), caption: [Screenshot of the gaps error within GNOME],
    )<gnome-gaps>],
)

#pagebreak()
