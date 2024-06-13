#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Monitor Plugin Implementation")
This section covers the implementation of the monitor plugin for ReSet.

#subsubsection("Data Transfer Object (DTO)")
In order to facilitate the usage of all the different fetching methods and
different structures, ReSet needs a way to convert the fetched structures to
universal versions in order to provide a consistent, API-compatible structure as
a DBus endpoint. Just as with ReSet itself, the goal of this plugin is to offer
both a DBus endpoint for functionality and a graphical user interface for human
interaction. Should a user not be satisfied with the provided interface, they
can just use the endpoint to create their own.

In @Display-Struct the fields of the display struct used for the DBus connection
and the user interface is visualized.
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
    pub uses_mode_id: bool,
    pub features: MonitorFeatures,
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Display struct],
    )<Display-Struct>],
)

The monitor struct holds all important information within a single indirection,
while user interface information (DragInformation), environment feature flags
and monitor modes are combined into separate data structures. This allows every
environment to be converted, while they still share differing approaches to
monitors.

#pagebreak()

#subsubsection("Fractional Scaling")
Fractional scaling is implemented according to the fractional-scale-v1 Wayland
protocol. @fractional-scale-v1-protocol This protocol defines how scaling values
will be interpreted by the environment. The specification defines that supported
scales must be of a fraction with a denominator of 120. In other words,
incrementing a scaling value would mean multiplying the base value with 120,
then proceeding to increase or decrease this number before dividing by 120
again. The result will be a new scaling fraction within the constraints of the
protocol.

#align(center, [In @fraction-example, an example is visualized.])

#align(
  left, [#figure([
      #text(fill: maroon, size: 16pt, [
        #v(10pt)
        $1.00 * 120 = 120$\
        $120 + 6 = 126$\
        $126 / 120 = 1.066666... $
        #v(10pt)
      ])
    ], caption: [Example for a valid fractional scale])<fraction-example>],
)

For fractional scaling, there is another requirement that a user-selected scale
must adhere to. This requirement defines that a chosen scale must be a divider
for both the width and the height of the resolution. In other words, the
division must result in a full integer and may not leave any fractions. Using
scaling with noninteger resolutions would mean slightly different aspect ratios
for every scale, which creates an inconsistent user experience.

The challenge with this approach is that a user may no longer enter any random
number as a scale. ReSet would either need to provide a check for every entered
scale or provide a range of valid scales to choose from. Existing solutions such
as GNOME and KDE resorted to using a selection of scales by dropdown and slider
respectively.

In @scale-adjustment-kg the options from KDE and GNOME are visualized.
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
invalid scale, removing a potential error. KDE offers both a slider that snaps
to predefined percentages, while also offering a user input for arbitrary
percentages. Noteworthy is that the user input automatically changes to a
supported value when applying the configuration. In @scale-adjustment-kg the
scaling was adjusted to 132% up from 130%, in this case, the apply button is
disabled as 132% is not a possible scale and the nearest possible scale (130%)
is already applied.

As ReSet offers scaling for multiple environments, the plugin should also
support arbitrary scales depending on the environment. For ReSet, the
implementation was handled with a libadwaita SpinRow, this widget provides both
arbitrary user input and an increment and decrement button.@adwspinrow As ReSet
implements arbitrary scaling, it would also require a check for valid scales
with proper user feedback. The chosen method was to simply snap to the closest
possible valid scale and provide an error banner if no scale can be found.

The implementation itself is a loop that increments the by 120 divided scale
until either a valid scale is found, or the maximum iterations (0..amount) have
been reached.

In @search-nearest-scale, the body of the search_nearest_scale function within
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
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Search the nearest scale function],
    )<search-nearest-scale>],
)

#subsubsection("Drag-and-Drop")
A common configuration is the arrangement of monitors. A user might have a
physical setup where the leftmost monitor is considered the second monitor
within the operating system/environment. This requires the user to either
re-configure the physical cable arrangement, or preferably, just drag the
monitor to the correct position with a user interface.@draganddrop

GTK does not offer a direct way to draw arbitrary shapes, however, it does offer
cairo integration, which is a low-level drawing framework that can be used to
draw pixels onto a GTK DrawingArea. @cairo

In order to both draw the shapes and calculate the eventual user offsets, a
coordinate system is required. For cairo this is a top-left to bottom-right
system. This means that x increases towards the right and y increases towards
the bottom.

#pagebreak()
In @monitor-axis, the monitor cairo coordinate system is visualized.
#align(
  center, [#figure(
      img("monitor-axis.png", width: 70%, extension: "figures"), caption: [Visualization of the monitor cairo coordinate system],
    )<monitor-axis>],
)

