#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Management Summary")
*Introduction*:\
ReSet is a settings application developed with Rust for Linux-based systems to
be compatible with different graphical desktop interfaces. Its core
functionalities of Wi-Fi, Bluetooth and Audio were completed successfully, but
additional functionalities require desktop-specific implementation with their
own set of rules that need to be adhered to. Hence, a plugin system is created
for the ReSet application, alongside a testing framework and improvements to the
original application.

*Features*:\
- Plugin system:\
  A plugin system for both processes of ReSet, which can be loaded dynamically at
  runtime and configured by the user.
- _Monitor plugin_:\
  A monitor plugin that allows users to change the properties of their current
  monitor or rearrange their monitors.\
  This plugin supports: KDE, GNOME, Hyprland, wlroots based compositors and kwin
  based compositors
- _Keyboard plugin_:\
  A keyboard plugin that allows users to change their keyboard layout, and add or
  remove layouts.\
  This plugin supports: KDE, GNOME, Hyprland
- Plugin testing framework:\
  Plugins can provide tests to both the daemon and the graphical user interface,
  in order to test the entire system instead of just the plugin. (Integration
  tests)
- Mock System:\
  The original ReSet application can be tested without hardware or software
  support enabled on the system. (excluding Audio)

*Distribution*:\
Just like the original ReSet application, the plugins should be available on as
many distributions as possible. For this reason at least four different packages
have been created: Arch package, Debian package (Ubuntu 24.04), NixOS module and
the binaries themselves which were proven to work with flatpak.

*Extensibility*:\
Further work can be done to create further plugins to increase the functionality
of ReSet for specific use-cases. Direct recommendations include, theming for
various toolkits, mouse configuration, controller configuration and more.

