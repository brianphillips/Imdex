package Imdex::Schema;
BEGIN {
  $Imdex::Schema::AUTHORITY = 'cpan:BPHILLIPS';
}
{
  $Imdex::Schema::VERSION = '0.001';
}

# ABSTRACT: Root DBIC schema class for the Imdex application

use strict;
use warnings;

use Imdex::ColorUtil;

use base qw/DBIx::Class::Schema/;
 
__PACKAGE__->load_namespaces();

sub connection {
	my $class = shift;
	my $dsn   = shift;
	return $class->SUPER::connection(
		$dsn, '', '',
		{ sqlite_unicode => 1 },
		{
			on_connect_do => sub {
				my ($storage) = @_;
				$storage->dbh->func( 'rgbhex_difference', 2, \&Imdex::ColorUtil::rgbhex_difference, 'create_function' );
			},
		}
	);
}

sub deployment_statements {
	my $self = shift;
	my @statements = $self->SUPER::deployment_statements(@_);
	push @statements, <<'_SQL_';
CREATE VIRTUAL TABLE imdex USING fts4(caption, tags, people, tokenize=porter);
_SQL_
	return @statements;
}

1;

__END__
=pod

=head1 NAME

Imdex::Schema - Root DBIC schema class for the Imdex application

=head1 VERSION

version 0.001

=head1 AUTHOR

Brian Phillips <bphillips@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Brian Phillips.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

