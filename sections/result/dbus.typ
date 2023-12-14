#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("DBus")
As explained in @Architecture, inter-process communication is handled via DBus,
in this section, the DBus usage is elaborated.

The API for ReSet can be found in @DBusAPI or on docs.rs@daemon_api for an updated version.

#subsubsection("DBus Types")
In order to properly understand the DBus API, the following table will provide
information about DBus types and how they correspond to the regular rust types.

//typstfmt::off
#grid(
  columns: (auto), rows: (20pt), cell(
    [#figure([], kind: table, caption: [DBus Type Table])<kderequirements>], bold: true,
  ),
)
#grid(
  columns: (1fr, 1.5fr, 2.5fr), rows: 20pt, gutter: 0pt,
  cell("DBus Type", bold: true, use_under: true, cell_align: left),
  cell("Rust Type", bold: true, use_under: true, cell_align: left),
  cell("Generic Type", bold: true, use_under: true, cell_align: left),
  cell("y", bold: true,  cell_align: left),
  cell("u8", bold: true,  cell_align: left),
  cell("unsigned byte", bold: true,  cell_align: left),
  cell("b", bold: true,  cell_align: left, fill: silver),
  cell("bool", bold: true,  cell_align: left, fill: silver),
  cell("boolean", bold: true,  cell_align: left, fill: silver),
  cell("n", bold: true,  cell_align: left),
  cell("i16", bold: true,  cell_align: left),
  cell("signed 16bit integer", bold: true,  cell_align: left),
  cell("q", bold: true,  cell_align: left, fill: silver),
  cell("u16", bold: true,  cell_align: left, fill: silver),
  cell("unsigned 16bit integer", bold: true,  cell_align: left, fill: silver),
  cell("i", bold: true,  cell_align: left),
  cell("i32", bold: true,  cell_align: left),
  cell("signed 32bit integer", bold: true,  cell_align: left),
  cell("u", bold: true,  cell_align: left, fill: silver),
  cell("u32", bold: true,  cell_align: left, fill: silver),
  cell("unsigned 32bit integer", bold: true,  cell_align: left, fill: silver),
  cell("x", bold: true,  cell_align: left),
  cell("i64", bold: true,  cell_align: left),
  cell("signed 64bit integer", bold: true,  cell_align: left),
  cell("t", bold: true,  cell_align: left, fill: silver),
  cell("u64", bold: true,  cell_align: left, fill: silver),
  cell("unsigned 64bit integer", bold: true,  cell_align: left, fill: silver),
  cell("d", bold: true,  cell_align: left),
  cell("f64", bold: true,  cell_align: left),
  cell("64bit floating point number", bold: true,  cell_align: left),
  cell("s", bold: true,  cell_align: left, fill: silver),
  cell("String/&str", bold: true,  cell_align: left, fill: silver),
  cell("String", bold: true,  cell_align: left, fill: silver),
  cell("o", bold: true,  cell_align: left),
  cell("Path<'static>", bold: true,  cell_align: left),
  cell("DBus object path", bold: true,  cell_align: left),
  cell("a", bold: true,  cell_align: left, fill: silver),
  cell("Vec<T>", bold: true,  cell_align: left, fill: silver),
  cell("DBus Array", bold: true,  cell_align: left, fill: silver),
)

#subsubsection("Daemon and Application")
As explained in @Introduction, ReSet will include a daemon and a client application to this daemon.
It is therefore necessary to use inter process communication to provide functionality on the application.
In this section, example usages and the IPC architecture are elaborated.

#figure(sourcecode(```rs
// spawn a new thread to not block the GUI thread 
thread::spawn(|| {
    // create a temporary connection for DBus
    let conn = Connection::new_session().unwrap();
    let proxy = conn.with_proxy(
        "org.Xetibo.ReSet.Daemon",  // The DBus name to target
        "/org/Xetibo/ReSet/Daemon", // The DBus object path where the daemon exists
        Duration::from_millis(100),
    );
    // The returntype of this DBus method
    // The error is necessary as a call to DBus can also fail
    let res: Result<(), Error> = 
        proxy.method_call(
          "org.Xetibo.ReSet.Daemon", // The DBus interface
          "UnregisterClient",        // The DBus method
          ("ReSet",));               // The provided parameters
    res
});
```),caption: [Example DBus usage in a client of the ReSet-Daemon])<dbus_usage>

#align(center, [#figure(
    img("dbus_sequence.svg", width: 100%, extension: "files"),
    caption: [DBus sequence diagram of ReSet],
  )<dbus_sequence>])

#pagebreak()

As can be seen in figure @dbus_sequence, the client would need to implement a lot of base functionality in order to communicate with multiple DBus sources.
It would also mean that any non-DBus source, such as pulseaudio for ReSet, would have to be accessed separately by the client.
Limiting communication over DBus hence simplifies the implementation for the client.
