#import "../../../templates/utils.typ": *
#lsp_placate()

#subsection("Monitor Plugin")
In this section, the implementation of the monitor plugin is discussed.

#subsubsection("Environment Differences")
The introduction of Wayland complicates the fetching of the data needed for
configuring monitors. This is due to the fact that many wayland environments
have their own custom implementation of applying monitor configuration and will
hence not be compatible with each other. For example, the wlroots implementation
of applying a monitor configuration is defined by the wayland protocol extension
zwlr_output_manager_v1. As the name suggests, this is made solely for
environments using wlroots as their library. Similarly, KDE also offers their
own protocol, while GNOME opted to go with the DBus route, providing a handy
DisplayConfig endpoint.

For the X11 protocol, there is only one endpoint for fetching, as close to every
environment uses the same display server (xorg) in order to implement their
stack.

In order to facilitate the usage of all the different fetching methods and
different structures, ReSet needs a way to convert the fetched structures to
something universal in order to provide a consistent, API compatible structure
as a DBus endpoint. Just as with ReSet itself, the goal of this plugin is to
offer both a DBus endpoint for functionality, and a user interface frontend for
human interaction. Should a user not be satisfied with the provided interface,
they can just use the endpoint to create their own.

#subsubsubsection("Hyprland Implementation")
Hyprlands monitors can be configured by three different approaches. The first
would be to just use the inbuilt hyprctl tool, which provides a monitor command
that can either display monitors in a human readable way, or output it directly
to json. For this it would be necessary to spawn the tool within the plugin and
convert the output with serde, a serializion/deserialization framework for Rust.

The second approach is to directly use Hyprlands unix sockets, the first of
which is fully replicated in hyprctl. For sockets the same conversion as with
hyprctl would be required.

The third approach is to use the zwlr_output_manager_v1 protocol in order to
apply the configuration. Hyprland uses a fork of wlroots as a foundation
library. A benefit with this would be the automatic support for any other
environment that supports this protocol, the downside is that should this
protocol might not fully replicate Hyprlands features in the future, as this
proctol specifically targets wlroots.

#subsubsubsection("KDE Implementation")

#subsubsubsection("GNOME Implementation")
GNOME separates hardware monitors from logical monitors. The logical monitors
represent the representation of the real world monitor within GNOME with the x
and y coordinates of the position added. These coordinates will define which
monitor will be considered "on the left", or "on the right" within GNOME.

The conversion for GNOME displays is trivial other than the challenges with
experimental features. As of GNOME 46, features such as fractional scaling and
variable refresh rates are still experimental features within GNOME. In order to
still accomodate the features for GNOME users, ReSet has to check for the
availability of these features not only within the monitor capababilities, but
also within the GNOME configuration. GNOME stores its configuration within a
custom binary blob file which stores key/value pairs. ReSet already uses gtk,
which can also read dconf variables, meaning there is no additional dependency
for ReSet.

In listing @Fractional-Scale-Gnome the value for fractional scaling is read via
dconf.
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
}
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [GNOME fetching of Fractional Scale support],
    )<Fractional-Scale-Gnome>],
)

#subsubsubsection("Display Struct")
In listing @Display-Struct the fields of the display struct used for the DBus
connection and the user interface is visualized.
#let code = "
#[repr(C)]
#[derive(Debug, Clone, Default)]
pub struct Monitor {
    pub id: u32,
    pub enabled: bool,
    pub name: String,
    pub make: String,
    pub model: String,
    pub serial: String,
    pub refresh_rate: u32,
    pub scale: f64,
    pub transform: u32,
    pub vrr: bool,
    pub primary: bool,
    pub offset: Offset,
    pub size: Size,
    pub drag_information: DragInformation,
    pub mode: String,
    pub available_modes: Vec<AvailableMode>,
    pub features: MonitorFeatures,
}
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Display struct],
    )<Display-Struct>],
)

#subsubsection("Visualization")
For the visual representation, ReSet is aligned with other configuration tools
within the Linux ecosystem in order to provide users with a seamless transition.
Notable for this visualization is the use of drag-and-drop for monitor
positioning. This paradigm allows users to quickly place monitors on their
preferred side, or even introduce gaps between monitors in order to prevent the
mouse from automatically crossing the screen.

In figure @kde-monitor, the KDE variant of the monitor configuration is shown.

#align(
  center, [#figure(
      img("kde-monitor.png", width: 70%, extension: "figures"), caption: [Screenshot of the monitor configuration within KDE],
    )<kde-monitor>],
)

// TODO: Comment on KDEs implementation

In figure @gnome-monitor, the GNOME variant of the monitor configuration is
shown.
#align(
  center, [#figure(
      img("gnome-monitor.png", width: 70%, extension: "figures"), caption: [Screenshot of the monitor configuration within GNOME],
    )<gnome-monitor>],
)

// TODO: Comment on GNOMEs implementation
//

#subsubsection("Fractional Scaling")
Fractional scaling is implemented according to the fractional-scale-v1 wayland
protocol. This protocol defines how scaling values will be interpreted by the
environment. The specification defines that supported scales must be of a
fraction with a denominator of 120. In other words, incrementing a scaling value
would mean multiplying the base value with 120, then proceeding to increase or
decrease this number before dividing by 120 again. The result will be a new
scaling fraction within the constraints of the protocol.

#align(center, [In figure @fraction-example, an example is visualized.])

#align(
  left, [#figure([
      #text(fill: maroon, [
        #v(10pt)
        $1.00 * 120 = 120$\
        $120 + 6 = 126$\
        $126 / 120 = 1.066666... $
        #v(10pt)
      ])
    ], caption: [Example for a valid fractional scale])<fraction-example>],
)

