#import "utils.typ": *
#import "glossary.typ": *

/* page setup */
#let conf(
  author: "Fabio Lenherr",
  professor,
  title,
  title_image,
  title_image_size,
  establishment_image,
  establishment_image_size,
  department,
  establishment,
  abstract,
  acknowledgements,
  doc,
) = {
  set document(title: title, author: author)
  set align(center)
  set par(justify: true)
  align(
    center + horizon,
    [
      #pad(y: 5pt, text(25pt, title))
      #align(left, line(start: (5%, 0%), end: (95%, 0%)))
      #pad(y: 5pt, text(14pt, [Authors: #author]))
      #align(left, line(start: (15%, 0%), end: (85%, 0%)))
      #pad(y: 5pt, text(14pt, [Project Advisor: #professor]))
      #pad(y: 40pt, align(center, [#image(title_image, width: title_image_size)]))
    ],
  )
  align(
    center + bottom,
    [
      #pad(
        y: 40pt,
        align(center, [#image(establishment_image, width: establishment_image_size)]),
      )
      #pad(y: 5pt, text(14pt, [#department]))
      #pad(y: 5pt, text(14pt, [#establishment]))
    ],
  )
  pagebreak(weak: false)
  heading("Abstract", numbering: none, bookmarked: false, outlined: false)
  abstract
  pagebreak()
  heading(
    "Acknowledgements",
    numbering: none,
    bookmarked: false,
    outlined: false,
  )
  acknowledgements
  pagebreak(weak: false)
  outline(title: "Table of Contents", indent: true, depth: 3)
  pagebreak(weak: false)
  set page(paper: "a4", margin: (x: 2.54cm, y: 2.54cm), header: [
    #smallcaps(author)
    #h(1fr) #emph(title)
  ], header-ascent: 100% - 30pt, footer: [
    #align(center, [#counter(page).display(both: false)])
  ], footer-descent: 100% - 25pt)
  counter(page).update(1)
  set align(left)
  doc
  set page(footer: none)
  set align(center)
  section(num: "1.1.1", use_line: false, "Appendix")
  subsection("Glossary")
  reset_glossary(use_show_ref: true)
  subsection(num: "1.1.1", use_line: false, "Bibliography")
  bibliography("/works.yml", title: none)
  pagebreak()
  subsection(num: "1.1.1", use_line: false, "List of Figures")
  outline(title: none, target: figure)
  set align(left)
}