For a simple drawing of the monitor, this coordinate system would be trivial,
however, it is important to understand it in detail when providing drag-and-drop
operations, which have to constantly apply transforms to these shapes. At the
same time, any potential monitor overlaps have to be handled, as well as
providing snapping functionality in order to auto-align monitors.

On top of this, the coordinate system of the monitor itself has the y-axis
inverted, as all environments expect positive y to be "upwards".

Intersections can be seen by two conditions per axis. If both axes have at least
one condition evaluated as false, then an overlap has occurred. In @conditions
and @overlap the conditions and an example overlap are visualized.

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

The dragging itself without calculations is trivial, as GTK allows the use of
event handlers including drag-and-drop handlers on each cairo shape which
represent the monitors.

#subsubsection("Snapping")
A quality of life feature is the ability to allow users to be inaccurate with
their monitor positioning and then automatically snapping the monitor towards
adjacent ones.

For example, the Windows desktop paradigm offers desktop icons. A user can
rearrange them via drag-and-drop, and in this action, the user does not need to
be accurate, instead, they can approximately drag the icon to the target
endpoint and drop it at this position. The desktop icon system will then
reposition the icon towards the correct place within the grid system.

In @monitor-dnd and @monitor-dnd-end, the dragging mechanism is visualized.

#align(
  center, [#figure(
      img("reset-monitor-dnd5.png", width: 70%, extension: "figures"), caption: [Monitor dragged towards the right],
    )<monitor-dnd>],
)
#align(
  center, [#figure(
      img("reset-monitor-dnd6.png", width: 70%, extension: "figures"), caption: [Monitor snapped to another monitor],
    )<monitor-dnd-end>],
)

To ensure this functionality works as expected, the potential snapping
functionality checks for overlaps, as well as the no-gaps requirement in the KDE
and GNOME environments. Specifically, the dragged monitor is checked against all
other monitors, with the smallest gap in both vertical and horizontal being
considered. In other words, a monitor can snap once in horizontal direction and
once in vertical at the same time.

In @snap_check, the code to check for the smallest distance in for vertical
snaps is visualized.

#let code = "
// find smallest difference
let top_to_bottom = endpoint_top.abs_diff(endpoint_other_bottom);
let bottom_to_top = endpoint_bottom.abs_diff(endpoint_other_top);
let top_to_top = endpoint_top.abs_diff(endpoint_other_top);
let bottom_to_bottom = endpoint_bottom.abs_diff(endpoint_other_bottom);
let min = cmp::min(
  cmp::min(top_to_bottom, bottom_to_top),
  cmp::min(top_to_top, bottom_to_bottom),
);
// snap to the smallest distance if smaller than SNAP_DISTANCE
if min < SNAP_DISTANCE {
  match min {
    x if x == top_to_bottom => {
      snap_vertical = SnapDirectionVertical::TopBottom(
        endpoint_other_bottom,
        endpoint_other_left,
        other_width,
      );
    }
    x if x == bottom_to_top => {
      snap_vertical = SnapDirectionVertical::BottomTop(
        endpoint_other_top,
        endpoint_other_left,
        other_width,
      );
    }
    x if x == top_to_top => {
      snap_vertical = SnapDirectionVertical::TopTop(endpoint_other_top);
    }
    x if x == bottom_to_bottom => {
      snap_vertical = SnapDirectionVertical::BottomBottom(endpoint_other_bottom);
    }
    _ => unreachable!(),
  }
}"

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Vertical snapping check within the monitor_drag_end function],
    )<snap_check>],
)

The endpoints represent the edges of both monitors, with the "other" monitor
being the monitor that is currently checked against.

#pagebreak()

#subsubsection("Feature Disparities")
Differing environments offer a range of features, this forces ReSet to offer
dynamic feature checking in order to only show compatible features with the
current environment. As an example, both GNOME and KDE have a concept of a
primary monitor, which should be the default monitor for starting applications,
widgets and more. However, tiling environments like Hyprland do not offer a
primary monitor, as these types of environments handle these use cases with
explicit focus. If your focus is currently on "Monitor 1", then the application
will also be started on this monitor. Similarly, widgets and panels are created
explicitly, meaning you would need to define one or more monitors where your
widget or panel should be.

The solution for this problem is a set of feature flags that are introduced
during the conversion from environment-specific data to DBus-compatible generic
monitor data. Within this data, the struct visualized in @monitor-feature-flag
is included.

#let code = "
pub struct MonitorFeatures {
    pub vrr: bool,
    pub primary: bool,
    pub fractional_scaling: bool,
    pub hdr: bool,
}
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Monitor feature flag struct],
    )<monitor-feature-flag>],
)

