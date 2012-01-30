package Imdex::Schema::Result::ImageTag;
BEGIN {
  $Imdex::Schema::Result::ImageTag::AUTHORITY = 'cpan:BPHILLIPS';
}
{
  $Imdex::Schema::Result::ImageTag::VERSION = '0.001';
}

# ABSTRACT: DBIC result class mapping an image to a tag (many-to-many)

use DBIx::Class::Candy -autotable => v1;

primary_column id => {
	data_type         => 'int',
	is_auto_increment => 1,
};

column image_id => {
	data_type => 'int',
};

column tag_id => {
	data_type => 'varchar',
	size => 64
};

belongs_to 'image', 'Imdex::Schema::Result::Image', 'image_id';
belongs_to 'tag', 'Imdex::Schema::Result::Tag', 'tag_id';

sub sqlt_deploy_hook {
	my($self, $sqlt_table) = @_;
	$sqlt_table->add_index(name => 'idx_image_id', fields => ['image_id']);
	$sqlt_table->add_index(name => 'idx_tag_id', fields => ['tag_id']);
	return;
}

1;

__END__
=pod

=head1 NAME

Imdex::Schema::Result::ImageTag - DBIC result class mapping an image to a tag (many-to-many)

=head1 VERSION

version 0.001

=head1 AUTHOR

Brian Phillips <bphillips@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Brian Phillips.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

