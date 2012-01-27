package Imdex::Schema::Result::ImageColor;

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
