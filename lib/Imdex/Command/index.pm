package Imdex::Command::index;
BEGIN {
  $Imdex::Command::index::AUTHORITY = 'cpan:BPHILLIPS';
}
{
  $Imdex::Command::index::VERSION = '0.001';
}

use strict;
use warnings;
use base 'Imdex::Command';

use Cwd qw(abs_path);
use Imdex::Indexer;

# ABSTRACT: Adds images to the Imdex database

sub opt_spec {
	my $self = shift;
	return (
		$self->SUPER::opt_spec(@_),
		[ "clean"      => "Remove any existing Imdex database file before beginning" ],
	);
}

sub usage_desc {
	"imdex index [files]"
}

sub execute {
	my($self, $options, $args) = @_;

	my $indexer = Imdex::Indexer->new( schema => $self->app->schema );

	my $i = 0;
	foreach my $f(@$args){
		local $|=1;
		print "* Indexing $f ...";

		my $abs_file = abs_path($f);
		if(-f $abs_file){
			$indexer->index_file( $abs_file );
			print " done\n";
			$i++;
		} else {
			print " not a file, skipping\n";
		}
	}
	print sprintf("Indexed %d image%s", $i, $i == 1 ? '' : 's');
	return;
}

1;


__END__
=pod

=head1 NAME

Imdex::Command::index - Adds images to the Imdex database

=head1 VERSION

version 0.001

=head1 SYNOPSIS

	% imdex index *.jpg # builds index in ~/.imdex.db

	% imdex --database .imdex.db index *.jpg # creates the "imdex" in the current directory

	% imdex index --clean *.jpg # deletes existing database before indexing

=head1 DESCRIPTION

This command indexes the images passed in on the command line.  An index
file will be built when first run (defaulting to C<~/.imdex.db> or
wherever specified by the C<--database> option as described in the
L<imdex> documentation).

=head1 OPTIONS

=over 4

=item C<--clean>

Deletes any existing database before beginning the current index
operation.

=back

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

