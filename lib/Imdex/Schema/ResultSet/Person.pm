package Imdex::Schema::ResultSet::Person;

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
