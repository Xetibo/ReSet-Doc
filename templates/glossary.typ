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
      A combination of display server(not a true server with Wayland) and window
      composition system. Often used to describe standalone Wayland environments like
      Mutter, KWin, Hyprland, Sway and River.
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
  )<dbus_glossary>
  #glossary_entry(
    use_show: use_show_ref, "Desktop Environment", [
      A collection of software, enabling a graphical user interface experience to do
      general computing tasks.\
      This includes most basic functionality like starting programs, shutting down the
      PC or similar.
    ],
  )<DE>
  #glossary_entry(
    use_show: use_show_ref, "GTK", [A free software widget toolkit for creating graphical user interfaces. The name
      is an acronym for "GIMP ToolKit" as a reminder of the toolkit legacy, however,
      today GTK is trademarked and developed by the GNOME foundation and no longer
      refers to GIMP.],
  )<dbus_glossary>
  #glossary_entry(use_show: use_show_ref, "GNOME", [
    A Linux desktop environment.
  ])<Gnome>
  #glossary_entry(use_show: use_show_ref, "KDesktop Environment (KDE)", [
    A Linux desktop environment.\
    The K has no particular meaning.
  ])<kde>
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
      simply provide, window spawning and window management. Examples include Mutter,
      KWin, dwm, Xmonad, i3 and herbstluftwm.
    ],
  )<window_manager>
  #glossary_entry(
    use_show: use_show_ref, "X11", [
      A network transparent windowing system used by a variety of systems. It is
      usually used with the reference implementation Xorg.
    ],
  )<X11>
  #glossary_entry(
    use_show: use_show_ref, "IPC", [
      IPC or Inter Process Communication is the idea of communication between
      differing processes using a specific protocol. Examples of IPC are DBus,
      sockets, message passing, pipes and more.
    ],
  )<IPC>
  #pagebreak()
]
