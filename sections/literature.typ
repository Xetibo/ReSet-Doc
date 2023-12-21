#import "../templates/utils.typ": *
#lsp_placate()

#subsection("User Interface Guidelines")
The GNOME Human Interface Guidelines @gnome_human_guidelines are likely the most
applicable for ReSet, as they are the most prominent in the Linux sphere and are
directly meant to be used with GTK4, a potential user interface toolkit for
ReSet. While Reset does not intend to belong to the GNOME circle, for which
rather strict adherence to these guidelines is needed, ReSet will still use the
best practices that are employed by these guidelines.

These best practices can also be seen in the book "Don't Make Me Think" by Steve
Krug @krug, or in "Designing the User Interface" by Ben Shneiderman and Catherine
Plaisant @shneiderman. In both works the authors defined rules to follow when
creating user interfaces. Steve Krug specifically focused on the web, however,
the vast majority of these rules can be applied in the same manner on desktop
applications.

- *"Don't Make Me Think" - Steve Krug* @krug\
  This means that a user should not need to "think" when using the interface, it
  should come as obvious where the user has to click or navigate to in order to
  finish their task. In the case of ReSet, this might be something like connecting
  to a Wi-Fi network or a Bluetooth device.\
- *"Cater to universal usability" - "The eight golden rules"* @shneiderman\
  User interfaces should be created for all possible users, meaning both experts
  and novices should be able to use the application without issues.\
  This rule depends heavily on what the possible user base is, an IDE has
  different users to a general messaging application.

  For example, the application Blueman introduced in
  @Analysisofexistingapplications is used.
  #figure(
    align(center, [#image("../figures/bluetooth_manager.png", width: 80%)]), caption: [Blueman],
  )<bluetooth_manager>
  When opening the application, one can see a blank page with a top bar, this may
  cause users to think there are no Bluetooth devices available. However, the user
  needs to manually search for devices as defined by the technology.
  #figure(
    align(
      center, [#image("../figures/bluetooth_manager_filled.png", width: 80%)],
    ), caption: [Blueman with scanned devices],
  )<bluetooth_manager_filled>
  After clicking the search button, the application proceeds to list Bluetooth
  devices as expected. The question now is how to pair and connect to a specific
  device. Users who understand Bluetooth terminology will likely proceed with the
  key icon, which means pairing for this application. However, there is a chance
  that users will first try the checkmark icon to connect to the device, which
  would instead mark the device as trusted.

  In this case, the icons could be improved to represent a more technology-neutral
  design.

  ReSet will enforce technology neutral buttons where possible, which leads to a
  more intuitive user interface, while still providing the user as much
  functionality as possible.

- *"It doesn’t matter how many times I have to click, as long as each click is a
  mindless, unambiguous choice." - Steve Krug* @krug\
  Each navigation should have a consistent path and a clearly defined destination,
  it should be clear to the user where they are right now, and where they can go
  from here.

  In chapter 6.4.2 "Tree-structured menus" in "Designing the user interface"
  @shneiderman, the authors note that no more than 3 to 4 layers should be used
  for pop-over menus. Later this is re-affirmed with the menu selection guidelines
  where "broad-narrow" is preferred over "narrow-deep", this defines that more top
  level selections are preferable to many layers, as layers can confuse the user
  and make navigation tedious.

  Both the GNOME human interface guidelines and Steve Krug advise developers to
  use as few required clicks to navigate to a certain page as possible. This
  avoids tedious navigation where users could either get lost in navigation or
  simply get annoyed at the endless path.
  #figure(
    align(center, [#image("../figures/kde-hamburger.png", width: 60%)]), caption: [An extreme example of KDE hamburger menus],
  )<kde-hamburger>
  There is a big difference between KDE and GNOME in the context of menus, KDE
  uses a lot of nested submenus as can be seen in @kde-hamburger, while the GNOME
  side explicitly discourages these menus citing reduced accessibility
  @gnome_guidelines_menu. In this case, the question is about where the bookmarks
  are stored. The default location is in more->go->bookmarks, this is on layer 4
  of a menu without search functionality and with very ambiguous navigation.

  In other words, it is clear that shorter navigation is usually the best way to
  achieve "mindless navigation", however, it is, as Krug mentioned, not the only
  factor.

  ReSet will enforce this rule by avoiding context menus entirely wherever
  possible, and instead relying on dynamic pages to provide further functionality.
#pagebreak()
- *"Get rid of half the words on each page, then get rid of half of what is left."
  \- Steve Krug* @krug\
  This defines unnecessary information on a page or application. Everything that
  the user does not care about should be omitted. One should note however that
  this does not imply the removal or omitting of _features_, instead only showing
  users a certain feature when they need it.

  This is convergent with the previous rule which ReSet will also handle with
  dynamic pages, meaning advanced functionality will be provided with a button
  that leads to a page transition.

- *"Reduce short-term memory load" - "The eight golden rules"* @shneiderman\
  Humans have a limited capacity for information, this includes what people see on
  an application. The authors therefore propose to collapse complex user
  interfaces like multi-page displays into one.

  The downside of this approach can be a too simple application, meaning the users
  might be forced to use more than one tool for the task. For example, compared to
  KDE applications, GNOME is often considered to be simpler, but also less
  configurable.
  #grid(
    columns: (1fr, 1.1fr), rows: (auto), gutter: 10pt, figure(
      align(center, [#image("../figures/new-gnome.png", width: 60%)]), caption: [Context menu in Nautilus (GNOME file manager)],
    ), figure(
      align(center, [#image("../figures/new-kde.png", width: 100%)]), caption: [Context menu in Dolphin (KDE file manager)],
    ),
  )
  Here the KDE application is more powerful, offering a variety of files to
  create, including links and shortcuts, while the GNOME experience only offers a
  new folder and anything else needs to be done with a terminal. For Nautilus, one
  can also create templates within the Linux template folder which will then be
  available in the pop-over menu as well, but this is not an obvious feature
  @nautilus_new_document_popup @nautilus_new_document_issue.

  ReSet aims to provide a middle ground between these two approaches.

- *"Support internal locus of control" - "The eight golden rules"* @shneiderman\
  The rule refers to clear omission of unnecessary data for experts, and giving
  them a short, clear, and usually customizable path to their end goal. In user
  interfaces this is usually done with keyboard shortcuts as seen in
  @dolphin_shortcuts.

  #figure(
    align(center, [#image("../figures/shortcuts-kde.png", width: 100%)]), caption: [Shortcuts menu in Dolphin],
  )<dolphin_shortcuts>

  The Dolphin version is much more complex, this is because you can customize any
  shortcut in Dolphin using this interface. For Nautilus shortcuts can only be
  configured using scripts that extend the functionality of Nautilus
  @nautilus_shortcut_discussion, according to a GTK developer, this is no longer
  possible on a toolkit level @gtk_shortcut_discussion.

  #figure(
    align(center, [#image("../figures/shortcuts.png", width: 80%)]), caption: [Shortcuts menu in Nautilus],
  )<nautilus_shortcuts>

#pagebreak()
- *"Strive for consistency" - "The eight golden rules"* @shneiderman\
  No matter how one creates a user interface, the very first thing one should
  thrive for is to make it consistent. This includes practices like ensuring items
  have the same appearance no matter where they are placed or that buttons with
  similar functionality and have the same labeling. In "Designing the user
  interface" @shneiderman, the authors empathized this in chapter 2.4.3 with a
  clear example:
  #grid(
    columns: (auto, auto), rows: (auto, auto, auto, auto), gutter: 0pt, cell("Consistent", bold: true, height: 20pt), cell("Inconsistent", bold: true, height: 20pt), cell("delete/insert table", height: 20pt), cell("delete/insert table", height: 20pt), cell("delete/insert column", height: 20pt), cell("remove/add column", height: 20pt), cell("delete/insert row", height: 20pt), cell("destroy/create row", height: 20pt), cell("delete/insert border", height: 20pt), cell("erase/draw border", height: 20pt),
  )

  For ReSet, this rule will be used to ensure that a similar user interface flow
  as well as similar toolkit modules are employed to guarantee consistency.

#subsection("Persistent Settings")
In "The Pragmatic Programmer" @pragprog by David Thomas and Andrew Hunt, the
authors mentioned the importance of text file configuration that is
human-readable and can be put under version control. For ReSet the importance
comes from the fact that the configuration of various categories needs
persistent storage, and ReSet also needs to handle this.

The already mentioned GNOME control center handles this via a database, contrary
to the chapter in the aforementioned book. This is done for increased speed in
loading and storing configuration data. However, it does come with the downside
of needing a program to interact with the stored data, as you cannot otherwise
access it.

KDE systemsettings in contrast work with text files as Thomas and Hunt advocate,
but their files are sometimes unorganized, meaning it is often hard to understand
where a certain setting might be if you would like to change something, perhaps
due to a bug in the graphical user interface or because you just like to make
these changes manually.

For ReSet, using small and structured text files over databases ensures version
control compatibility, environment-agnostic usage, as well as application
agnostic usage and configuration.
