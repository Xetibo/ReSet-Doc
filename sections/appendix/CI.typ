#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Continous Integration")
In this section the continuous integration workflows for ReSet are discussed.

For ReSet, two different workflows are necessary, the first is a build after
pull request and build on main branch push, which was realized using the github
workflows. Important to note is that for the ReSet application itself, the
self-hosted github runner was used. This is due to the regular github runner
only offering older versions of Ubuntu, which make the use of newer GTK and
libadwaita libraries impossible. Using the self-hosted runner, it was possible
to provide a build system with an up-to-date version of Ubuntu.@github_runners

#figure(sourcecode(```yml
name: Rust

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

env:
  CARGO_TERM_COLOR: always

jobs:
  build:
    runs-on: [self-hosted, ubuntu]
    steps:
      - uses: actions/checkout@v3
      - name: nightly-rust
        uses: actions-rs/toolchain@v1
        with:
          profile: minimal
          toolchain: nightly
      - name: Build
        run: cargo build --verbose
      - name: Run clippy
        run: cargo clippy --fix
```),
kind: "code", 
supplement: "Listing",
caption: [ReSet build workflow])<reset_build_workflow>

For the ReSet frontend, there are currently no tests as of now. GTK has a few
tools to test the user interface, but it is not the most extensive
documentation, and considering the already limited time for this project, this
was not pursued. Usually the logic of the frontend would be tested instead, but
here all functions call DBus functions which means all functionality is
implemented in the backend.

On the backend there are initial tests, but those can't be run on the build
system either as they rely on hardware features(Wi-Fi, Bluetooth, audio), which
can't be provided appropriately within a test environment. In @Testing, a
plan for a mock system is explained for a continuation work.

The second workflow for ReSet is more complicated, as it requires different
Linux version in order to provide easy packaging of ReSet. For ReSet, five
different variations of packaging will be provided: Flatpak, Debian Package, Arch
Package, regular binary and the crates.io cargo package. Nearly all of these
will offer the same experience, with the only exception being the flatpak
package, which can't be used to run the daemon in a standalone fashion. In order
to still provide ReSet, the daemon is built into the ReSet frontend, and will be
run for the duration of the application lifetime, should the daemon not already
be running.

#figure(sourcecode(```rs
async fn daemon_check() {
    let handle = thread::spawn(|| {
        let conn = Connection::new_session().unwrap();
        let proxy = conn.with_proxy(
            BASE,
            DBUS_PATH,
            Duration::from_millis(100),
        );
        let res: Result<(), Error> =
            proxy.method_call(BASE, "RegisterClient", ("ReSet",));
        res
    });
    let res = handle.join();
    if res.unwrap().is_err() {
        // daemon was not running, start the daemon now
        run_daemon().await;
    } 
}
```),
kind: "code", 
supplement: "Listing",
caption: [Daemon check within main.rs])<daemon_check>

In @build_ubuntu the ubuntu runner configuration is shown, which builds the binary, the flatpak and the debian package.

#figure(sourcecode(```yaml
# omitted setup
runs-on: [self-hosted, ubuntu]
steps:
  - uses: actions/checkout@v3
  - name: nightly-rust
    uses: actions-rs/toolchain@v1
    with:
      profile: minimal
      toolchain: nightly
  - name: Build rust package
    run: cargo build --release --verbose
  - name: Build Flatpak
    run: |
      cd flatpak
      ./build.sh
  - name: Build Ubuntu package
    run: |
      cp ./target/release/reset ./debian/.
      dpkg-deb --build debian
      mv debian.deb reset.deb
  - name: Release
    uses: softprops/action-gh-release@v1
    with:
      files: |
        target/release/reset
        flatpak/reset.flatpak
        reset.deb
```), 
kind: "code", 
supplement: "Listing",
caption: [ReSet build workflow on Ubuntu])<build_ubuntu>

In @build_arch the arch runner configuration is shown, which builds the arch package.

#figure(sourcecode(```yaml
# omitted setup
runs-on: [self-hosted, arch]
steps:
  - uses: actions/checkout@v3
  - name: nightly-rust
    uses: actions-rs/toolchain@v1
    with:
      profile: minimal
      toolchain: nightly
  - name: Build rust package
    run: makepkg PKGBUILD
  - name: Release
    uses: softprops/action-gh-release@v1
    with:
      files: |
        reset-${{github.ref_name}}-0-x86_64.pkg.tar.zst
```), 
kind: "code", 
supplement: "Listing",
caption: [ReSet build workflow on Arch])<build_arch>

#figure(sourcecode(```sh
pkgname=reset
pkgver=0.1.1
pkgrel=0
arch=('x86_64')
pkgdir="/usr/bin/${pkgname}"
pkgdesc="A wip universal Linux settings application."
depends=('rust' 'gtk4' 'dbus')

build() {
	cargo build --release
}

package() {
	cd ..
	install -Dm755 target/release/"$pkgname" "$pkgdir"/usr/bin/"$pkgname"
	install -Dm644 "$pkgname.desktop" "$pkgdir/usr/share/applications/$pkgname.desktop"
	install -Dm644 "src/resources/icons/ReSet.svg" "$pkgdir/usr/share/pixmaps/ReSet.svg"
}
```), 
kind: "code", 
supplement: "Listing",
caption: [PKGBUILD to build the arch package])<arch_package>
