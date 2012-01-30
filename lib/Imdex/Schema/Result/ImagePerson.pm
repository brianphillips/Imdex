package Imdex::Schema::Result::ImagePerson;
BEGIN {
  $Imdex::Schema::Result::ImagePerson::AUTHORITY = 'cpan:BPHILLIPS';
}
{
  $Imdex::Schema::Result::ImagePerson::VERSION = '0.001';
}

# ABSTRACT: DBIC result class mapping an image to a person (many-to-many)

use DBIx::Class::Candy;

table 'image_people';

primary_column id => {
	data_type         => 'int',
	is_auto_increment => 1,
};

column image_id => {
	data_type => 'int',
};

column person_id => {
	data_type => 'int',
};

belongs_to 'image', 'Imdex::Schema::Result::Image', 'image_id';
belongs_to 'person', 'Imdex::Schema::Result::Person', 'person_id';

sub sqlt_deploy_hook {
	my($self, $sqlt_table) = @_;
	$sqlt_table->add_index(name => 'idx_image_id', fields => ['image_id']);
	$sqlt_table->add_index(name => 'idx_person_id', fields => ['person_id']);
	return;
}

1;

__END__
=pod

=head1 NAME

Imdex::Schema::Result::ImagePerson - DBIC result class mapping an image to a person (many-to-many)

=head1 VERSION

version 0.001

=head1 AUTHOR

Brian Phillips <bphillips@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Brian Phillips.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

