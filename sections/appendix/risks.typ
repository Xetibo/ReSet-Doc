#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Risks")
Risks are assessed according to the ISO standard with a risk matrix.

#riskmatrix()

#risk(
  "Plugin System", [
    The plugin system might be too ambitious and could take too much time to realize or could be implemented faster than expected.
  ], "High", "Likely", "Marginal", [
    In case it is too ambitious, instead of a plugin system, or socket connections can be used to realize a limited implementation of expected features. \
    Otherwise more features like a system tray or custom bar can be implemented as well.
  ],
)

// todo