package Imdex::Schema::Result::Imdex;

# ABSTRACT: DBIC result class representing a row in the full-text-search enabled imdex table

use DBIx::Class::Candy;

table 'imdex';

primary_column docid => {
	data_type         => 'int',
	is_auto_increment => 1,
};

column 'caption';
column 'tags';
column 'people';
column 'imdex';

has_one 'image', 'Imdex::Schema::Result::Image', 'id';

sub sqlt_deploy_hook { $_[1]->schema->drop_table ($_[1]) }

1;

