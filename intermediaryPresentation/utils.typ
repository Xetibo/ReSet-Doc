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
  //#image("./figures/" + name, width: width, height: height, fit: fit)
  #image("./figures/" + name, width: width, height: height, fit: fit)
]

#let subtitle_slide(title, level: auto) = [
  #polylux-slide[
    #align(center + horizon, heading(level: level, [
      #title
      #v(35pt)
    ]))
  ]
]
