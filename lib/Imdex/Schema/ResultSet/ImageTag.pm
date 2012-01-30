package Imdex::Schema::ResultSet::ImageTag;
BEGIN {
  $Imdex::Schema::ResultSet::ImageTag::AUTHORITY = 'cpan:BPHILLIPS';
}
{
  $Imdex::Schema::ResultSet::ImageTag::VERSION = '0.001';
}

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

__END__
=pod

=head1 NAME

Imdex::Schema::ResultSet::ImageTag - DBIC resultset class providing various methods for searching the image/tag mapping table

=head1 VERSION

version 0.001

=head1 AUTHOR

Brian Phillips <bphillips@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Brian Phillips.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

