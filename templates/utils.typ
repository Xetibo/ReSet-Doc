#import "@preview/codelst:1.0.0": sourcecode
#import "riskmatrix.typ": riskmatrix
#import "glossary.typ": *
#import "mock_labels.typ": *

#let glossary_entry(content) = {
  [content]
  super(cite(label(content)))
}

#let cell(
  content,
  font_size: 12pt,
  cell_align: center,
  color: black,
  bold: false,
  use_rect: false,
  use_under: false,
  fill: luma(255),
  width: 100%,
  height: 100%,
) = {
  if bold {
    content = [*#content*]
  }
  if use_rect {
    rect(
      width: width,
      height: height,
      fill: fill,
      outset: (x: 1pt, y: 0pt),
      stroke: 1pt,
      align(cell_align + horizon, [#text(fill: color, size: font_size, content)]),
    )
  } else if use_under {
    rect(
      width: width,
      height: height,
      fill: fill,
      outset: (x: 1pt, y: 0pt),
      stroke: (top: 0pt, right: 0pt, left: 0pt, bottom: 1pt),
      align(cell_align + horizon, [#text(fill: color, size: font_size, content)]),
    )
  } else {
    rect(
      width: width,
      height: height,
      fill: fill,
      outset: (x: 1pt, y: 0pt),
      stroke: none,
      align(cell_align + horizon, [#text(fill: color, size: font_size, content)]),
    )
  }
}

#let img(name, width: auto, fit: "cover", extension: "figures") = {
  let name = "../" + extension + "/" + name
  image(name, width: width, fit: fit)
}

#let file = counter("filecounter")
#let lsp_placate() = {
  file.step()
  locate(loc => {
    let val = file.final(loc)
    if val.at(0) == 1 {
      insert_mocks(loc)
      reset_glossary()
      bibliography("/files/bib.yml")
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

#let custom_heading(num, use_line, level, name: "", custom_tag: "") = {
  let concat_name = str(name.replace(" ", ""))
  if custom_tag != "" {
    locate(
      loc => {
        let elem = query(heading.where(body: [#custom_tag]), loc)
        if elem == () {
          align(left, [#heading(numbering: num, level: level, name)#label(custom_tag)])
        } else {
          align(left, [#heading(numbering: num, level: level, name)])
        }
      },
    )
  } else if num != "" and type(name) == type("string") {
    locate(loc => {
      let elem = query(heading.where(body: [#name]).before(loc), loc)
      if elem == () {
        align(
          left,
          [#heading(numbering: num, level: level, name)#label(concat_name)],
        )
      } else {
        align(left, [#heading(numbering: num, level: level, name)])
      }
    })
  } else {
    align(left, [#heading(numbering: num, level: level, name)])
  }
  if use_line {
    line(length: 100%)
  }
}

#let section(num: "1.1.1", use_line: false, custom_tag: "", name) = {
  custom_heading(num, use_line, custom_tag: custom_tag, name: name, 1)
}

#let subsection(num: "1.1.1", use_line: false, custom_tag: "", name) = {
  custom_heading(num, use_line, custom_tag: custom_tag, name: name, 2)
}

#let subsubsection(num: "1.1.1", use_line: false, custom_tag: "", name) = {
  custom_heading(num, use_line, custom_tag: custom_tag, name: name, 3)
}

#let subsubsubsection(num: "1.1.1", use_line: false, custom_tag: "", name) = {
  custom_heading(num, use_line, custom_tag: custom_tag, name: name, 4)
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

#let test(subject, description, feedback) = {
  let cell = rect.with(inset: 8pt, width: 100%, stroke: none)
  pad(x: 0pt, y: 0pt, line(length: 100%))
  pad(x: 0pt, y: -15pt, grid(
    columns: (2fr, 10fr),
    rows: (auto, auto, auto),
    gutter: 0pt,
    cell(height: auto)[*Subject*],
    cell(height: auto)[#subject],
    cell(height: auto)[*Description*],
    cell(height: auto)[#description],
    cell(height: auto)[*Feedback*],
    cell(height: auto)[#feedback],
  ))
  pad(x: 0pt, y: 0pt, line(length: 100%))
}
