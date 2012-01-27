package Imdex::Schema::ResultSet::ImageTag;

# ABSTRACT: DBIC resultset class providing various methods for searching the image/tag mapping table

use strict;
use warnings;
use base qw(DBIx::Class::ResultSet);

sub image_ids_with_all_tags {
	my($rs, @tags) = @_;
	return $rs->search(
		{ 'tag.tag' => { -in => \@tags } },
		{
			join    => 'tag',
			columns => [ 'image_id' ],
			group_by => 'image_id',
			having   => \[ 'count(tag_id) = ' . scalar(@tags) ],
		}
	);
}

1;
