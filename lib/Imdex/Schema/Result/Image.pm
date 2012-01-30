package Imdex::Schema::Result::Image;
BEGIN {
  $Imdex::Schema::Result::Image::AUTHORITY = 'cpan:BPHILLIPS';
}
{
  $Imdex::Schema::Result::Image::VERSION = '0.001';
}

# ABSTRACT: DBIC result class representing an individual image

use DBIx::Class::Candy -autotable => v1;

primary_column id => {
	data_type         => 'int',
	is_auto_increment => 1,
};

unique_column file_name => {
	data_type => 'varchar',
	size      => 255,
};

column caption => {
	data_type => 'varchar',
	size      => 255,
	is_nullable => 1
};

column date_taken => {
	data_type => 'datetime',
	is_nullable => 1
};

column date_indexed => {
	data_type => 'datetime',
};

has_many colors => 'Imdex::Schema::Result::ImageColor', 'image_id', { order_by => 'weight' };

has_many image_tags => 'Imdex::Schema::Result::ImageTag', 'image_id';
many_to_many tags => image_tags => 'tag';

has_many image_people => 'Imdex::Schema::Result::ImagePerson', 'image_id';
many_to_many people => image_people => 'person';

has_one 'imdex', 'Imdex::Schema::Result::Imdex', 'docid';


sub sqlt_deploy_hook {
	my($self, $sqlt_table) = @_;
	$sqlt_table->add_constraint(name => 'uniq_file_name', fields => ['file_name']);
	$sqlt_table->add_index(name => 'idx_date_taken', fields => ['date_taken']);
	return;
}

1;

__END__
=pod

=head1 NAME

Imdex::Schema::Result::Image - DBIC result class representing an individual image

=head1 VERSION

version 0.001

=head1 AUTHOR

Brian Phillips <bphillips@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Brian Phillips.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

