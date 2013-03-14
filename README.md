# openbox-rdp-pipemenu

An openbox pipemenu for your rdp connections  
Copyright &copy; 2013 [Klaus Meyer][klaus_meyer_website]

## Licence

GPLv2, see [LICENCE.txt](LICENCE.txt)

## Dependencies

* perl >= 5.10 (Installed by default on most Linux/Unix Systems)
* Config::Simple (Debian: libconfig-simple-perl)
* openbox (not really, but it would be pointless without)

## Useage
1. Create the three config-files in ~/.rdp/
2. Add the folder containing openbox-rdp-pipemenu.pl to your $PATH
3. Put the following tag into your ~/.config/openbox/menu.xml file:

	&lt;menu execute="openbox-rdp-pipemenu.pl" id="rdp" label="RDP" /&gt;
	
4. Restart openbox
5. Have fun :)

## Config

The configuration is done by editing the following three files

### ~/.rdp/config

This file contains the general configuration.
You can define the following options:

* editor (command to use when editing config files; default = geany)
* resolution (resolution used by rdesktop; default = 1280x1024)
* keyboard_layout (keyboard layout used by rdesktop; default = en)

The file is parsed by perl Config::Simple, so you can use every syntax [supported][config_syntax_supported] by this module.

### ~/.rdp/credentials

This file contains the login credentials for the server(-groups)

To be specified, implemented and documented

### ~/.rdp/hosts

This file contains the servers grouped by categories.

To be specified, implemented and documented

[klaus_meyer_website]: http://www.klaus-meyer.net/
[config_syntax_supported]: http://search.cpan.org/~sherzodr/Config-Simple-4.59/Simple.pm#ABOUT_CONFIGURATION_FILES