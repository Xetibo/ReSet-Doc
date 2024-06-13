#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Retrospective")
In this section, both team members will reflect on their experience in the
project and elaborate on their takeaways.

#subsubsection("Fabio Lenherr")
This project reinforced the importance of documentation for me. We were stuck
multiple times in this project, solely due to ambiguous documentation of an
endpoint for our two plugins. It made it very clear that even the best looking
API cannot be used by developers if it does not tell you _how_ to use it. And it
goes even further than just using the API, if developers have to first
experiment with the API in order to understand it, it is essentially impossible
to create tests for the API before you already implemented what you needed.
Especially with an API the test driven development could make sense, but it is
only possible with the previously mentioned requirement.

Further, as the agile methodology states, users should test the application
continuously. This was proven correct as the user tests resulted in edge cases
being found and documented, which in return resulted in late fixes for said
issues. While we did not have a customer for this project, and therefore could
not rely on this, it did make it clear, that users need to be at the forefront
of testing for a great result.

In the end, I am satisfied with the result of this project, and I am looking
forward to maintaining the project after the thesis. It will be the ultimate
test for the viability of both the plugin system and the original ReSet
application.

#subsubsection("Felix Tran")
Overall, I am satisfied with the plugin system and the plugins we created over 
the last few months. This project has been a significant learning experience for
me that will be useful even years down the line. While we did plan too much and 
had to cut some optional features, all the main features have been implemented 
successfully. This is again a reminder, that project planning can be easily 
overestimated like in the SA and we're in a lucky position where we can just 
remove features at a whim.

I learned a lot in this project because it was the first time I had to work 
with a low-level language. Though I wouldn't do it again willingly, it was 
nevertheless a good experience to have as the knowledge gained working on this
project can also be applied to other languages.