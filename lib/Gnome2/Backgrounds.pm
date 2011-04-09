package Gnome2::Backgrounds;
BEGIN {
  $Gnome2::Backgrounds::VERSION = '0.02';
}

use XML::Simple;
use Gnome2::GConf;

use warnings;
use strict;

=head1 NAME

Gnome2::Backgrounds - Helper module for managing wallpapers in GNOME

=head1 VERSION

version 0.02

=head1 SYNOPSIS

    use feature 'say';
    use Gnome2::Backgrounds;

    my $backgrounds = Gnome2::Backgrounds -> new;

    # print a list of filenames of JPEG backgrounds
    my $jpg_bg = $backgrounds -> backgrounds('.jpg');

    foreach (@$jpg_bg) {
      say $_ -> {'filename'};
    }

    # set the default background
    $backgrounds -> set('my_background.jpg');

    # or
    $backgrounds -> set('/path/to/my_background.jpg');

=head1 DESCRIPTION

B<Gnome2::Backgrounds> is a simple module to help managing wallpapers under
the GNOME2 desktop environment.

=head1 METHODS

=head2 new( config => 'some/file/backgrounds.xml' )

Parses a C<backgrounds.xml> file (default C<$HOME/.gnome2/background.xml>) and
returns a B<Gnome2::Backgrounds> object.

=cut

sub new {
	my ($class, %args) = @_;

	$args{'config'} = $ENV{'HOME'}.'/.gnome2/backgrounds.xml' unless defined $args{'config'};

	open my $bg_file, $args{'config'} or die $!;
	my $xml = join '', <$bg_file>;
	close $bg_file;

	my $self = bless({%args, 'backgrounds' => XMLin($xml) -> {'wallpaper'}}, $class);

	return $self;
}

=head2 backgrounds( $name )

Returns a list of backgrounds matching C<$name>. The backgrounds are stored as
anonymous hashes containing the following fields:

=over

=item C<name>

Backgrounds name (typically the basename of the background's path).

=item C<filename>

Picture file name (absolute path of the image file).

=item C<options>

Picture options. Can be: B<zoom>, B<wallpaper>, B<centered>, B<scaled>,
B<stretched> or B<spanned>.

=item C<shade_type>

Color shading type. Can be: B<solid>, B<horizontal-gradient> or B<vertical-gradient>.

=item C<pcolor>

Primary color.

=item C<scolor>

Secondary color.

=item C<deleted>

Whether the background has been removed or not.

=back

=cut

sub backgrounds {
	my ($self, $name) = @_;

	$name = "(.*)" unless defined $name;

	my @matches;

	foreach my $bg (keys %{ $self -> {'backgrounds'} }) {
		push @matches, {
			'name' => $bg,
			%{ $self -> {'backgrounds'} -> {$bg} }
		} if ($bg =~ /$name/);
	}

	return \@matches;
}

=head2 set( $background )

Sets C<$background> (where C<$background> is a valid background name, or the
path to an image file) as default background using GConf.

=cut

sub set {
	my ($self, $bg) = @_;

	my $key = '/desktop/gnome/background/picture_filename';
	my $client  = Gnome2::GConf::Client -> get_default;

	$bg = $self -> {'backgrounds'} -> {$bg} -> {'filename'} unless (-s $bg);

	$client -> set($key, {
		type => 'string',
		value => $bg
	});
}

=head2 current( )

Returns the background currently used, in the form of a hash reference (see
C<backgrounds()> for more info).

=cut

sub current {
	my $self = shift;

	my $key = '/desktop/gnome/background/picture_filename';
	my $client  = Gnome2::GConf::Client -> get_default;

	my $name = $client -> get_string($key);

	my @match = grep { $_ -> {'filename'} eq $name } @{ $self -> backgrounds };

	return $match[0];
}

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of Gnome2::Backgrounds