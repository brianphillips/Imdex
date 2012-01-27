package Imdex::Schema::Result::ImagePerson;

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
