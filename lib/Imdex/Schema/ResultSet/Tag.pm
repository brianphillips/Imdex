package Imdex::Schema::ResultSet::Tag;
BEGIN {
  $Imdex::Schema::ResultSet::Tag::AUTHORITY = 'cpan:BPHILLIPS';
}
{
  $Imdex::Schema::ResultSet::Tag::VERSION = '0.001';
}

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


__END__
=pod

=head1 NAME

Imdex::Schema::ResultSet::Tag - DBIC resultset class providing various methods for searching the tags table

=head1 VERSION

version 0.001

=head1 AUTHOR

Brian Phillips <bphillips@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Brian Phillips.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

