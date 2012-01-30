package Imdex;
BEGIN {
  $Imdex::AUTHORITY = 'cpan:BPHILLIPS';
}
{
  $Imdex::VERSION = '0.001';
}

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


__END__
=pod

=head1 NAME

Imdex - Root module for the imdex application

=head1 VERSION

version 0.001

=head1 SEE ALSO

See the L<imdex> documentation for how to use this application.

=head1 AUTHOR

Brian Phillips <bphillips@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Brian Phillips.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

