#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Planning methods")
*Project Management* | ReSet is managed using Scrum.\
_Due to the small team size, no scrum master or product owner is chosen, the work
of these positions is done in collaboration._\

#subsubsection("Project Plan")
The broad project plan is created with a GANTT diagram which is visualized in @gantt-diagram.

#subsubsection("User Stories")
User stories are handled via GitHub issues. // @github_issues.
This allows for simple handling of labels and function points, which can also be
changed later on if needed.

#subsubsection("Sprint Backlog/Product Backlog")
Both the sprint backlog and the product backlog are handled using the GitHub project 
board. // @github_project_board.
This allows for a clean and automatic handling of created user stories via
GitHub issues. //@github_issues.

#subsubsection("Tools")
Rust is an editor-agnostic language, hence both team members can use their tools 
without conflicts. For documentation typst is used, which also does not require 
a special editor, it just requires a compiler that works on all platforms. The user 
interface is made with Cambalache.

#subsubsection("Time")
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
        image("../../figures/timeplanning.png", width: 115%), caption: [Time management],
      )<gantt-diagram>],
  )
]
