#let glossary_entry(use_show: true, name, description) = {
  if use_show {
    figure(
      grid(columns: (3.5fr, 8fr), gutter: 15pt, [
        #align(left, text(size: 12pt, [*#name*]))
      ], align(left, description)), kind: "glossary_entry", supplement: none, numbering: "(1)",
    )
  } else { figure([]) }
}

#let reset_glossary(use_show_ref: false) = [
  #pad(y: 10pt)[]
  #glossary_entry(
    use_show: use_show_ref, "Compositor", [
      A combination of display server(not a true server with wayland) and window
      composition system. Often used to describe standalone wayland environments like Mutter@mutter, KWin@kwin,
      Hyprland@hyprland, Sway@sway and River@river.
    ],
  )<compositor>
  #glossary_entry(
    use_show: use_show_ref, "Daemon", [
      Background process, most commonly used to handle functionality for a frontend.
    ],
  )<daemon>
  #glossary_entry(
    use_show: use_show_ref, "DBus", [Low-level API providing inter-process communication (IPC) on UNIX operating
      systems. ],
  )<dbus>
  #glossary_entry(
    use_show: use_show_ref, "Desktop Environment", [
      A collection of software, enabling a graphical user interface experience to do
      general computing tasks.\
      This includes most basic functionality like starting programs, shutting down the
      PC or similar.
    ],
  )<DE>
  #glossary_entry(
    use_show: use_show_ref, "DTO Data Transfer \nObject", [
      This represents data that can be sent over inter-process communication pipelines
      such as web requests, DBus or sockets. Data in this state can only be
      represented as text (usually JSON, TOML, etc.), this means that the endpoint
      needs to recreate a data structure for a programming language.
    ],
  )<dto>
  #glossary_entry(use_show: use_show_ref, "Gnome", [
    A Linux desktop environment.
  ])<Gnome>
  #glossary_entry(use_show: use_show_ref, "KDesktop Environment (KDE)", [
    A Linux desktop environment.\
    The K has no particular meaning.
  ])<kde>
  #glossary_entry(
    use_show: use_show_ref, "Language Server \nProtocol (LSP)", [
      Protocol designed to help program software by providing quick fixes to errors,
      linting, formatting and refactoring.
    ],
  )<LSP>
  #glossary_entry(
    use_show: use_show_ref, "Minimal Environment", [
      A window manager or compositor without the usually bundled applications expected
      from a full desktop environment. While feature amount vary, usually only window
      management and low-level configuration are provided out of the box.
    ],
  )<minimal_environment>
  #glossary_entry(
    use_show: use_show_ref, "Shell Component", [
      This refers to an application that integrates into the compositor, it differs to
      windows in layering, meaning shell components cannot be dragged around, and they
      can either be drawn beneath all windows (desktop widgets) or on top of
      windows (overlays).
    ],
  )<shell-component>
  #glossary_entry(
    use_show: use_show_ref, "Status Bar", [
      A shell component that usually offers information such as open programs, time,
      battery and more.\
      Can be compared to the top bar on MacOS or the taskbar on Windows.
    ],
  )<status-bar>
  #glossary_entry(use_show: use_show_ref, "Target Triple", [
    String used to define compilation target platforms in Rust.
  ])<triple>
  #glossary_entry(
    use_show: use_show_ref, "Wayland", [
      The current display protocol used on Linux.\
      It replaces the previous X11 protocol, which is no longer in development. (it is
      still maintained for security reasons)
    ],
  )<wayland>
  #glossary_entry(
    use_show: use_show_ref, "Window Manager", [
      Provides window management without compositing them. With the X11 protocol,
      implementing an entire display server is not needed, therefore one can choose to
      simply provide, window spawning and window management. Examples include Mutter@mutter, KWin@kwin, dwm@dwm,
      Xmonad@xmonad, i3@i3 and herbstluftwm@herbstluftwm.
    ],
  )<window_manager>
  #glossary_entry(
    use_show: use_show_ref, "X11", [
      A network transparent windowing system used by a variety of systems. It is
      usually used with the reference implementation Xorg.
    ],
  )<X11>
  #pagebreak()
]
