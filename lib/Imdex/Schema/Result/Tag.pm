package Imdex::Schema::Result::Tag;

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
