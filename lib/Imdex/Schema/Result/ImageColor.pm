package Imdex::Schema::Result::ImageColor;
BEGIN {
  $Imdex::Schema::Result::ImageColor::AUTHORITY = 'cpan:BPHILLIPS';
}
{
  $Imdex::Schema::Result::ImageColor::VERSION = '0.001';
}

# ABSTRACT: DBIC result class representing an image's various colors

use DBIx::Class::Candy -autotable => v1;

primary_column id => {
	data_type         => 'int',
	is_auto_increment => 1,
};

column image_id => {
	data_type => 'int',
};

column hex_color => {
	data_type => 'varchar',
	size      => 6,
};

column color_name => {
	data_type => 'varchar',
	size      => 32,
};

column weight => {
	data_type => 'int',
};

belongs_to 'image', 'Imdex::Schema::Result::Image', 'image_id';

sub sqlt_deploy_hook {
	my($self, $sqlt_table) = @_;
	$sqlt_table->add_index(name => 'idx_image_id', fields => ['image_id']);
	return;
}

sub as_string {
	my $self = shift;
	return sprintf( '%s (#%s, %d%%)', $self->color_name, $self->hex_color, $self->weight );
}

1;

__END__
=pod

=head1 NAME

Imdex::Schema::Result::ImageColor - DBIC result class representing an image's various colors

=head1 VERSION

version 0.001

=head1 AUTHOR

Brian Phillips <bphillips@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Brian Phillips.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

