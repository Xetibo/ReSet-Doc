#import "@preview/codelst:1.0.0": sourcecode

#let section(num: "1.1.1", use_line: false, name) = {
  align(center, [#heading(numbering: num, level: 1, name)])
  if use_line {
    line(length: 100%)
  }
}

#let subsection(num: "1.1.1", use_line: false, name) = {
  align(center, [#heading(numbering: num, level: 2, name)])
  if use_line {
    line(length: 100%)
  }
}

#let subsubsection(num: "1.1.1", use_line: false, name) = {
  align(center, [#heading(numbering: num, level: 3, name)])
  if use_line {
    line(length: 100%)
  }
}

#let subsubsubsection(num: "1.1.1", use_line: false, name) = {
  align(center, [#heading(numbering: num, level: 4, name)])
  if use_line {
    line(length: 100%)
  }
}

#let requirement(subject, description, priority, risk, measures) = {
  let cell = rect.with(inset: 8pt, width: 100%, stroke: none)
  pad(x: 0pt, y: 0pt, line(length: 100%))
  pad(x: 0pt, y: -15pt, grid(
    columns: (2fr, 10fr),
    rows: (auto, auto),
    gutter: 0pt,
    cell(height: auto)[*Subject*],
    cell(height: auto)[#subject],
    cell(height: auto)[*Requirement*],
    cell(height: auto)[#description],
    cell(height: auto)[*Priority*],
    cell(height: auto)[#priority],
    cell(height: auto)[*Risk*],
    cell(height: auto)[#risk],
    cell(height: auto)[*Measures*],
    cell(height: auto)[#measures],
  ))
  pad(x: 0pt, y: 0pt, line(length: 100%))
}

#let test(subject, description, positives, negatives, notes) = {
  let cell = rect.with(inset: 8pt, width: 100%, stroke: none)
  pad(x: 0pt, y: 0pt, line(length: 100%))
  pad(x: 0pt, y: -15pt, grid(
    columns: (2fr, 10fr),
    rows: (auto, auto),
    gutter: 0pt,
    cell(height: auto)[*Subject*],
    cell(height: auto)[#subject],
    cell(height: auto)[*Description*],
    cell(height: auto)[#description],
    cell(height: auto)[*Positives*],
    cell(height: auto)[#positives],
    cell(height: auto)[*Negatives*],
    cell(height: auto)[#negatives],
    cell(height: auto)[*Notes*],
    cell(height: auto)[#notes],
  ))
  pad(x: 0pt, y: 0pt, line(length: 100%))
}

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
  doc,
) = {
  set document(title: title, author: author)
  set align(center)
  set par(justify: true)
  align(center + horizon, [
    #pad(y: 5pt, text(25pt, title))
    #align(left, line(start: (5%, 0%), end: (95%, 0%)))
    #pad(y: 5pt, text(14pt, [Authors: #author]))
    #align(left, line(start: (15%, 0%), end: (85%, 0%)))
    #pad(y: 5pt, text(14pt, [Project Advisor: #professor]))

    #pad(y: 40pt, align(center, [#image(title_image, width: title_image_size)]))

  ])
  align(center + bottom , [
    #pad(y: 40pt, align(center, [#image(establishment_image, width: establishment_image_size)]))
    #pad(y: 5pt, text(14pt, [#department]))
    #pad(y: 5pt, text(14pt, [#establishment]))
  ])
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
  show bibliography: set heading(numbering: "1.1.1", level: 2)
  bibliography("works.yml")
  pagebreak()
  section(num: "1.1.1", use_line: false, "List of Figures")
  outline(title: none, target: figure)
  set align(left)
}
