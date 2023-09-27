#import "@preview/codelst:1.0.0": sourcecode
#import "riskmatrix.typ": riskmatrix
#import "glossary.typ": *

#let cell(content, font_size: 12pt, cell_align: center, bold: false, width: 100%, height: 50pt) = {
  if bold {
    content = [*#content*]
  }
  rect(
    width: width,
    height: height,
    align(cell_align + horizon, [#text(size: font_size, content)]),
  )
}

#let file = counter("filecounter")
#let show_glossary() = {
  file.step()
  locate(loc => {
    let val = file.final(loc)
    if val.at(0) == 1 {
      reset_glossary()
    }
  })
}

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

#let requirement(subject, category, priority, description, measures) = {
  let cell = rect.with(inset: 8pt, width: 100%, stroke: none)
  pad(x: 0pt, y: 0pt, line(length: 100%))
  pad(x: 0pt, y: -15pt, grid(
    columns: (2fr, 10fr),
    rows: (auto, auto),
    gutter: 0pt,
    cell(height: auto)[*Subject*],
    cell(height: auto)[#subject],
    cell(height: auto)[*Requirement*],
    cell(height: auto)[#category],
    cell(height: auto)[*Priority*],
    cell(height: auto)[#priority],
    cell(height: auto)[*Description*],
    cell(height: auto)[#description],
    cell(height: auto)[*Measures*],
    cell(height: auto)[#measures],
  ))
}

#let risk(subject, description, priority, probability, severity, measures) = {
  let cell = rect.with(inset: 8pt, width: 100%, stroke: none)
  pad(x: 0pt, y: 0pt, line(length: 100%))
  pad(x: 0pt, y: -15pt, grid(
    columns: (3.5fr, 10fr),
    rows: (auto, auto),
    gutter: 0pt,
    cell(height: auto)[*Subject*],
    cell(height: auto)[#subject],
    cell(height: auto)[*Requirement*],
    cell(height: auto)[#description],
    cell(height: auto)[*Priority*],
    cell(height: auto)[#priority],
    cell(height: auto)[*Probability*&*Severity*],
    cell(height: auto)[#probability & #severity],
    cell(height: auto)[*Measures*],
    cell(height: auto)[#measures],
  ))
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
