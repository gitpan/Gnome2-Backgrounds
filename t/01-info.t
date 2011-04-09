#!perl -T

use Test::More tests => 1;

use Gnome2::Backgrounds;

my $backgrounds = Gnome2::Backgrounds -> new(config => 't/backgrounds.xml');

my $jpg_bg = $backgrounds -> backgrounds('.jpg');

my $info = [
          {
            'filename' => '/path/to/the/awesome/another_wallpaper.jpg',
            'options' => 'zoom',
            'scolor' => '#6666baba0000',
            'shade_type' => 'solid',
            'deleted' => 'false',
            'pcolor' => '#6666baba0000'
          },
          {
            'filename' => '/path/to/the/awesome/second_wallpaper.jpg',
            'options' => 'zoom',
            'scolor' => '#6666baba0000',
            'shade_type' => 'solid',
            'deleted' => 'false',
            'pcolor' => '#6666baba0000'
          },
          {
            'filename' => '/path/to/the/awesome/first_wallpaper.jpg',
            'options' => 'zoom',
            'scolor' => '#6666baba0000',
            'shade_type' => 'solid',
            'deleted' => 'false',
            'pcolor' => '#6666baba0000'
          }
        ];

is_deeply($backgrounds -> info($jpg_bg), $info, "Testing 'info()'");
