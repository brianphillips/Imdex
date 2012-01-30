package Imdex::Schema::Result::Person;
BEGIN {
  $Imdex::Schema::Result::Person::AUTHORITY = 'cpan:BPHILLIPS';
}
{
  $Imdex::Schema::Result::Person::VERSION = '0.001';
}

# ABSTRACT: A very simple DBIC result class representing a Person

use DBIx::Class::Candy -autotable => v1;

primary_column id => {
	data_type         => 'int',
	is_auto_increment => 1,
};

unique_column name => {
	data_type => 'varchar',
	size => 64,
};

has_many image_people => 'Imdex::Schema::Result::ImagePerson', 'person_id';
many_to_many images => 'image_people', 'image';

1;

__END__
=pod

=head1 NAME

Imdex::Schema::Result::Person - A very simple DBIC result class representing a Person

=head1 VERSION

version 0.001

=head1 AUTHOR

Brian Phillips <bphillips@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Brian Phillips.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

