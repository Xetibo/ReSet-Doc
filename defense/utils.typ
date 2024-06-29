#import "@preview/polylux:0.3.1": *
#import "@preview/codelst:2.0.1": sourcecode

#let regular_page_design() = [
  #align(
    right + top, [
      #v(10pt)
      #rotate(
        0deg, [#pad(
            right: 10pt, image("./figures/ReSet1_blur.png", width: 50pt, height: 50pt),
          )],
      )
    ],
  )
  #align(
    bottom, rect(
      width: 100%, height: 7%, fill: gradient.linear(rgb("222430"), rgb("#3E4152"), white),
    ),
  )
];

#let default_footer() = [
  #v(15pt)
  #columns(2, [
    #align(left + bottom, [
      #text(size: 15pt, fill: rgb("C0CAF5"), [Fabio Lenherr, Felix Tran])
    ])
    #colbreak()
    #align(right + bottom, [
      #set text(size: 20pt)
      #counter(page).display("1 of 1", both: true)
    ])
  ])
];

#let img(name, width: auto, height: auto, fit: "cover") = [
  #image("./figures/" + name, width: width, height: height, fit: fit)
  // #image("\\figures\\" + name, width: width, height: height, fit: fit)
]

#let subtitle_slide(title, level: auto) = [
  #polylux-slide[
    #align(center + horizon, heading(level: level, [
      #title
      #v(35pt)
    ]))
  ]
]

#let custom_heading(num, use_line, level, name: "", custom_tag: "", al: left) = {
  let concat_name = str(name.replace(" ", ""))
  let concat_name = str(concat_name.replace("(", ""))
  let concat_name = str(concat_name.replace(")", ""))
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
    locate(
      loc => {
        let elem = query(heading.where(body: [#name]).before(loc), loc)
        if elem == () {
          align(al, [#heading(numbering: num, level: level, name)#label(concat_name)])
        } else {
          align(al, [#heading(numbering: num, level: level, name)])
        }
      },
    )
  } else {
    align(al, [#heading(numbering: num, level: level, name)])
  }
  if use_line {
    line(length: 100%)
  }
}

#let section(num: "1.1.1", use_line: false, custom_tag: "", align: left, name) = {
  custom_heading(num, use_line, custom_tag: custom_tag, name: name, al, 1)
}

#let subsection(num: "1.1.1", use_line: false, custom_tag: "", align: left, name) = {
  custom_heading(num, use_line, custom_tag: custom_tag, name: name, al: align, 2)
}

#let subsubsection(num: "1.1.1", use_line: false, custom_tag: "", align: left, name) = {
  custom_heading(num, use_line, custom_tag: custom_tag, name: name, al: align, 3)
}

#let subsubsubsection(num: "1.1.1", use_line: false, custom_tag: "", align: left, name) = {
  custom_heading(num, use_line, custom_tag: custom_tag, name: name, al: align, 4)
}

#let subsubsubsubsection(num: "1.1.1", use_line: false, custom_tag: "", align: left, name) = {
  custom_heading(num, use_line, custom_tag: custom_tag, name: name, al: align, 5)
}

#let benefits(items) = {
  set list(marker: [+])
  set text(fill: green)
  for item in items {
    list.item(item)
  }
}

#let negatives(items) = {
  set list(marker: [-])
  set text(fill: red)
  for item in items {
    list.item(item)
  }
}
