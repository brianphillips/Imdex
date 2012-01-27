package Imdex::Schema;

# ABSTRACT: Root DBIC schema class for the Imdex application

use strict;
use warnings;

use Imdex::ColorUtil;

use base qw/DBIx::Class::Schema/;
 
__PACKAGE__->load_namespaces();

sub connection {
	my $class = shift;
	my $dsn   = shift;
	return $class->SUPER::connection(
		$dsn, '', '',
		{ sqlite_unicode => 1 },
		{
			on_connect_do => sub {
				my ($storage) = @_;
				$storage->dbh->func( 'rgbhex_difference', 2, \&Imdex::ColorUtil::rgbhex_difference, 'create_function' );
			},
		}
	);
}

sub deployment_statements {
	my $self = shift;
	my @statements = $self->SUPER::deployment_statements(@_);
	push @statements, <<'_SQL_';
CREATE VIRTUAL TABLE imdex USING fts4(caption, tags, people, tokenize=porter);
_SQL_
	return @statements;
}

1;
