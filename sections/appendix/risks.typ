#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Risks")
Risks are assessed according to the ISO standard with a risk matrix.

#riskmatrix()
#risk(
  "Toolkit", [
    GTK might not be perfectly suitable for the required use case, especially considering the usage of Rust bindings and not C directly.
  ], "Medium", "Unlikely", "Critical", [
    Iced can be used as a backup toolkit if GTK turns out to not be usable for the
    project.
  ],
)
#risk(
  "Plugin System", [
    The plugin system might be too ambitious and could take too much time to
    realize.
  ], "High", "Likely", "Marginal", [
    Instead of a plugin system, DBus[@dbus] or socket connections can be used to
    realize a limited implementation of expected features.
  ],
)
#risk(
  "System Interaction", [
    System feature integration like audio, Bluetooth and more might not be as
    seamless as planned.
  ], "Low", "Rare", "Marginal", [
    Potential use of alternative integrations.\
    Example: The standard NetworkManager does not integrate well → use
    Systemd-networkd instead.
  ],
)
#pad(x: 0pt, y: 0pt, line(length: 100%))
