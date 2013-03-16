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
use Config::Simple;
use Crypt::Blowfish;
use MIME::Base64;

my %config;

sub blowfish_padding {
  my $text = shift;
  my $step = 8;
  my $mod = length($text) % $step;
  if($mod != 0) {
    my $padding = $step - $mod;
    $text = $text . ("\x00" x $padding);
  }
  return $text;
}

sub blowfish_unpadding {
  my $text = shift;
  $text =~ s/\x01+$//g;
  return $text;
}

Config::Simple->import_from($ENV{"HOME"} . "/.rdp/config", \%config);
my $key = blowfish_padding($config{"crypt_key"});
my $cipher = new Crypt::Blowfish $key;

if($#ARGV + 1 == 1) {
  my $crypted = decode_base64($ARGV[0]);
  my $plain = "";
  # deencrypt text using blowfish in 8 byte parts
  my $offset = 0;
  my $junk_size = 8;
  my $junk = "";
  do {
    $junk = substr($crypted, $offset, $junk_size);
    if(length($junk) > 0) {
      $plain .= $cipher->decrypt(blowfish_padding($junk));
      $offset += $junk_size;
    }
  }
  until(length($junk) < $junk_size);
  say blowfish_unpadding($plain);
}

exit 0;