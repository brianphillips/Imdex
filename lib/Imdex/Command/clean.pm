package Imdex::Command::clean;
BEGIN {
  $Imdex::Command::clean::AUTHORITY = 'cpan:BPHILLIPS';
}
{
  $Imdex::Command::clean::VERSION = '0.001';
}

use strict;
use warnings;
use base 'Imdex::Command';

# ABSTRACT: Removes Imdex database

sub usage_desc {
	"imdex clean"
}

sub execute {
	my($self, $options, $args) = @_;

	my $db = $self->app->global_options->{database};
	die "no such file $db" if ! -f $db;

	my $schema = $self->app->schema;
	my $count = eval { $schema->resultset('Image')->count };

	if($@ || !defined($count)){
		die "File $db is not an Imdex database file: $@ $count";
	} else {
		print "Removing existing database at $db\n";
		unlink($db);
	}

	return;
}

1;



__END__
=pod

=head1 NAME

Imdex::Command::clean - Removes Imdex database

=head1 VERSION

version 0.001

=head1 SYNOPSIS

	% imdex clean # removes database in ~/.imdex.db or wherever the --database option indicates

=head1 DESCRIPTION

This command simply removes the Imdex database from the location indicated by the
C<--database> option (defaulting to ~/.imdex.db).

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

