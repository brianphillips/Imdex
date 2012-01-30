package Imdex::Schema::Result::Tag;
BEGIN {
  $Imdex::Schema::Result::Tag::AUTHORITY = 'cpan:BPHILLIPS';
}
{
  $Imdex::Schema::Result::Tag::VERSION = '0.001';
}

# ABSTRACT: A very simple DBIC result class representing a Tag

use DBIx::Class::Candy -autotable => v1;

primary_column id => {
	data_type         => 'int',
	is_auto_increment => 1,
};

unique_column tag => {
	data_type => 'varchar',
	size => 64,
};

has_many image_tags => 'Imdex::Schema::Result::ImageTag', 'tag_id';
many_to_many images => 'image_tags', 'image';

1;

__END__
=pod

=head1 NAME

Imdex::Schema::Result::Tag - A very simple DBIC result class representing a Tag

=head1 VERSION

version 0.001

=head1 AUTHOR

Brian Phillips <bphillips@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Brian Phillips.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

