#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Planning")
#subsection("Methods")
*Project Management* | ReSet is managed using Scrum.\
_Due to the small team size, no scrum master or product owner is chosen, the work
of these positions is done in collaboration._\

#subsubsection("Requirements")
Non-functional requirements are explained in @Non-FunctionalRequirements and
functional requirements are handled using user-stories.

#subsubsection("User Stories")
User stories are handled via #link("https://github.com/Xetibo/ReSet/issues")[GitHub issues].
This allows for simple handling of labels and function points, which can also be
changed later on if needed.

#subsubsection("Sprint Backlog/Product Backlog")
Both the sprint backlog and the product backlog are handled using the #link("https://github.com/orgs/Xetibo/projects/1")[GitHub project board].
This allows for a clean and automatic handling of created user stories via
GitHub issues.

#subsection("Time")
As an agile methodology is used, long-term time management is only broad
guidance and does not necessarily overlap with reality. In other words, with a 2
week sprint, only 2 weeks are considered well planned out. By week 4, work on
the backend implementation should be started. The minimal working UI milestone
is in week 7, so UI Reviews can be assessed and corrections can be applied
early. By week 12 the minimal viable product should be in production state, in
order to leave time for reflection and documentation.
#pagebreak()

#page(
  flipped: true,
)[
  #align(
    center, [#figure(
        image("../../figures/ganntTimePlanning.png", width: 110%), caption: [Time management],
      )],
  )
]
