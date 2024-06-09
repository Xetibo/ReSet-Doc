// Introduction
In this thesis, a plugin system for the existing ReSet application is developed.
ReSet is a settings application for Linux that aims to provide support for
multiple desktop environments and window managers/compositors. Therefore, ReSet
offers only a small set of core features due to its focus on universal
environment support. As such a plugin system is needed in order to offer
additional functionality.

// Methodologies
The architecture of the plugin system was developed by analyzing existing
solutions for other software and by creating various prototypes to prove the
viability of each system on ReSet and its potential plugins.

// Result
The plugin system was ultimately developed with shared libraries which allows
for resource sharing in both the daemon and the user interface of ReSet without
the additional overhead of an interpreter.

To prove the plugin system, two exemplary plugins were developed in this thesis.
The first is a monitor plugin, which allows users to change the individual settings
of each monitor and rearrange their monitors. The second is a keyboard plugin
that allows users to add, remove and rearrange keyboard layouts. Combined with
the plugin system is a testing framework that also allows plugin developers to
include their tests within ReSet in order to allow integration tests.

// Conclusion
In summary, the plugin system was successfully implemented, with both plugins
expanding the functionality as expected. Additionally, the plugin system offers
ReSet the opportunity to offer limitless potential in both environment and
hardware support, while also giving users the option to choose their options
within ReSet.
