package Imdex::Schema::ResultSet::Image;
BEGIN {
  $Imdex::Schema::ResultSet::Image::AUTHORITY = 'cpan:BPHILLIPS';
}
{
  $Imdex::Schema::ResultSet::Image::VERSION = '0.001';
}

# ABSTRACT: DBIC resultset class providing various methods for searching images

use Carp qw(croak);

use strict;
use warnings;
use base qw(DBIx::Class::ResultSet);

sub search_keywords {
	my($rs, @keywords) = @_;
	return $rs->search( { 'imdex.imdex' => { match => join(' ', @keywords) } }, { join => 'imdex', order_by => 'matchinfo(imdex)' });
}

sub search_by_color_similarity {
	my($rs, $color, $threshold) = @_;
	$color = uc($color);
	croak "invalid color: $color" unless $color =~ m/^[0-9A-F]{6}$/;
	my $colors = $rs->result_source->schema->resultset('ImageColor')->search(
		\[
			'cast(rgbhex_difference(hex_color, ?) as Integer) <= cast(? as Integer)',
			[ color     => $color ],
			[ threshold => $threshold ]
		],
		{ group_by => 'image_id', columns => ['image_id'], having => \['sum(weight) >= cast(? as integer)', [weight => int(5 + $threshold / 3)] ] }
	);
	return $rs->search( { 'me.id' => { -in => $colors->as_query } } );
}

sub search_before {
	my($rs, $datetime) = @_;
	return $rs->search({ date_taken => { '<=' => $datetime->strftime('%F %T') } });
}

sub search_after {
	my($rs, $datetime) = @_;
	return $rs->search({ date_taken => { '>=' => $datetime->strftime('%F %T') } });
}

1;

__END__
=pod

=head1 NAME

Imdex::Schema::ResultSet::Image - DBIC resultset class providing various methods for searching images

=head1 VERSION

version 0.001

=head1 AUTHOR

Brian Phillips <bphillips@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Brian Phillips.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

