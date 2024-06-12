#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Plugin API")

#subsubsection("Plugin Backend API")

#figure(
  ```rs
// The startup function is intended to be used to allocate any required resources.
pub fn backend_startup();

// Cleanup any resources allocated for your plugin that aren't automatically removed.
pub fn backend_shutdown();

// Reports the capabilities that your plugin will provide, simply return a vector of 
// strings.
#[allow(improper_ctypes)]
pub fn capabilities() -> PluginCapabilities;

// Reports the name of the plugin, used for duplication detection and plugin tests.
#[allow(improper_ctypes)]
pub fn name() -> String;

// Inserts your plugin interface into the dbus server. Provided as a parameter is the 
// crossroads context, which you can use in order to insert your interfaces and objects
#[allow(improper_ctypes)]
pub fn dbus_interface(cross: &mut Crossroads);

// Use this function to return any tests you would like to have run.
// This might be a bit confusing as this will force you to define your functions for 
// testing outside of your typical rust tests.
pub fn backend_tests();
  ```, 
  kind: "code", 
  supplement: "Listing",
  caption: [Backend Plugin API functions],
)<plugin-backend-api>

#subsubsection("Plugin Frontend API")

#figure(
  ```rs
// The startup function is intended to be used to allocate any required resources.
pub fn frontend_startup();

// Cleanup any resources allocated for your plugin that aren't automatically removed.
pub fn frontend_shutdown();

// Reports the capabilities that your plugin will provide, simply return a vector of 
// strings.
#[allow(improper_ctypes)]
pub fn capabilities() -> PluginCapabilities;

// Reports the name of the plugin, used for duplication detection and plugin tests.
#[allow(improper_ctypes)]
pub fn frontend_name() -> String;

// Provides the information needed to embed the plugin UI into Reset. 
// SidebarInfo contains the name, icon and hiearchy in the sidebar.
// Vec<gtk::Box> contains the widgets that will be shown in the main window.
#[allow(improper_ctypes)]
pub fn frontend_data() -> (SidebarInfo, Vec<gtk::Box>);

// Use this function to return any tests you would like to have run.
// This might be a bit confusing as this will force you to define your functions for 
// testing outside of your typical rust tests.
pub fn frontend_tests();
  ```, 
  kind: "code", 
  supplement: "Listing",
  caption: [Frontend Plugin API functions],
)<plugin-frontend-api>

#subsubsection("Keyboard Plugin DBus API")

#grid(
  columns: (1fr, 2fr), rows: (20pt, 40pt, 40pt), gutter: 0pt,
  cell("Type", bold: true, cell_align: left, use_under: true),
  cell("Type Description", bold: true, cell_align: left, use_under: true),

  cell("GetKeyboardLayouts", bold: true,  cell_align: left),
  cell(
    [
      DBus signature: a(sss)\
      `Vec<String, String, String>`
    ], 
    bold: true,  cell_align: left
  ),

  cell("GetSavedLayouts", bold: true,  cell_align: left, fill: silver),
  cell(
    [
      DBus signature: a(sss)\
      `Vec<String, String, String>`
    ], 
    bold: true,  cell_align: left, fill: silver
  ),
  
  cell("SaveLayoutOrder", bold: true,  cell_align: left),
  cell(
    [
      DBus signature: a(sss)\
      `Vec<String, String, String>`
    ], 
    bold: true,  cell_align: left
  ),

  cell("GetMaxActiveKeyboards", bold: true,  cell_align: left, fill: silver),
  cell(
    [
      DBus signature: u32\
      `u32`
    ], 
    bold: true,  cell_align: left, fill: silver
  ),
)

#subsubsection("Monitor Plugin DBus API")
The exaxt types can be seen at @Display-Struct.
#grid(
  columns: (1fr, 2fr), rows: (20pt, 40pt, 40pt), gutter: 0pt,
  cell("Type", bold: true, cell_align: left, use_under: true),
  cell("Type Description", bold: true, cell_align: left, use_under: true),

  cell("GetMonitors", bold: true, cell_align: left),
  cell(
    [
      DBus signature: a(ub(ssss)(udu)bb(ii)(ii)sa(s(ii)a(us)ad)\ b(bbbb)) 
    ], 
    bold: true,  cell_align: left
  ),

  cell("SaveMonitors", bold: true, cell_align: left, fill: silver),
  cell(
    [
      DBus signature: a(ub(ssss)(udu)bb(ii)(ii)sa(s(ii)a(us)ad)\ b(bbbb)) 
    ], 
    bold: true,  cell_align: left, fill: silver
  ),
  
  cell("SetMonitors", bold: true, cell_align: left),
  cell(
    [
      DBus signature: a(ub(ssss)(udu)bb(ii)(ii)sa(s(ii)a(us)ad)\ b(bbbb)) 
    ], 
    bold: true,  cell_align: left
  ),
)