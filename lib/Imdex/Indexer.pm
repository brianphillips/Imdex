package Imdex::Indexer;

# ABSTRACT: Inspects and indexes and image file

use Carp qw(croak);
use Image::ExifTool 8.75 qw(:Public);
use DateTime;

=method new

A standard constructor that requires a C<schema> attribute be passed in (see the C<SYNOPSIS>).

=cut

sub new {
	my $class = shift;
	my %args = @_;
	croak "no schema passed in" unless $args{schema} && eval { $args{schema}->isa('Imdex::Schema') };
	return bless { schema =>  $args{schema} };
}

=attr schema

An L<Imdex::Schema> instance that will store the indexed information.

=cut

sub schema {
	return shift->{schema};
}

=method index_file

This method takes a filename and introspects the contents for image information.

=cut

sub index_file {
	my $self = shift;
	my $file = shift;
	croak "Not a file: $file" unless( -f $file );
	my $images = $self->schema->resultset('Image');
	my $info = ImageInfo($file, 'Description', 'DateTimeOriginal', 'Keywords', 'RegionName','Error');
	if($info->{Error}){
		warn $info->{Error};
		return;
	}

	my @colors = Imdex::ColorUtil::colors_for_file($file);

	my $result = {
		file_name    => $file,
		caption      => $info->{'Description'} || '',
		date_indexed => DateTime->now->strftime('%F %T'),
		colors       => \@colors
	};

	my $imdex = {};
	$imdex->{caption} = $result->{caption};

	if($info->{DateTimeOriginal}){
		$result->{date_taken} = _format_datetime( $info->{DateTimeOriginal} );
	}

	if(my $k = $info->{Keywords}){
		$result->{image_tags} = [ map { +{ tag_id => $self->_find_tag_id($_) } } split( /,\s*/, $k ) ];
		$imdex->{tags} = $k;
	}

	if(my $p = $info->{RegionName}){
		$result->{image_people} = [ map { +{ person_id => $self->_find_person_id($_) } } split( /,\s*/, $p ) ];
		$imdex->{people} = $p;
	}

	if(my $f = $images->search({ file_name => $file })->first){
		$f->delete;
	}
	my $image = $images->create( $result );
	$image->create_related(imdex => $imdex);
	return $image;
}

sub _format_datetime {
	my $datetime = shift;
	$datetime =~ s/^(\d{4}):(\d{2}):(\d{2})/$1-$2-$3/;
	return $datetime;
}

sub _find_person_id {
	my($self, $person) = @_;
	return $self->schema->resultset('Person')->lookup($person)->id;
}

sub _find_tag_id {
	my($self, $tag) = @_;
	return $self->schema->resultset('Tag')->lookup($tag)->id;
}

1;

=head1 SYNOPSIS

	my $indexer = Imdex::Indexer->new( schema => $schema );

	$indexer->index_file('/path/to/my/photo.jpg');

=head1 DESCRIPTION

This class encompasses the indexing logic for the L<Imdex> application.

=cut
