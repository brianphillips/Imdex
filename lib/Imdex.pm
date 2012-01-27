package Imdex;

# ABSTRACT: Root module for the imdex application

use strict;
use warnings;

use App::Cmd::Setup 0.314 -app;

sub global_opt_spec {
	my($class, $app) = @_;
	my $default_db = sprintf('%s/.imdex.db', File::HomeDir->my_home);
	return (
		[ "database|d=s" => "Imdex database file (defaults to $default_db)", { default => $default_db } ],
	);
}

sub schema {
	my $self = shift;
	my $db = $self->global_options->{database};
	return $self->{schema} if defined $self->{schema};

	my $s = $self->{schema} = Imdex::Schema->connect( "dbi:SQLite:dbname=$db", "", "" );

	if(!-f $db){
		$s->deploy;
	}
	return $self->{schema};
}

1;

=head1 SEE ALSO

See the L<imdex> documentation for how to use this application.

=cut
