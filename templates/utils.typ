#import "@preview/codelst:1.0.0": sourcecode
#import "riskmatrix.typ": riskmatrix
#import "glossary.typ": *
#import "mock_labels.typ": *

#let cell(
  content,
  font_size: 12pt,
  cell_align: center,
  color: black,
  bold: false,
  width: 100%,
  height: 100%,
) = {
  if bold {
    content = [*#content*]
  }
  rect(
    width: width,
    height: height,
    align(cell_align + horizon, [#text(fill: color, size: font_size, content)]),
  )
}

#let file = counter("filecounter")
#let lsp_placate() = {
  file.step()
  locate(loc => {
    let val = file.final(loc)
    if val.at(0) == 1 {
      reset_glossary()
      mock_labels
      bibliography("../files/bib.yml")
    }
  })
}

#let calculate_total(tool, weights) = {
  let total = 0;
  for (key, value) in tool {
    total += value * weights.at(key);
  }
  calc.ceil(total)
}

#let custom_heading(num, use_line, level, name: "") = {
  if num != "" and type(name) == type("string") {
    align(
      center,
      [#heading(numbering: num, level: level, name)#label(str(name.replace(" ", "")))],
    )
  } else {
    align(center, [#heading(numbering: num, level: level, name)])
  }
  if use_line {
    line(length: 100%)
  }
}

#let section(num: "1.1.1", use_line: false, name) = {
  custom_heading(num, use_line, name: name, 1)
}

#let subsection(num: "1.1.1", use_line: false, name) = {
  custom_heading(num, use_line, name: name, 2)
}

#let subsubsection(num: "1.1.1", use_line: false, name) = {
  custom_heading(num, use_line, name: name, 3)
}

#let subsubsubsection(num: "1.1.1", use_line: false, name) = {
  custom_heading(num, use_line, name: name, 4)
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