For fractional scaling, there is another requirement that a user selected scale
must adhere to. This requirement defines that a chosen scale must be a divider
for both the width and the height of the resolution. In other words, the
division must result in a full integer and may not leave any fractions. Using
scaling with non integer resolutions would mean slightly different aspect ratios
for every scale, which creates an inconsistent user experience.

The challenges with this approach is that a user may no longer enter any random
number as a scale. ReSet would either need to provide a check for every entered
scale or provide a range of valid scales to choose from. Existing solutions such
as GNOME and KDE resorted to using a selection of scales by dropdown and slider
respectively.

In figure @scale-adjustment-kg the options from KDE and GNOME are visualized.
#align(
  center, [#figure([
      #columns(2, [
        #img("gnome-scaling.png", width: 100%, extension: "figures")
        #colbreak()
        #v(40pt)
        #img("kde-scaling.png", width: 80%, extension: "figures")
      ])
    ], caption: [Screenshot of GNOME and KDE scaling])<scale-adjustment-kg>],
)

The GNOME variant offers a simple dropdown with a percentage value, without any
arbitrary scale. This ensures the user cannot under any circumstance enter an
invalid scale, removing a potential error. KDE offers both a slider which snaps
to predefined percentages, while also offering a user input for arbitrary
percentages. Noteworthy is that the user input automatically changes to a
supported value when applying the configuration. In figure @scale-adjustment-kg
the scaling was adjusted to 132% up from 130%, in this case the apply button is
disabled as 132% is not a possible scale and the nearest possible scale (130%)
is already applied.

As ReSet offers scaling for multiple environments, the plugin should also
support arbitrary scales depending on the environment. For ReSet, the
implementation was handled with a libadwaita spinrow, this widget provides both
arbitrary user input and a increment and decrement button. As ReSet implements
arbitrary scaling, it would also require a check for valid scales with proper
user feedback. The chosen method was to simply snap to the closest possible
valid scale and providing an error banner if no scale can be found.

in @search-nearest-scale, the body of the search_nearest_scale function within
the plugin is visualized.

#let code = "
// reverse x for the second run
let reverse_scale = if reverse { -1.0 } else { 1.0 };
for x in 0..amount {
    // increment here does not equal to increment of 1, but 1/120 of an increment
    // specified at: https://wayland.app/protocols/fractional-scale-v1
    let scale_move = if direction {
        (*search_scale + (x as f64) * reverse_scale) / 120.0
    } else {
        (*search_scale - (x as f64) * reverse_scale) / 120.0
    };

    let maybe_move_x = monitor.size.0 as f64 / scale_move;
    let maybe_move_y = monitor.size.1 as f64 / scale_move;
    if maybe_move_x == maybe_move_x.round()
        && maybe_move_y == maybe_move_y.round()
        && scale_move != monitor.scale
    {
        *search_scale = scale_move;
        *found = true;
        break;
    }
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Search nearest scale function],
    )<search-nearest-scale>],
)

#subsubsection("Drag-and-Drop")
A common configuration is the arrangement of monitors. A user might have a
physical setup where the leftmost monitor is actually considered the second
monitor within the operating system/environment. This requires the user to
either re-configure the physical cable arrangement, or preferably, just drag the
monitor to the correct position with a user interface.

GTK does not offer a direct way to draw arbitrary shapes, however it does offer
cairo integration, which is a low level drawing framework that can be used to
draw pixels onto a GTK drawingarea.

In order to both draw the shapes and calculate the eventual user offsets, a
coordinate system is required. For cairo this is a topleft to bottomright
system. This means that x increases towards the right and y increases towards
bottom.

In figure monitor-axis, the monitor axis is visualized.
#align(
  center, [#figure(
      img("monitor-axis.png", width: 70%, extension: "figures"), caption: [Visualization of the monitor coordinate system],
    )<monitor-axis>],
)

For a simple drawing of the monitor, this coordinate system would be trivial,
however, it is important to understand it in detail when providing drag-and-drop
operations, which have to constantly apply transforms to these shapes. At the
same time, any potential monitor overlaps have to be handled, as well as
providing snapping functionality in order to auto align monitors.

Intersections can be seen by two conditions per axis. If both axis have at least
one condition evaluated to false, then an overlap has occurred. In listing
@conditions and figure @overlap the conditions and an example overlap are
visualized.

#let code = "
pub fn intersect_horizontal(&self, offset_x: i32, width: i32) -> bool {
    // current monitor left side is right of other right
    let left = self.border_offset_x + self.offset.0 >= offset_x + width;
    // current monitor right is left of other left
    let right =
        self.border_offset_x + self.offset.0 + self.width
            <= offset_x;
    !left && !right
}

pub fn intersect_vertical(&self, offset_y: i32, height: i32) -> bool {
    // current monitor bottom is higher than other top
    let bottom = self.border_offset_y + self.offset.1 >= offset_y + height;
    // current monitor top is lower than other bottom
    let top =
        self.border_offset_y + self.offset.1 + self.height
            <= offset_y;
    !bottom && !top
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Simplified implemented overlap conditions],
    )<conditions>],
)

#align(
  center, [#figure(
      [
        #img("monitor-overlap.png", width: 50%, extension: "figures")
        "Monitor 2" starts at x coordinate 50 which is before the endpoint of "Monitor
        2", \
        this marks the condition left of the function intersect_horizontal as false.\
        "Monitor 2" starts at y coordinate 50 which is before the endpoint of "Monitor
        2",\
        this marks the condition bottom of the function intersect_horizontal as false.
      ], caption: [Visualization of the monitor overlap],
    )<overlap>],
)

On each of the shapes drawn with cairo, GTK allows the use of event handlers
including drag and drop handlers.

#subsubsection("Redraws")

