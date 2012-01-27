package Imdex::Schema::ResultSet::ImagePerson;

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
