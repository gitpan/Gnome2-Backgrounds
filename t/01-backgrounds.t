#!perl -T

use Test::More tests => 1;

use Gnome2::Backgrounds;

my $backgrounds = Gnome2::Backgrounds -> new(config => 't/backgrounds.xml');

my $jpg_bg = $backgrounds -> backgrounds('.jpg');

my @expected = ('another_wallpaper.jpg', 'second_wallpaper.jpg', 'first_wallpaper.jpg');

is_deeply($jpg_bg, \@expected, "Testing 'backgrounds()'");
