#!/usr/bin/perl -w

use strict;

use Net::Twitter;
use Scalar::Util 'blessed';

my $tweet = join(" ", @ARGV);

print "TWEETING : '$tweet'\n\n";

my $nt = Net::Twitter->
  new(
      traits          => [ 'API::REST', 'OAuth' ],
      
      ## Basic authentication (depreciated)
      #username => 'rettiwwitter',
      #password => 'easytoguess',
      
      ## OAuth for *this* app...

      ## Twittter hands these out when you register the app with them,
      ## they should be kept private...
      consumer_key    => '',
      consumer_secret => '',
     );



## FECK! (See http://search.cpan.org/ ... /Net/Twitter/Role/OAuth.pm)

## Comment out these two lines to activate the 'authorization' block below

## These are what the 'user' gets when he agrees to let the app access
## his account. This identifies me as me, and not just any old idiot.

#$nt->access_token( '' );
#$nt->access_token_secret( '' );


## Authorization
unless ( $nt->authorized ) {
  # The client is not yet authorized: Do it now
  print "Authorize this app at ", $nt->get_authorization_url,
    " and enter the PIN#\n";
  
  my $pin = <STDIN>; # wait for input
  chomp $pin;
  
  my ($access_token, $access_token_secret, $user_id, $screen_name) =
    $nt->request_access_token( verifier => $pin );
  
  ## Paste these results into the script above!
  print $access_token, "\n";
  print $access_token_secret, "\n";
  print $user_id, "\n";
  print $screen_name, "\n";
  
  exit;
}



my $result = $nt->update( $tweet );

if ( my $err = $@ ) {
  warn "error!\n";
  die "$@\n" unless blessed $err && $err->isa('Net::Twitter::Error');
  
  warn
    "HTTP Response Code: ", $err->code, "\n",
      "HTTP Message......: ", $err->message, "\n",
        "Twitter error.....: ", $err->error, "\n";
}
