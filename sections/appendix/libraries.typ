#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Libraries")
This section covers all direct third-party libraries used within ReSet and its repositories.

#subsubsection("ReSet-Daemon")
- ReSet-Lib @reset-lib: GPL-3.0-or-later
- DBus, DBus-crossroads, DBus-toktio @dbus_rs: Apache-2.0, MIT
- tokio @tokio: MIT
- libpulse_binding @libpulse_binding: Apache-2.0, MIT 
- crossbeam @crossbeam: Apache-2.0, MIT
- once_cell @once-cell: Apache-2.0, MIT
- libloading @libloading-lib: ISC 
- serial_test @serial-test: MIT 
- toml @toml: Apache-2.0, MIT

#subsubsection("ReSet")
- ReSet-Daemon @reset-daemon: GPL-V3-or-later
- ReSet-Lib @reset-lib: GPL-V3-or-later
- libadwaita @libadwaita: MIT
- gtk4 @gtk4: MIT
- glib @glib: MIT
- tokio @tokio: MIT
- fork @fork: BSD-3-Clause
- ipnetwork @ipnetwork: Apache-2.0 

#subsubsection("ReSet-Lib")
- directories-next @directories_next: Apache-2.0, MIT
- DBus, DBus-crossroads, DBus-toktio @dbus_rs: Apache-2.0, MIT
- libpulse_binding @libpulse_binding: Apache-2.0, MIT 
- once_cell @once-cell: Apache-2.0, MIT
- libloading @libloading-lib: ISC 
- gtk4 @gtk4: MIT
- serial_test @serial-test: MIT 
- toml @toml: Apache-2.0, MIT

#subsubsubsection("Monitor Plugin")
- ReSet-Lib @ReSet-Lib: GPL-V3-or-later
- DBus, DBus-crossroads, DBus-toktio @dbus_rs: Apache-2.0, MIT
- libadwaita @libadwaita: MIT
- gtk4 @gtk4: MIT
- glib @glib: MIT
- directories-next @directories_next: Apache-2.0, MIT
- wayland-protocols-plasma, wayland-protocols-wlr, wayland-client @wayland-rs: MIT
- serde @serde: Apache-2.0, MIT
- serde-json @serde-json: Apache-2.0, MIT

#pagebreak()
#subsubsubsection("Keyboard Plugin")
- ReSet-Lib @ReSet-Lib: GPL-V3-or-later
- DBus, DBus-crossroads, DBus-toktio @dbus_rs: Apache-2.0, MIT
- libadwaita @libadwaita: MIT
- gtk4 @gtk4: MIT
- glib @glib: MIT
- directories-next @directories_next: Apache-2.0, MIT
- toml @toml: Apache-2.0, MIT
- xkbregistry @xkbregistry: WTFPL 
- regex @regex-rs: Apache-2.0, MIT


