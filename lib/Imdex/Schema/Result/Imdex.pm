package Imdex::Schema::Result::Imdex;
BEGIN {
  $Imdex::Schema::Result::Imdex::AUTHORITY = 'cpan:BPHILLIPS';
}
{
  $Imdex::Schema::Result::Imdex::VERSION = '0.001';
}

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


__END__
=pod

=head1 NAME

Imdex::Schema::Result::Imdex - DBIC result class representing a row in the full-text-search enabled imdex table

=head1 VERSION

version 0.001

=head1 AUTHOR

Brian Phillips <bphillips@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Brian Phillips.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

