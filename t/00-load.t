#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Gnome2::Backgrounds' ) || print "Bail out!
";
}

diag( "Testing Gnome2::Backgrounds $Gnome2::Backgrounds::VERSION, Perl $], $^X" );
