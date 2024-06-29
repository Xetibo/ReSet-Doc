#import "../utils.typ": *

// TODO:
// change summary []
// methodology notes []
// plugin system notes []
// monitor notes []
// distribution notes []
// technologies notes []

#subtitle_slide("Plugin System")

#polylux-slide[
=== Analyzed Paragidms
#columns(
  2, gutter: 40pt, [
    #set text(size: 15pt)
    #subsubsubsubsection(num: none, "Dynamic Libraries")
    #align(center, img("dynamic_libraries.svg", width: 100%, fit: "contain"))
    #colbreak()
    #box(
      fill: none, stroke: none, [
        #subsubsubsubsection(num: none, "Interpreted Languages")
        #align(center, img("interpreted_languages.svg", height: 90%, fit: "contain"))
      ],
    )
    #set text(size: 20pt)
  ],
)
#pdfpc.speaker-note(```md
    - shared libraries
      - only in memory once!
      - common for all operating systems
    - communication over DBus
      - unix compatible
      - common -> used for networking and bluetooth
    ```)
]

#polylux-slide[
  === Comparison
  \
  #columns(
    2, gutter: 40pt, [
      #box(
        fill: none, stroke: none, [
          #subsubsubsubsection(num: none, "Dynamic Libraries")
          #v(15pt)
          #benefits(
            ("Less memory usage", "Better performance", "Guaranteed compatibility"),
          )
          #negatives(("Language interoperability", "User experience"))
        ],
      )
      #colbreak()
      #box(
        fill: none, stroke: none, [
          #subsubsubsubsection(num: none, "Interpreted Languages")
          #v(15pt)
          #benefits(
            ("User experience", "Simple extendability", "ABI stability guaranteed"),
          )
          #negatives(
            (
              "Interpreter per process", "Performance overhead", "Implementation overhead", "Limited compatibility",
            ),
          )
        ],
      )
      #set text(size: 20pt)
    ],
  )

]

#polylux-slide[
=== Resulting Architecture
#align(center, img("poster.svg", width: 100%, fit: "contain"))
#pdfpc.speaker-note(```md
    - shared libraries
      - only in memory once!
      - common for all operating systems
    - communication over DBus
      - unix compatible
      - common -> used for networking and bluetooth
    ```)
]

#polylux-slide[
=== Plugin API
#sourcecode(```rs
  pub fn backend_startup();

  pub fn backend_shutdown();

  pub fn capabilities() -> PluginCapabilities;

  pub fn name() -> String;

  pub fn dbus_interface(cross: &mut Crossroads);

  pub fn backend_tests();
  ```)
#pdfpc.speaker-note(```md
- explain each function
- explain why crossroads was an issue
    ```)
]

#polylux-slide[
=== Macros
#grid(columns: (1.2fr, 1.5fr), rows: auto, [
*Release*
#sourcecode(```rs
#[macro_export]
#[cfg(not(debug_assertions))]
macro_rules! LOG {
  ($message:expr) => {{}};
}```)
], [
*Debug*
#sourcecode(```rs
#[macro_export]
#[cfg(any(debug_assertions, test))]
macro_rules! LOG {
  ($message:expr) => {{
    write_log_to_file!($message);
    println!("LOG: {}", $message);
  }};
}```)
])
]

#polylux-slide[
=== Testing
\
#grid(columns: (1.5fr, 2fr), rows: (auto), [
  - Plugin Developer defines:
    - Unit tests
    - Integrations tests
  - Issues:
    - Integrate tests from\
      plugin into daemon
], [
#set text(13pt)
#sourcecode(```rs
 let mut buffer = String::from("");
 buffer += &format!(
 "\n----------- Plugin Tests for {} -----------\n\n",
 plugin_name.as_ref()
 );
 buffer += &format!("running {} tests:\n", running_index);
 buffer += &running;
 buffer += &format!("\n{} tests crashed:\n", crashed_index);
 buffer += &crashed;
 buffer += &format!("\n{} tests failed:\n", failed_index);
 buffer += &failed;
 buffer += &format!("\n{} tests successful:\n", success_index);
 buffer += &success;
 buffer += "\n----------- Plugin Tests end -----------\n\n";
 print!("{}", buffer);
 ```)
#set text(20pt)
])
#pdfpc.speaker-note(```md
- mock
  - fake bluetooth
  - fake network
  - sound not possible
- plugins
  - custom result prints
  - all tests independent -> different thread
    ```)
]

#polylux-slide[
=== Threading\
#sourcecode(```rs
thread::scope(|scope| {
  let wrapper = Arc::new(RwLock::new(CrossWrapper::new(&mut cross)));
  for plugin in BACKEND_PLUGINS.iter() {
    let wrapper_loop = wrapper.clone();
    scope.spawn(move || {
      // allocate plugin specific things
      (plugin.startup)();
      // register and insert plugin interfaces
      (plugin.data)(wrapper_loop);
      let _name = (plugin.name)();
      LOG!(format!("Loaded plugin: {}", _name));
    });
  }
});
```)
]

#polylux-slide[
=== Security
\
#columns(2, [
  - Issues
    - Easy to inject malicious plugin
    - Security requires code review
  - Mitigations
    - Enforce OSS -> Copyleft
    - Permission system
    #colbreak()
    #v(20pt)
    #align(center, image("../figures/security.svg", width: 40%))
])
#pdfpc.speaker-note(```md
- issues
  - arbitrary code execution
  - malicious plugin copied into folder
  - review necessary -> takes time, infeasible
- mitigations
  - enforce copyleft to make it "illegal" to create proprietary plugins
  - permission system
    - user needs to accept plugin on first load
    - plugin hash stored within user wallet
      - kwallet, gnome keyring etc
    ```)
]

#polylux-slide[
=== Developer Experience
\
#columns(2, [
  - Flexibility
    - Ability to choose language
    - Ability to choose toolkit
  - Stability
    - Stable ABI -> not too many changes
    - Good documentation
    #colbreak()
    #v(-20pt)
    #align(center, image("../figures/documentation.svg", width: 30%))
    #align(center, image("../figures/bugs.svg", width: 30%))
])
#pdfpc.speaker-note(```md
- flexibility
  - language
    - hard to achieve with DBus and gtk wrappers
      - requires modifications to both
  - toolkit
    - not possible with ReSets own user interface
    - but reset can be used without it, hence you can create your own
  - stability
    - rust provides good documentation with documentation tests
    ```)
]
