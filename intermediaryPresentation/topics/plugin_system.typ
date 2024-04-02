#import "../utils.typ": *

#subtitle_slide("Plugin System")

#polylux-slide[
=== Architecture
#align(center, img("dynamic_libraries.svg", width: 59%))
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
=== Other Ideas
#grid(
  columns: (1fr, 2.3fr),
  rows: (auto),
  [
    #align(center, img("hourglass.svg", width: 100%, fit: "contain"))
  ],
  [
    #rotate(20deg, align(center, img("interpreted_languages.svg", width: 100%)))
  ],
)
#pdfpc.speaker-note(```md
    - hourglass
      - extension of previous architecture
      - potential for other languages
      - common for proprietary libraries
      - works for all programming languages
    - interpreted languages
      - 2 interpreters
      - runtime overhead
      - easier plugin definiton for plugin developers
      - need to create UI snippets for plugin developers
        - or integrate luaGTK
    ```)
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
=== Security
\
- Issues
  - Easy to inject malicious plugin
  - Security requires code review
- Mitigations
  - Enforce OSS -> Copyleft
  - Permission system
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
- Flexibility
  - Ability to choose language
  - Ability to choose toolkit
- Stability
  - Stable ABI -> not too many changes
  - Good documentation
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
