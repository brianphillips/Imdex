package Imdex::Schema::ResultSet::ImagePerson;
BEGIN {
  $Imdex::Schema::ResultSet::ImagePerson::AUTHORITY = 'cpan:BPHILLIPS';
}
{
  $Imdex::Schema::ResultSet::ImagePerson::VERSION = '0.001';
}

# ABSTRACT: DBIC resultset class providing various methods for searching the image/person mapping table

use strict;
use warnings;
use base qw(DBIx::Class::ResultSet);

sub image_ids_with_all_people {
	my($rs, @people) = @_;
	return $rs->search(
		{ 'person.name' => { -in => \@people } },
		{
			join     => 'person',
			columns  => ['image_id'],
			group_by => 'image_id',
			having   => \[ 'count(person_id) = ' . scalar(@people) ],
		}
	);
}

1;

__END__
=pod

=head1 NAME

Imdex::Schema::ResultSet::ImagePerson - DBIC resultset class providing various methods for searching the image/person mapping table

=head1 VERSION

version 0.001

=head1 AUTHOR

Brian Phillips <bphillips@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Brian Phillips.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

