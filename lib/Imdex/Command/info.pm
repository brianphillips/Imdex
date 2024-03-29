package Imdex::Command::info;
BEGIN {
  $Imdex::Command::info::AUTHORITY = 'cpan:BPHILLIPS';
}
{
  $Imdex::Command::info::VERSION = '0.001';
}

use strict;
use warnings;
use base 'Imdex::Command';
use Cwd qw(abs_path);

use Imdex::Schema;

# ABSTRACT: Displays information for images in the Imdex database

sub usage_desc {
	"imdex info [files]"
}

sub execute {
	my($self, $options, $args) = @_;
	my $schema = $self->app->schema;
	my $rs = $schema->resultset('Image');

	foreach my $f(@$args){
		my $abs_file = -f $f ? abs_path($f) : $f;
		my $i = $rs->find( $abs_file, { key => 'images_file_name', prefetch => [ 'imdex', 'colors' ] });
		my $colors = join( ', ', map { $_->as_string } sort { $b->weight <=> $a->weight } $i->colors );
		print sprintf(<<'_IMG_', $i->file_name, $i->caption || '[NONE]', $i->date_taken, $i->date_indexed, $i->imdex->tags || '[NONE]', $i->imdex->people || '[NONE]', $colors );

        File: %s
     Caption: %s
  Date Taken: %s
Date Indexed: %s
        Tags: %s
      People: %s
      Colors: %s
_IMG_
	}

	return;
}

1;


__END__
=pod

=head1 NAME

Imdex::Command::info - Displays information for images in the Imdex database

=head1 VERSION

version 0.001

=head1 SYNOPSIS

	# shows information on files that have been indexed by imdex
	% imdex info /path/to/photo.jpg

	# working from a database local to the current directory
	% imdex --database .imdex.db info photo.jpg

	# show information for all images returned by a search
	% imdex search keyword | xargs imdex info

=head1 SEE ALSO

=over 4

=item * L<imdex>

=back

=head1 AUTHOR

Brian Phillips <bphillips@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Brian Phillips.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