*VRR/Variable-Refresh-Rate*: This configures the monitor to automatically lower
or increase the monitor's refresh rate depending on the current performance of
the graphics card. In games, this means coupling the monitor refresh rate to the
frames per second generated by the graphics card/core processing unit. This
feature is currently supported by KDE, GNOME (experimental), Xorg and all
wlroots-based compositors such as Hyprland or Sway.

*HDR/High Dynamic Range*: Luminosity ranges between the brightest and darkest
areas within a scene. This setting is a longstanding issue within Linux
environments. As such this feature is currently only available as an
experimental feature on KDE.

*Fractional Scaling*: Scaling with a non-integer number. The challenge with this
is that a full integer will always result in an integer resolution. However, as
explained in @FractionalScaling, using a fractional number will result in
fractional resolutions which is not applicable. Hence, a set of rules must be
followed in order to avoid this issue. Currently, KDE, GNOME (experimental) and
wlroots-based environments support fractional scaling.

#subsubsection("Redraws")
In order to show changes within the plugin, GTK needs to redraw the widgets.
Depending on the change, this could be something insignificant such as a number,
or replacing the entire set of settings when clicking on another monitor.
Redrawing a singular number within a widget is covered by GTK, while the
selection of the monitor must be handled by the plugin. For this problem, a
singular function was chosen that repopulates the settings per monitor on
selection. The function is visualized in @monitor-settings-function.

#let code = "
pub fn get_monitor_settings_group(
    clicked_monitor: Rc<RefCell<Vec<Monitor>>>,
    monitor_index: usize,
    drawing_area: &DrawingArea,
) -> PreferencesGroup {
    let settings = PreferencesGroup::new();
    // add settings
    settings
}
// each call to this function replaces the current group with a new one
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Section of the get_monitor_settings_group function],
    )<monitor-settings-function>],
)

It is important to note, that the covered feature differences in
@FeatureDisparities, lead to differing functions being used for different
environments. As such ReSet checks for environment differences inside this
function via the ```sh$XDG_CURRENT_DESKTOP``` environment variable.

In @dynamic-feature-monitor, an example for a dynamic feature is visualized.
#let code = "
// inside \"get_monitor_settings_group\"
let scaling_ref = clicked_monitor.clone();
add_scale_adjustment(monitor.scale, monitor_index, scaling_ref, &settings);

// scale handler
pub fn add_scale_adjustment(
    scale: f64,
    monitor_index: usize,
    scaling_ref: Rc<RefCell<Vec<Monitor>>>,
    settings: &PreferencesGroup,
) {
    // Different environments allow differing values
    // Hyprland allows arbitrary scales, Gnome offers a set of supported scales
    match get_environment().as_str() {
        \"Hyprland\" => {}, // hyprland implementation
        \"GNOME\" => {}, // GNOME implementation
        \"KDE\" => {}, // KDE implementation
        _ => match get_wl_backend().as_str() {}, // match protocols for others
    };
}
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Dynamic feature functionality for the ReSet monitor plugin],
    )<dynamic-feature-monitor>],
)

Another problematic section of the plugin is the drawing area, as this requires
separate redraws as well. For this, redraws are queued for any action taken that
changes the appearance within the drawing area. Possible actions include
dragging, snapping, change of transform, change of scaling, change of resolution and monitor
selection. Each of these actions will cause the drawing area to be redrawn in
order to show the result of the chosen action.

The last piece of redraw is the arrangement of the monitors. Each time a user
changes the resolution,  the transform of a monitor or the scaling, this will be
reflected on the interface. This requires the plugin to calculate a new
arrangement for all monitors, as the constellation of monitors should not change
simply because the user changed the resolution of a single monitor. As an
example, consider a situation with three monitors aligned in a row. When the
user changes the resolution or transforms either the first or the second
monitor, the monitors to the right would need to be moved either towards or away
from the changed monitor. In @monitor-resize the example is visualized.

#align(
  center, [#figure(
      img("monitor-resize.png", width: 60%, extension: "figures"), caption: [Example of a monitor resize within an arrangement],
    )<monitor-resize>],
)

Further issues arise with the inclusion of the y-axis for potential resizes. Due
to multiple axes being possible, it is now necessary to check for overlaps that
can be caused by to shifting of other monitors after resizing. Consider the
second example with four monitors shown in @monitor-resize-2.

#align(
  center, [#figure(
      img("monitor-resize-2.png", width: 100%, extension: "figures"), caption: [Example of an overlap caused by monitor resize],
    )<monitor-resize-2>],
)

