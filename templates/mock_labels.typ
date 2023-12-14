// needed for the language server to not complain about unseen labels
// Both headings and figures can be "mocked" here in order to reference it
// the value doesn't matter as it is only for the LSP to not show unnecessary errors
// this can't be automated without changes to typst itself
#let insert_mocks(loc) = {
  let mock_labels = (
    "Analysisofexistingapplications",
    "Introduction",
    "UserInterfaces",
    "Implementation",
    "Architecture",
    "Conclusion",
    "Improvements",
    "DaemonImplementation",
    "DBus",
  )
  for label_string in mock_labels {
    let elem = query(heading.where(body: [#label_string]), loc)
    if elem == () {
      [#heading(label_string, numbering: "1")#label(label_string)]
    } 
  }
}
