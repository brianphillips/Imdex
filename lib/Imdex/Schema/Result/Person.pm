package Imdex::Schema::Result::Person;

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
