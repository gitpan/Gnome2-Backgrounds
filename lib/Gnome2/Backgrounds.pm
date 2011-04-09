package Gnome2::Backgrounds;
BEGIN {
  $Gnome2::Backgrounds::VERSION = '0.01';
}

use XML::Simple;
use Gnome2::GConf;

use warnings;
use strict;

=head1 NAME

Gnome2::Backgrounds - Helper module for managing wallpapers in GNOME

=head1 VERSION

version 0.01

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

Returns a list of background names matching C<$name>.

=cut

sub backgrounds {
	my ($self, $name) = @_;

	$name = "(.*)" unless defined $name;

	my @return = grep { ref $_ ne 'HASH' and m/$name/ } %{ $self -> {'backgrounds'} };

	return \@return;
}

=head2 info( $names )

Returns a list of hash ref containing information about C<$names> background
(where names are valid background names). The following fields are set:

=over

=item C<filename>

=item C<options>

=item C<scolor>

=item C<shade_type>

=item C<deleted>

=item C<pcolor>

=back

=cut

sub info {
	my ($self, $names) = @_;

	my @infos = map { $self -> {'backgrounds'} -> {$_} } @{ $names };

	return \@infos;
}

=head2 set( $name )

Sets C<$name> background (where name is a valid background name, or the path to
an image file) as default background.

=cut

sub set {
	my ($self, $name) = @_;

	my $key = '/desktop/gnome/background/picture_filename';
	my $client  = Gnome2::GConf::Client -> get_default;

	$name = $self -> {'backgrounds'} -> {$name} -> {'filename'} unless (-s $name);

	$client -> set($key, {
		type => 'string',
		value => $name
	});
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