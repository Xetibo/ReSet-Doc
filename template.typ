/* page setup */
#let conf(author: "Fabio Lenherr", title, subtitle, doc) = {
  set document(title: title, author: author) 
  set align(center)
  set par(justify: true)
  align(center + horizon, [
  #text(17pt, title)
  #line(length: 100%)
  #text(10pt, author)
  #line(start: (25%, 0%), end: (75%, 0%))
  #text(9pt, subtitle)
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
  show raw.where(block: true): content => block(
    width: 100%,
    fill: luma(240),
    stroke: 1pt + maroon,
    radius: 3pt,
    inset: 5pt,
    clip: false,
    {
      let numbers = true
      let stepnumber = 1
      let numberfirstline = false
      let numberstyle = auto
      let firstnumber = 1
      let highlight = none
      let (columns, align, make_row) = {
       if numbers {
        // line numbering requested
        if type(numberstyle) == "auto" {
          numberstyle = text.with(style: "italic", 
                                  slashed-zero: true, 
                                  size: .6em)
        }
        ( ( auto, 1fr ),
          ( right + horizon, left ),
          e => {
            let (i, l) = e
            let n = i + firstnumber
            let n_str = if (calc.mod(n, stepnumber) == 0) or (numberfirstline and i == 0) { numberstyle(str(n)) } else { none }
            (n_str + h(.5em), raw(lang: content.lang, l))
          }
        )
      } else {
        ( ( 1fr, ),
          ( left, ),
          e => {
            let (i, l) = e
            raw( lang:content.lang, l)
          }
        )
       }
      }
      table(
          stroke:none,
          columns: columns,
          rows: (auto,),
          gutter: 0pt,
          inset: 2pt,
          align: (col, _) => align.at(col),
          ..content
              .text
              .split("\n")
              .enumerate()
              .map(make_row)
              .flatten()
              .map(c => if c.has("text") and c.text == "" { v(1em) } else { c })
      )
    }
  )
  doc
}

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

