#import "@preview/codelst:1.0.0": sourcecode
#let section(name) = {
  align(center, [#heading(numbering: "1.1.1.", level: 1,name)])
  line(length: 100%)
}

#let subsection(name) = {
  align(center, [#heading(numbering: "1.1.1.", level: 2,name)])
  line(length: 100%)
}

#let subsubsection(name) = {
  align(center, [#heading(numbering: "1.1.1.", level: 3,name)])
  line(length: 100%)
}

#let subsubsubsection(name) = {
  align(center, [#heading(numbering: "1.1.1.", level: 4,name)])
  line(length: 100%)
}

/* page setup */
#let conf(author: "Fabio Lenherr", professor, title, doc) = {
  set document(title: title, author: author) 
  set align(center)
  set par(justify: true)
  align(center + horizon, [
  #pad(y: 5pt, text(25pt, title))
  #align(left,line(start: (5%, 0%), end: (95%, 0%)))
  #pad(y: 5pt, text(14pt, author))
  #align(left,line(start: (15%, 0%), end: (85%, 0%)))
  #pad(y: 5pt, text(14pt, professor))

  #pad(y: 40pt, align(center, [#image("figures/ReSet1.svg", width: 25%)]))

  ])
  pagebreak(weak: false)
  outline(title: "Table of Contents", indent: true, depth: 3)
  pagebreak(weak: false)
  set page(
    paper: "a4",
    margin: (x: 1.5cm, top: 50pt),
    header: [
      #smallcaps(author)
      #h(1fr)  #emph(title)
    ],
    header-ascent: 100% - 30pt,
    footer: [
      #align(center,
        [#counter(page).display(
          both: false,
        )]
      )
    ],
    footer-descent: 100% - 25pt
  )
  counter(page).update(1)
  set align(left)
  doc
  set page(footer: none )
  pagebreak(weak: false)
  set align(center)
  bibliography("works.yml")
  pagebreak()
  section("List of Figures")
  outline(
    title: none,
    target: figure.where(kind: image),
  )
  set align(left)
}
