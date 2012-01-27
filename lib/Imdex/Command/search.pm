package Imdex::Command::search;

use strict;
use warnings;
use base 'Imdex::Command';

use Imdex::Schema;
use DateTime::Format::Natural;
use Imdex::ColorUtil qw(color_name_hex);

# ABSTRACT: Searches images in the Imdex database

sub usage_desc {
	"imdex search [options] keywords"
}

sub opt_spec {
	my $self = shift;
	my $tolerance = 10;
	return (
		$self->SUPER::opt_spec(@_),

		[ "tag=s@"    => "Specify tags to search by" ],
		[ "person|p=s@" => "Specify person to search by" ],

		[ "before|b=s" => "Specify maximum date (when the picture was taken)" ],
		[ "after|a=s"  => "Specify minimum date (when the picture was taken)" ],

		[ "color|c=s" => "Specify (in RGB hex format) a color to filter by" ],
		[
			"color-tolerance|t=i" => "Specify how similar the color must be (defaults to '$tolerance')",
			{ default => $tolerance }
		],
	);
}

sub validate_args {
	my($self, $opt, $args) = @_;
	if($opt->{color}){

		return if($opt->{color} =~ m/^#?[0-9A-F]{6}$/);

		my $hex = color_name_hex( $opt->{color} );
		if(!$hex){
			die "Invalid color: $opt->{color}\n";
		} else {
			$opt->{color} = $hex;
		}
	}
	return;
}

sub execute {
	my($self, $options, $args) = @_;
	my $schema = $self->app->schema;
	my $rs = $schema->resultset('Image');

	$rs = $rs->search_keywords(@$args) if @$args;

	if(my $tags = $options->{tag}){
		my @t = map { split( /, */, $_ ) } @$tags;
		my $image_tags = $schema->resultset('ImageTag')->image_ids_with_all_tags( @t );
		$rs = $rs->search( { 'me.id' => { -in => $image_tags->as_query } } );
	}

	if(my $people = $options->{person}){
		my @p = map { split( /, */, $_ ) } @$people;
		my $image_people = $schema->resultset('ImagePerson')->image_ids_with_all_people( @p );
		$rs = $rs->search( { 'me.id' => { -in => $image_people->as_query } } );
	}

	if(my $color = $options->{color}){
		$rs = $rs->search_by_color_similarity( $color, $options->{'color_tolerance'} );
	}

	my $parser = DateTime::Format::Natural->new;

	if($options->{before}){
		my $date = $parser->parse_datetime($options->{before}) or warn "unable to parse 'before' date: $options->{before}\n";
		$rs = $rs->search_before($date);
	}

	if($options->{after}){
		my $date = $parser->parse_datetime($options->{after}) or warn "unable to parse 'after' date: $options->{after}\n";
		$rs = $rs->search_after($date);
	}

	my $count = $rs->count;

	while(my $i = $rs->next){
		print $i->file_name, "\n";
	}

	return;
}

1;

=head1 SYNOPSIS

	# full-text search of caption/tags/names
	% imdex search keyword

	# restrict by tag
	% imdex search --tag food

=head1 DESCRIPTION

This module implements the searching logic of the L<imdex> application.  More
examples of the usage can be seen on the main L<imdex> documentation.

=head1 OPTIONS

=over 4

=item * C<--tag>

Restricts search results to those images that match the specified
tag.  May be specified multiple times (returns images that match ALL
restrictions).

=item * C<--person>

Restricts search results to those images that have the specified "name
tags" (i.e. using Picasa's name tagging feature).  May be specified
multiple times (returns images that match ALL restrictions).

=item * C<--before>

Limit search results to those images B<taken before> the date specified.
Any date that can be parsed by L<Date::Format::Natural> can be used (i.e.
'last thursday at 5pm')

=item * C<--after>

Limit search results to those images B<taken after> the date specified.
Any date that can be parsed by L<Date::Format::Natural> can be used (i.e.
'last thursday at 5pm')

=item * C<--color>

Find images that have something close to the color specified
(using the CIEDE-2000 color difference algorithm).
The color must be either a recognized web color name
(i.e. http://en.wikipedia.org/wiki/Web_colors#X11_color_names) or
a hexidecimal RGB value.

=item * C<--color-tolerance>

By default, colors only count as "matching" if they are within a certain
range of the color specified.  The default value is C<10> but if you
would like to adjust that to more or less strict, you can specify a
different value on the command line.

=back

=head1 SEE ALSO

=over 4

=item * L<imdex>

=back

=cut
