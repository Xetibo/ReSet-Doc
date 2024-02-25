#import "../templates/utils.typ": *
#lsp_placate()

#section("Introduction")
/* This paper focuses on the improvement of the ReSet settings application. The improvements cover a large variety of topics, including a plugin system/* @plugin_system */, attending accessibility concerns in/* @accessibility */, creating a testing framework for DBus functionality in/* @test_framework */, animations for the ReSet user interface and creating a command line application to interface with ReSet. */

#subsection("Objectives")
ReSet will mainly focus on the plugin system, which allows it to expand its features 
repertoire to include keyboard, monitors, status bars and many more settings. This expands 
the functionality beyond ReSet as a user interface, and instead allows it to be a middleman 
between compositor and shell components. It also allows for the community to create their 
own plugin to expand the functionalities of ReSet.

Furthermore, ReSet will add animations to improve its user experience which helps to better 
understand the flow of the application, attend to accessibility concerns to make it more user 
friendly, testing framework for DBus functionalities and a command line application to 
interface with ReSet. 

#subsection("Challenges")
- *Consistency* \
  With the advent of the plugin system, the importance of a consistent experience more relevant as creating an application with multiple technologies and use cases is not trivial.
- *Accessibility* \
  Creating a good user experience and making the application accessible to all users requires a deep understanding of the user base which could require a lot of time. 
- *Maintainability* \
  With increasing features, the technical debt might increase and become a potential slowdown 
  in development or release cycles.

#subsection("Methodology")
In @Prelude, the different approaches to the plugin system are listed and discussed. 
With this information, the best approach will be chosen and explained in /*@something*/. 
Other features and improvements are discussed in /*@sometime*/. The implementation 
details can be found in /*@somewhere*/. The result will be discussed in /*@somehow*/ 
and potential future work are mentioned in /*@somewhereelse*/.