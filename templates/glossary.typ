#let glossary_entry(use_show: true, name, description) = {
  if use_show {
    figure(
      grid(columns: (3.5fr, 8fr), gutter: 15pt, [
        #align(left, text(size: 12pt, [*#name*]))
      ], align(left, description)), kind: "glossary_entry", supplement: none, numbering: "(1)",
    )
  } else { figure([]) }
}

#let reset_glossary(use_show_ref: false) = [
  #pad(y: 10pt)[]
  #pagebreak()
]
