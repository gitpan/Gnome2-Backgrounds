#!perl -T

use Test::More tests => 1;

use Gnome2::Backgrounds;

my $backgrounds = Gnome2::Backgrounds -> new(config => 't/backgrounds.xml');

my $jpg_bg = $backgrounds -> backgrounds('.jpg');

my @expected = (
	{
		'scolor' => '#6666baba0000',
		'options' => 'zoom',
		'filename' => '/path/to/the/awesome/another_wallpaper.jpg',
		'shade_type' => 'solid',
		'name' => 'another_wallpaper.jpg',
		'deleted' => 'false',
		'pcolor' => '#6666baba0000'
	},
	{
		'scolor' => '#6666baba0000',
		'options' => 'zoom',
		'filename' => '/path/to/the/awesome/second_wallpaper.jpg',
		'shade_type' => 'solid',
		'name' => 'second_wallpaper.jpg',
		'deleted' => 'false',
		'pcolor' => '#6666baba0000'
	},
	{
		'scolor' => '#6666baba0000',
		'options' => 'zoom',
		'filename' => '/path/to/the/awesome/first_wallpaper.jpg',
		'shade_type' => 'solid',
		'name' => 'first_wallpaper.jpg',
		'deleted' => 'false',
		'pcolor' => '#6666baba0000'
	}
);

is_deeply($jpg_bg, \@expected, "Testing 'backgrounds()'");


