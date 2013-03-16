# openbox-rdp-pipemenu

An openbox pipemenu for your rdp connections  
Copyright &copy; 2013 [Klaus Meyer][klaus_meyer_website]

## Licence

GPLv2, see [LICENCE.txt](LICENCE.txt)

## Dependencies

* perl >= 5.10 (Installed by default on most Linux/Unix Systems)
* Config::Simple (Debian: libconfig-simple-perl)
* XML::Simple (Debian: libxml-simple-perl)
* Crypt::Blowfish (Debian: libcrypt-blowfish-perl)
* openbox (not really, but it would be pointless without)

## Useage
* Create the three config-files in ~/.rdp/  
* Add the folder containing openbox-rdp-pipemenu.pl to your $PATH  
* Put the following tag into your ~/.config/openbox/menu.xml file:  

Code:

	<menu execute="openbox-rdp-pipemenu.pl" id="rdp" label="RDP" />
	
* Restart openbox  
* Have fun :)

## Sceenshots

Openbox on my crunchbang-linux system using the example configuration:

![Screenshot](https://raw.github.com/klausmeyer/openbox-rdp-pipemenu/master/screenshot.png)

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

This file contains the login credentials for the server(-groups).  
Format (XML):

	<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
	<root>
		<credentials id="unique_id">
			<domain>domain- or computername</domain>
			<user>name of the user to log in as</user>
			<password>password of the user in plaintext</password>
		</credentials>
		[...]
	</root>
	
Note: the value of the id-attribute in the credentials node must be unique within the file and is used to refer from the hosts-file.

### ~/.rdp/hosts

This file contains the servers grouped by categories.
Format:

	<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
	<root>
		<group caption="displayname of the group">
	  		<host
	  			caption="displayname of the host"
	  			hostname="ip or dns-name of the hosts"
	  			credentials_id="id of the credentials to use for login" />
	  		<host
	  			caption="displayname of the host"
	  			hostname="ip or dns-name of the hosts"
	  			credentials_id="id of the credentials to use for login" />
	  		<group caption="displayname of the subgroup">
	  			<host [...] />
	  		</group
		</group>
		[...]
	</root>
	
Note: within the root node you could only use group nodes as the first level.  
In the group nodes you could either add the hosts directly or put them in subgroups.

[klaus_meyer_website]: http://www.klaus-meyer.net/
[config_syntax_supported]: http://search.cpan.org/~sherzodr/Config-Simple-4.59/Simple.pm#ABOUT_CONFIGURATION_FILES