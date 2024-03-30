#import "../utils.typ": *

#subtitle_slide("Plugin System")

#polylux-slide[
  === Architecture
  #align(center, img("dynamic_libraries.svg", width: 59%))
]

#polylux-slide[
  === Other Ideas
  #grid(
    columns: (1fr, 2.3fr), rows: (auto), [
      #align(center, img("hourglass.svg", width: 100%, fit: "contain"))
    ], [
      #rotate(20deg, align(center, img("interpreted_languages.svg", width: 100%)))
    ],
  )
]

#polylux-slide[
=== Testing
#grid(columns: (1.5fr, 2fr), rows: (auto), [
  - Plugin Developer defines:
    - Unit tests
    - Integrations tests
  - Issues:
    - Integrate tests from plugin into daemon
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
]

#polylux-slide[
  === Security
  \
  - Issues
    - Easy to inject malicious plugin
    - Security requires code review
  - Mitigations
    - Enforce OSS -> Copyleft
    - Permission system
]

#polylux-slide[
  === Developer Experience 
  \
  - Flexibility 
    - Ability to choose language 
    - Ability to choose toolkit
  - Stability
    - Stable ABI -> not too many changes
    - Good documentation
]
