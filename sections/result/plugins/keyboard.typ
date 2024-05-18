#import "../../../templates/utils.typ": *
#lsp_placate()

#subsection("Keyboard Plugin")
In this section, the implementation of the keyboard plugin is discussed.

#subsubsubsection("Hyprland Implementation")
The keyboard layouts in Hyprland are stored in a hypr.conf file, which is 
basically a configuration file and can be modified using multiple ways.
The first one is to directly write changes into the configuration file, 
which could work because any changes are applied immediately. The second 
way is to use hyprctl, a command-line tool that can be used to modify 
the configuration file. 

The implemented way was a modified version of directly writing into the 
configuration file. The problem with that approach is that location 
where the configuration file is stored is not fixed. It could be stored
in different locations depending on user preference. Therefore, the 
user would need to pass ReSet the path of it so that ReSet can write 
into it. Fortunately, the configuration file can be split into multiple
smaller files, that can be stored in different locations. The main 
configuration file just needs to include them via a path. This way, ReSet 
can create its own configuration file in the config folder of ReSet and 
make changes in there. These changes are also applied immediately.

// todo write why we did not use hyprctl

#subsubsubsection("GNOME Implementation")
In GNOME, it is possible to change keyboard layouts with gsettings or 
dconf. There are other tools like gconf, but they are replaced by dconf.
Gsettings is a high-level configuration system intended to be used in 
the command line as front end to dconf. dconf serves as a low-level 
configuration system for gsettings that stores key-based configuration 
details in a single compact binary format database. 

// todo why did we use dconf

#subsubsubsection("KDE Implementation")
KDE stores its keyboard configurations in a file called kxkbrc. This
text file is located in the config folder of the user and can be 
read from using kreadconfig6 and written to using kwriteconfig6. Both 
are part of KConfig, a library provided by KDE to read and write 
configuration files.

There was also a dbus interface which could be used to fetch keyboard 
layouts, but there was no way to set them. Therefore, the implementation
was done using KConfig.