package Imdex::Schema::ResultSet::Person;
BEGIN {
  $Imdex::Schema::ResultSet::Person::AUTHORITY = 'cpan:BPHILLIPS';
}
{
  $Imdex::Schema::ResultSet::Person::VERSION = '0.001';
}

# ABSTRACT: DBIC resultset class providing various methods for searching the people table

use strict;
use warnings;
use base qw(DBIx::Class::ResultSet);

my %cache;
sub lookup {
	my($rs, $name) = @_;
	return $cache{$name} ||= $rs->find_or_create( { name => $name }, { key => 'people_name' } );
}

1;

__END__
=pod

=head1 NAME

Imdex::Schema::ResultSet::Person - DBIC resultset class providing various methods for searching the people table

=head1 VERSION

version 0.001

=head1 AUTHOR

Brian Phillips <bphillips@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Brian Phillips.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

