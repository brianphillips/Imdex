package Imdex::Command;
BEGIN {
  $Imdex::Command::AUTHORITY = 'cpan:BPHILLIPS';
}
{
  $Imdex::Command::VERSION = '0.001';
}

# ABSTRACT: Abstract super-class for use in building the imdex sub-commands

use strict;
use warnings;
use File::HomeDir;

use App::Cmd::Setup -command;

1;

__END__
=pod

=head1 NAME

Imdex::Command - Abstract super-class for use in building the imdex sub-commands

=head1 VERSION

version 0.001

=head1 AUTHOR

Brian Phillips <bphillips@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Brian Phillips.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

