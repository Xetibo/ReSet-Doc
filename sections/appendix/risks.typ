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

#risk(
  "Plugin System performance issues", [
  The plugin system might have performance issues that could negatively impact the user experience.
], "Medium", "Unlikely", "Marginal", [
  The plugin system can be optimized. If this is not possible, consider a different architecture.
  ],
)

#risk(
  "Plugin System stability issues", [
    Because plugins can be written by third parties, they might not be as stable and cause problems like crashes.
  ], "High", "Possible", "High", [
    Verify the plugin that it is compatible and add measures in case of a plugin crash.
  ],
)

#risk(
  "Plugin System architecture not fitting", [
    There might be some breaking problems that go unnoticed until development has already startet on the plugin system.
  ], "High", "Rare", "Medium", [
    Keep a second architecture in mind that could replace the first if it does not work out.
  ],
)

#risk(
  "WiFi & Bluetooth", [
    WiFi and Bluetooth are currently not feature complete and might take longer than expected
  ], "High", "Likely", "Marginal", [
    Either sacrifice other planned features or change the scope of WiFi and Bluetooth functionalities.
  ],
)
