#!/usr/bin/perl -w

use strict;

use File::Tail;

my $HOME = $ENV{'HOME'};

warn "running from $HOME\n";

my $file =
  File::Tail->new( name =>"$HOME/.twistory" );

my $line = "";

while (defined(my $l = $file->read)) {
  next if $l eq $line;
  $line = $l;
  
  $l = quotemeta($l);
  
  warn $l;
  
  system("$HOME/bin/twitter.pl -f $HOME/.twitterrcretti $l");
  
  warn "twatted\n"
}

warn "OK\n";

