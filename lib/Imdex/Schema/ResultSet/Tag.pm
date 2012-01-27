package Imdex::Schema::ResultSet::Tag;

# ABSTRACT: DBIC resultset class providing various methods for searching the tags table

use strict;
use warnings;
use base qw(DBIx::Class::ResultSet);

my %cache;
sub lookup {
	my($rs, $tag) = @_;
	$tag = lc $tag;
	return $cache{$tag} ||= $rs->find_or_create( { tag => $tag }, { key => 'tags_tag' } );
}

1;

