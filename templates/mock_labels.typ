// needed for the language server to not complain about unseen labels
// Both headings and figures can be "mocked" here in order to reference it
// the value doesn't matter as it is only for the LSP to not show unnecessary errors
// this can't be automated without changes to typst itself
#let mock_labels = [
  #heading("Previous Work", numbering: "1")<PreviousWork>
  #heading("Introduction", numbering: "1")<introduction>
]
