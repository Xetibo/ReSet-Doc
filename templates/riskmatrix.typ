#let cell(text, color: none) = {
  rect(stroke: black, fill: color, width: 100%, [#align(center, [#text])])
}

#let riskmatrix() = {
  [
    #grid(
      columns: (70pt, 1fr, 1fr, 1fr, 1fr),
      rows: (auto, auto, auto, auto, auto),
      cell(color: rgb("#919191"))[Certain],
      cell(color: rgb("#DE661E"))[High],
      cell(color: rgb("#DE661E"))[High],
      cell(color: rgb("#DE1E1E"))[Very High],
      cell(color: rgb("#DE1E1E"))[Very High],
      cell(color: rgb("#919191"))[Likely],
      cell(color: rgb("#D4D614"))[Medium],
      cell(color: rgb("#DE661E"))[High],
      cell(color: rgb("#DE661E"))[High],
      cell(color: rgb("#DE1E1E"))[Very High],
      cell(color: rgb("#919191"))[Possible],
      cell(color: rgb("#44D614"))[Low],
      cell(color: rgb("#D4D614"))[Medium],
      cell(color: rgb("#DE661E"))[High],
      cell(color: rgb("#DE1E1E"))[Very High],
      cell(color: rgb("#919191"))[Unlikely],
      cell(color: rgb("#44D614"))[Low],
      cell(color: rgb("#D4D614"))[Medium],
      cell(color: rgb("#D4D614"))[Medium],
      cell(color: rgb("#DE661E"))[High],
      cell(color: rgb("#919191"))[Rare],
      cell(color: rgb("#44D614"))[Low],
      cell(color: rgb("#44D614"))[Low],
      cell(color: rgb("#D4D614"))[Medium],
      cell(color: rgb("#D4D614"))[Medium],
      cell(color: rgb("#919191"))[Eliminated],
      cell(color: rgb("#14D69D"))[Eliminated],
      cell(color: rgb("#14D69D"))[Eliminated],
      cell(color: rgb("#14D69D"))[Eliminated],
      cell(color: rgb("#14D69D"))[Eliminated],
      cell(color: rgb("#919191"))[\ ],
      cell(color: rgb("#919191"))[Minor],
      cell(color: rgb("#919191"))[Marginal],
      cell(color: rgb("#919191"))[Critical],
      cell(color: rgb("#919191"))[Catastrophic],
    )
    #pad(top: -13pt, grid(
      columns: (70pt, auto),
      rows: (auto),
      cell(color: rgb("#919191"))[Probability],
      cell(color: rgb("#919191"))[Severity],
    ))
  ]
}
