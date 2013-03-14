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
use XML::Simple;

my %config = (
  "editor" => "geany",
  "resolution" => "1280x1024",
  "keyboard_layout" => "en"
);
my $credentials = ();
my $hosts = ();

sub create_id {
  my $caption = shift;
  $caption = lc($caption);
  $caption =~ s/[^a-z0-9]//g;
  return $caption;
}

sub parse_credentials {
  my $file = $ENV{"HOME"} . "/.rdp/credentials";
  $credentials = XMLin($file, KeyAttr => { credentials => "id" });
}
  
sub parse_hosts {
  my $file = $ENV{"HOME"} . "/.rdp/hosts";
  $hosts = XMLin($file);
}

sub print_hosts {
  foreach(@{$hosts->{"group"}}) {
    my $group = $_;
    print_hosts_group($group->{"caption"}, create_id($group->{"caption"}), $group->{"host"}, $group->{"group"});
  }
  exit;
}

sub print_hosts_group {
  my ($caption, $id, $hosts, $subgroups) = @_;
  say "<menu id=\"rdp-$id\" label=\"$caption\">";
  # print all hosts
  foreach(@{$hosts}) {
    my $host = $_;
    my $credentials = $credentials->{"credentials"}->{$host->{"credentials_id"}};
    print_host_entry($host->{"caption"}, $host->{"hostname"}, $credentials->{"domain"}, $credentials->{"user"}, $credentials->{"password"});
  }
  # print all subgroups
  say "</menu>";
  say "<separator/>";
}

sub print_host_entry {
  my ($caption, $hostname, $domain, $username, $password) = @_;
  print_execute_item($caption, "rdesktop -u $domain\\$username -p $password -z -g $config{'resolution'} -k $config{'keyboard_layout'} $hostname");
}

sub print_execute_item {
  my ($caption, $command) = @_;
  say "<item label=\"$caption\">";
  say " <action name=\"Execute\">";
  say "   <command>";
  say "     $command";
  say "   </command>";
  say " </action>";
  say "</item>";
}

# loading the config file
Config::Simple->import_from($ENV{"HOME"} . "/.rdp/config", \%config);

# parse credentials and hosts
parse_credentials();
parse_hosts();

# print the openbox xml menu to console
say "<openbox_pipe_menu>";
if(length($hosts) > 0) {
  print_hosts();
}
print_execute_item("Edit ~/.rdp/config", "$config{'editor'} ~/.rdp/config");
print_execute_item("Edit ~/.rdp/hosts", "$config{'editor'} ~/.rdp/hosts");
print_execute_item("Edit ~/.rdp/credentials", "$config{'editor'} ~/.rdp/credentials"); 
say "</openbox_pipe_menu>";

exit 0;