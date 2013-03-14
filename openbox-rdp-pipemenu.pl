#!/usr/bin/env perl

#
# This file is part of openbox-rdp-pipemenu. openbox-rdp-pipemenu is free software: you can
# redistribute it and/or modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation, version 2.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 51
# Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
# Copyright (c) 2013 Klaus Meyer 
# http://www.klaus-meyer.net/
#

use strict;
use 5.010;
use Data::Dumper;
use Config::Simple;

my %config = (
  "editor" => "geany",
  "resolution" => "1280x1024",
  "keyboard_layout" => "en"
);
my $hosts = ();

sub print_hosts_menu {
  my ($caption, $id) = @_;
  say "<menu id=\"rdp-$id\" label=\"$caption\">";
  print_host_entry("Testhost", "192.168.0.1", "Domain", "myuser", "mypass");
  print_host_entry("Testhost", "192.168.0.2", "Domain", "myuser", "mypass");
  print_host_entry("Testhost", "192.168.0.3", "Domain", "myuser", "mypass");
  say "</menu>";
  say "<separator/>";
}

sub print_host_entry {
  my ($caption, $hostname, $domain, $username, $password) = @_;
  say "<item label=\"$caption\">";
  say " <action name=\"Execute\">";
  say "   <command>";
  say "     rdesktop -u $domain\\$username -p $password -z -g $config{'resolution'} -k $config{'keyboard_layout'} $hostname";
  say "   </command>";
  say " </action>";
  say "</item>";
}

sub print_execute_item {
  my ($caption, $command) = @_;
  say "<item label=\"Edit ~/.rdp/hosts\">";
  say " <action name=\"Execute\">";
  say "   <command>";
  say "     $command";
  say "   </command>";
  say " </action>";
  say "</item>";
}

# loading the config file
Config::Simple->import_from($ENV{"HOME"} . "/.rdp/config", \%config);

# print the openbox xml menu to console
say "<openbox_pipe_menu>";
if(length($hosts) > 0) {
  print_hosts_menu("Intranet", "intranet");
  print_hosts_menu("Live", "live");
}
print_execute_item("Edit ~/.rdp/config", "$config{'editor'} ~/.rdp/config");
print_execute_item("Edit ~/.rdp/hosts", "$config{'editor'} ~/.rdp/hosts");
print_execute_item("Edit ~/.rdp/credentials", "$config{'editor'} ~/.rdp/credentials"); 
say "</openbox_pipe_menu>";

exit 0;