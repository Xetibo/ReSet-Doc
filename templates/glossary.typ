#let glossary_entry(use_show: true, name, description) = {
  if use_show {
    figure(
      grid(columns: (2fr, 8fr), gutter: 15pt, [
        #align(left, text(size: 12pt, [*#name*]))
      ], align(left, description)),
      kind: "glossary_entry",
      supplement: none,
      numbering: "(1)",
    )
  } else { figure([]) }
}

#let reset_glossary(use_show_ref: false) = [
  #pad(y: 10pt)[]
  #glossary_entry(
    use_show: use_show_ref,
    "Daemon",
    [
      Background process, most commonly used to handle functionality for a frontend.
    ],
  )<daemon>
  #glossary_entry(
    use_show: use_show_ref,
    "Desktop Environment",
    [
      A collection of software, enabling a graphical user interface experience to do
      general computing tasks.\
      This includes most basic functionality like starting programs, shutting down the
      PC or similar.
    ],
  )<DE>
  #glossary_entry(
    use_show: use_show_ref,
    "Language Server Protocol (LSP)",
    [
      Protocol designed to help program software by providing quick-fixes to errors,
      linting, formatting and refactoring.
    ],
  )<LSP>
  #glossary_entry(use_show: use_show_ref, "Target Triple", [
    String used to define compilation target platforms in rust.
  ])<triple>
  #glossary_entry(
    use_show: use_show_ref,
    "dbus",
    [ Low level API providing inter process communication (IPC) on UNIX operating
      systems. ],
  )<dbus>
  #glossary_entry(
    use_show: use_show_ref,
    "Wayland",
    [
      The current display protocol used on Linux.\
      It replaces the previous X11 protocol, which is no longer in development. (it is
      still maintained for security reasons)
    ],
  )<wayland>
  #glossary_entry(use_show: use_show_ref, "Gnome", [
    A Linux desktop environment.
  ])<gnome>
  #glossary_entry(use_show: use_show_ref, "KDesktop Environment (KDE)", [
    A Linux desktop environment.\
    The K has no particular meaning.
  ])<kde>
  #pagebreak()
]
