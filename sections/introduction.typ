#import "../templates/utils.typ": *
#show_glossary()

#section("Introduction")
The Linux ecosystem is well known to be fractured, whether it's the seemingly
endless amount of distributions, or the various different desktop
environments[@DE] there will always be someone who will create something new.
With this reality comes a challenge to create software that is not dependent on
one singular distribution or environment.

This project will focus on one specific problem, namely the lack of universality
when interacting with configuration tools. Whenever a user would like to connect
to a network, they have to do this with their environment specific tool, should
that environment simply not provide one, then they will have to find one
specifically for this task.

ReSet will make the effort to change this situation by providing a settings
application that works across these distributions and environments, therefore
eliminating the need to install one tool for each task.\
While the UNIX philosophy considers one tool for each task to be the proper
solution, ReSet would argue that this is not the case with a tool featuring user
interfaces, here instead it would lead to unnecessary screen space being used
for no reason.

// no universal app
#subsection("Solution")
ReSet will be a set of 2 applications featuring one user interface application
that will have common settings available for the user.\
The second part of ReSet will be a daemon, which will be used to interact with
necessary services, such as audio servers, configuration files and more.\
This configuration also allows us to deliver an API, with which other
applications can interact with the daemon, this means that ReSet can be used
with applets, status bars and more, which are common in the Linux ecosystem.\
In order to respect accessibility and the requirements of a Linux application,
ReSet will also provide a command line version to interact with the
Reset-Daemon.
