#import "../../templates/utils.typ": *

#section("Usage and Distribution")

#subsection("Flatpak")
Flatpak is a generic packaging solution that solves the issue of fragmentation
across the Linux ecosystem by creating sandboxed environments for each
application. @flatpak-web

Flatpak is a developer first approach, meaning the distribution is done directly
via developers who can request their application to be hosted on Flathub or on
their own server. This is in contrast to packaging solutions, which were with
distributions in mind, in other words, while packages installed by apt and
similar can be installed directly from the developer, it will likely cause
dependency issues, as apt packages define a single source for shared libraries.
Therefore, distributions host packages themselves, meaning a Debian user would
install packages from the Debian repository and not from the developer directly.

In order to create a Flatpak package, ReSet needs to provide a Flatpak manifest,
which defines the environment for Flatpak to build ReSet with. Within this
sandbox, ReSet will then be built and packaged with all necessary dependencies
in one, meaning the finished solution can then be used on any Linux system with
Flatpak installed.

In @reset-flatpak-manifest the Flatpak manifest of ReSet is visualized. Note
that several options were omitted in order to keep the listing concise.

#let code = "
{
  \"app-id\": \"org.Xetibo.ReSet\",
  \"runtime\": \"org.gnome.Platform\",
  \"runtime-version\": \"45\",
  \"sdk\": \"org.gnome.Sdk\",
  \"sdk-extensions\": [
    \"org.freedesktop.Sdk.Extension.rust-nightly\"
  ],
  \"command\": \"reset\",
  \"build-options\": {
    \"append-path\": \"/usr/lib/sdk/rust-nightly/bin\"
  },
  \"modules\": [
    {
      \"name\": \"reset\",
      \"buildsystem\": \"simple\",
      \"build-commands\": [
        \"cargo --offline fetch --manifest-path Cargo.toml --verbose\",
        \"cargo --offline build --verbose\",
        \"install -Dm755 ./target/release/reset -t /app/bin/\",
        \"install -Dm644 ./src/resources/icons/ReSet.svg /app/share/icons/hicolor/scalable/apps/org.Xetibo.ReSet.svg\",
        \"install -Dm644 ./flatpak/org.Xetibo.ReSet.desktop /app/share/applications/org.Xetibo.ReSet.desktop\"
      ],
    }
  ]
}
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "json")), kind: "code", supplement: "Listing", caption: [ReSet Flatpak manifest],
    )<reset-flatpak-manifest>],
)

Plugins for the flatpak cannot be distributed within flatpak itself. This is a
limitation of Flatpak, as one package cannot access another without
consequences. Hence, plugins would need to be compiled separately and placed
within the folder structure manually. Specific installation steps are shown in
@Usage.

#subsection("NixOS")
NixOS is the GNU/Linux distribution of the Nix project, which promises three
substantial benefits for users: Reproducibility, Declarativeness and
Reliability. For ReSet, the interesting claim is the declarative aspect of Nix.
With Nix, it is possible to create a system configuration, with which a user can
define both ReSet to be installed and define the plugins for ReSet within the
same configuration. This means that no additional system is required in order to
have automatic handling of plugins. This is in contrast to other packaging
solutions, which would require custom scripts in order to install and configure
plugins via the package manager. @nix-os-web

In order to provide this functionality for Nix, ReSet would either need to provide
a flake file, which can be used by Nix users to install ReSet and their
respective plugins directly from the source, or ReSet could create a pull
request on the official nix repositories.\
In order to not depend on third-party arbitration, this thesis will focus on
creating a flake, which will include the possibility of installing and
configuring plugins automatically.

Configuration in Nix is done with the functional and identically named Nix
language. This language is Turing-complete and therefore offers an infinite
amount of options for developers. ReSet uses this to create modules for users to
configure ReSet directly via Nix instead of changing configuration files.

In @reset-nix-module the nix options for the ReSet module are visualized.

#let code = "
# omitted setup
options.programs.reset = with lib; {
  # define if ReSet is installed
  enable = mkEnableOption \"reset\";

  # define plugins to be installed
  # this is defined with specifying Nix packages
  config = {
    plugins = mkOption {
      type = with types; nullOr (listOf package);
      default = null;
      description = mdDoc ''
        List of plugins to use, represented as a list of packages.
      '';
    };

    # define additional toml values to configure plugins
    plugin_config = mkOption {
      type = with types; attrs;
      default = { };
      description = mdDoc ''
        Toml values passed to the configuration for plugins to use.
      '';
    };
  };

};
# omitted applying of configuration
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "nix")), kind: "code", supplement: "Listing", caption: [ReSet Nix options],
    )<reset-nix-module>],
)

Within the system configuration, a user can now enable ReSet and their plugins
via the code in @reset-nix-usage.

#let code = "
# within flake inputs
# defines the origin for ReSet and plugins
reset.url = \"github:Xetibo/ReSet\";
reset-plugins.url = \"github:Xetibo/ReSet-Plugins?ref=dashie\";


# In nix/home-manager module
# enables ReSet and allows for plugins to be specified
programs.reset.enable = true;
programs.reset.config.plugins = [
  inputs.reset-plugins.packages.\"x86_64-linux\".monitor
];
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "nix")), kind: "code", supplement: "Listing", caption: [ReSet Nix usage],
    )<reset-nix-usage>],
)

#subsection("Other Distributions")
For regular GNU/Linux distributions, ReSet would need to provide a generic
plugin manager in order to achieve a consistent and cross-distribution
installation experience. A plugin manager is not within the scope of this
thesis, which requires users of ReSet to instead copy binaries manually into the
plugin folder.

#subsection("Cargo")
Cargo is the package manager for the Rust language, which allows both the
management of libraries within a project and the installation of binaries for a
user. Installed binaries are located within the user home directory in ```sh ~/.cargo/bin/```.
This means that a user must then manually handle the installation of plugins by
copying them into the right directory or directly passing a different installation
path for cargo during the plugin installation.

#subsection("Usage")
If manual installation is required, the plugins must be placed within ```sh $XDG_CONFIG_DIR/reset/plugins/``` after
compiling them individually.

After installing the plugins, users are required to confirm their plugin
selection within the ReSet configuration file by adding the exact filename of
the plugin. By default, the configuration file is located at ```sh $XDG_CONFIG_DIR/reset/ReSet.toml```.
Confirmation of plugins is handled by the "plugins" key within the toml file. In
@reset-toml, an example ReSet.toml file is visualized.

#let code = "
plugins = [\"libreset_monitors.so\", \"libyour_other_plugin.so\"]
";

#align(
  left, [#figure(
      sourcecode(raw(code, lang: "nix")), kind: "code", supplement: "Listing", caption: [ReSet toml],
    )<reset-toml>],
)
