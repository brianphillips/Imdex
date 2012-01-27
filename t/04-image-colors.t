use Test::More;
use Imdex::ColorUtil qw(colors_for_file rgbhex_difference);

my @test_colors = qw(
FFFFFF 000000
ABCDEF ABABEF CDABEF ABEFEF ABEFCD
4E8DCC 4E4ECC 8D4ECC 4ECCCC 4ECC8D
);
foreach my $c(@test_colors){
	my($color) = colors_for_file("xc:#$c"); # uses
	my $diff = rgbhex_difference($color->{hex_color}, $c);
	cmp_ok($diff, '<', 1, "identified primary color $c");
	is($color->{weight}, 100, 'correct weight');
}

my $img = Image::Magick->new( size => '4x5');
$img->Read('xc:#FFFFFF');
$img->Set('pixel[0,0]' => '#FF0000');
$img->Set('pixel[0,1]' => '#FF0000');
$img->Set('pixel[0,2]' => '#FF0000');
$img->Set('pixel[1,0]' => '#0000FF');
$img->Set('pixel[1,1]' => '#0000FF');
$img->Set('pixel[2,0]' => '#00FF00');

my(@colors) = colors_for_file($img);
is($colors[0]->{hex_color}, 'FFFFFF', 'primary color (white)');
is($colors[0]->{weight}, '70', 'secondary color weight (70%)');

is($colors[1]->{hex_color}, 'FF0000', 'secondary color (red)');
is($colors[1]->{weight}, '15', 'secondary color weight (15%)');

is($colors[2]->{hex_color}, '0000FF', 'third color (blue)');
is($colors[2]->{weight}, '10', 'third color weight (10%)');

is($colors[3]->{hex_color}, '00FF00', 'fourth color (green)');
is($colors[3]->{weight}, '5', 'fourth color weight (5%)');

done_testing;