This overlap is not applicable as a configuration and needs to be resolved.
There are multiple possible solutions to this problem. A very simple approach
would be to just reorder the monitors as soon as the resolution or transform of
any monitor happens. The drawback with this approach is the fact that it breaks
the arrangement a user created. This would mean that the monitor previously
situated in the center might now be on the left. In
@simple-rearrangement-function the solution is visualized.

#let code = "
for monitor in monitors.iter_mut() {
   // handles rotation in order to calculate x and y
   let (width, _) = monitor.handle_transform();
   monitor.offset.0 = furthest;
   // move all monitors to one axis -> hence no overlap possible
   monitor.offset.1 = original_monitor.offset.1;
   furthest = monitor.offset.0 + width;
}
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Code snippet for the furthest calculation of monitors],
    )<simple-rearrangement-function>],
)

For this plugin, the more complicated variant of checking for overlaps and only
rearranging the overlapped monitors was chosen. With this, users only see
monitors moving away from their assigned spot, if their size cannot fit in the
same spot after rearranging.

This variant includes four incremental steps. The first step is calculating the
resolution or transform difference of the changed monitor, as well as the right
side of the rightmost monitor. Step two handles the movement of all monitors
that exist on the right or the bottom of the changed monitor. Step three handles
the checking for overlaps among all monitors. This is done by looping over all
monitors and checking each monitor against the other.

In @complex-rearrangement-function, step three is visualized.

#let code = "
// Step 1 and 2: omitted
// (false, false)
// first: already used flag -> don't check for overlaps
// second: bool flag to indicate overlap
let mut overlaps = vec![(false, false); monitors.len()];
// check for overlaps
for (index, monitor) in monitors.iter().enumerate() {
  for (other_index, other_monitor) in monitors.iter().enumerate() {
    if monitor.id == other_monitor.id || overlaps[other_index].0 {
      continue;
    }
    let (width, height) = other_monitor.handle_transform();
    let intersect_horizontal = monitor.intersect_horizontal(
      other_monitor.offset.0 + other_monitor.drag_information.border_offset_x,
      width,
    );
    let intersect_vertical = monitor.intersect_vertical(
      other_monitor.offset.1 + other_monitor.drag_information.border_offset_y,
      height,
    );
    // don't rearrange the rightmost monitor -> otherwise gap between monitors
    let is_furthest = furthest == monitor.offset.0 + monitor.size.0;
    if intersect_horizontal && intersect_vertical && !is_furthest {
      overlaps[index].1 = true;
    }
  }
  overlaps[index].0 = true;
}
// Step 4: omitted
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "rs")), kind: "code", supplement: "Listing", caption: [Overlap detection for the rearrangement-function of monitors],
    )<complex-rearrangement-function>],
)

The last step is to remove all overlaps. This is done by moving the overlapping
monitors to the rightmost side calculated in step one.

In @monitor-rearranged, the overlap shown in @monitor-resize-2 is fixed.

#align(
  center, [#figure(
      img("monitor-rearranged.png", width: 100%, extension: "figures"), caption: [Example of a rearranged monitor configuration],
    )<monitor-rearranged>],
)

#pagebreak()

#subsubsection("Resulting User Interface")
This section covers the resulting plugin user interface.

As a baseline, the plugin is shown in @reset-monitor.

#align(
  center, [#figure(
      img("reset-monitor-plugin.png", width: 90%, extension: "figures"), caption: [Screenshot of the ReSet monitor plugin on Hyprland],
    )<reset-monitor>],
)

The buttons for applying, resetting and saving were placed at the top in order
to provide a visually pleasing appearance while also indicating to the user that
these buttons are for the entire configuration of all monitors. Including the
constraints provided by the implementation, this alignment is also cohesive to
the positioning of similar buttons in the Bluetooth and Wi-Fi functionality of
ReSet. Compared to the mockup in @MonitorPluginMockup, this differs from placing
the buttons within the drag-and-drop visualization.

Similar to @KDEImplementation, the plugin interface will always show the current
monitor configuration visually, with a blue indicator showing the currently
selected monitor. This ensures that users are always immediately aware of how
their configuration will translate to the real world, including resolution
changes and transformation changes.

Below the visual interface is a list of configurations for the currently
selected monitor with the first bar showing the name and the make of the
selected monitor. On the same bar, the selected monitor can also be turned off,
if the overall configuration has more than one monitor available.

Options for features such as resolutions, refresh rates, fractional scaling and
more were implemented with either a dropdown menu comparable to the GNOME
implementation discussed in @GNOMEImplementation as the same toolkit was used,
while the scaling implementation differs depending on the environment. The
scaling feature is discussed in detail in @FractionalScaling.

The results of this user interface will be tested in @MonitorPluginTests.
