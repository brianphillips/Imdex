package Imdex::ColorUtil;
BEGIN {
  $Imdex::ColorUtil::AUTHORITY = 'cpan:BPHILLIPS';
}
{
  $Imdex::ColorUtil::VERSION = '0.001';
}

# ABSTRACT: routines for dealing with colors

use strict;
use warnings;
use Carp qw(croak);
use Math::Complex qw(:pi);
use Graphics::ColorObject 0.5.0 qw(RGB_to_Lab RGB255_to_RGB RGBhex_to_RGB RGB_to_RGBhex);
use Sub::Exporter -setup => { exports => [qw(lab_difference rgb255_difference rgbhex_difference colors_for_file color_name_hex hex_color_name)] };
use Image::Magick;
use Scalar::Util qw(blessed);

our %COLOR_NAMES = (
	AliceBlue            => 'F0F8FF',
	AntiqueWhite         => 'FAEBD7',
	Aqua                 => '00FFFF',
	Aquamarine           => '7FFFD4',
	Azure                => 'F0FFFF',
	Beige                => 'F5F5DC',
	Bisque               => 'FFE4C4',
	Black                => '000000',
	BlanchedAlmond       => 'FFEBCD',
	Blue                 => '0000FF',
	BlueViolet           => '8A2BE2',
	Brown                => 'A52A2A',
	BurlyWood            => 'DEB887',
	CadetBlue            => '5F9EA0',
	Chartreuse           => '7FFF00',
	Chocolate            => 'D2691E',
	Coral                => 'FF7F50',
	CornflowerBlue       => '6495ED',
	Cornsilk             => 'FFF8DC',
	Crimson              => 'DC143C',
	Cyan                 => '00FFFF',
	DarkBlue             => '00008B',
	DarkCyan             => '008B8B',
	DarkGoldenRod        => 'B8860B',
	DarkGray             => 'A9A9A9',
	DarkGrey             => 'A9A9A9',
	DarkGreen            => '006400',
	DarkKhaki            => 'BDB76B',
	DarkMagenta          => '8B008B',
	DarkOliveGreen       => '556B2F',
	Darkorange           => 'FF8C00',
	DarkOrchid           => '9932CC',
	DarkRed              => '8B0000',
	DarkSalmon           => 'E9967A',
	DarkSeaGreen         => '8FBC8F',
	DarkSlateBlue        => '483D8B',
	DarkSlateGray        => '2F4F4F',
	DarkSlateGrey        => '2F4F4F',
	DarkTurquoise        => '00CED1',
	DarkViolet           => '9400D3',
	DeepPink             => 'FF1493',
	DeepSkyBlue          => '00BFFF',
	DimGray              => '696969',
	DimGrey              => '696969',
	DodgerBlue           => '1E90FF',
	FireBrick            => 'B22222',
	FloralWhite          => 'FFFAF0',
	ForestGreen          => '228B22',
	Fuchsia              => 'FF00FF',
	Gainsboro            => 'DCDCDC',
	GhostWhite           => 'F8F8FF',
	Gold                 => 'FFD700',
	GoldenRod            => 'DAA520',
	Gray                 => '808080',
	Grey                 => '808080',
	Green                => '008000',
	GreenYellow          => 'ADFF2F',
	HoneyDew             => 'F0FFF0',
	HotPink              => 'FF69B4',
	IndianRed            => 'CD5C5C',
	Indigo               => '4B0082',
	Ivory                => 'FFFFF0',
	Khaki                => 'F0E68C',
	Lavender             => 'E6E6FA',
	LavenderBlush        => 'FFF0F5',
	LawnGreen            => '7CFC00',
	LemonChiffon         => 'FFFACD',
	LightBlue            => 'ADD8E6',
	LightCoral           => 'F08080',
	LightCyan            => 'E0FFFF',
	LightGoldenRodYellow => 'FAFAD2',
	LightGray            => 'D3D3D3',
	LightGrey            => 'D3D3D3',
	LightGreen           => '90EE90',
	LightPink            => 'FFB6C1',
	LightSalmon          => 'FFA07A',
	LightSeaGreen        => '20B2AA',
	LightSkyBlue         => '87CEFA',
	LightSlateGray       => '778899',
	LightSlateGrey       => '778899',
	LightSteelBlue       => 'B0C4DE',
	LightYellow          => 'FFFFE0',
	Lime                 => '00FF00',
	LimeGreen            => '32CD32',
	Linen                => 'FAF0E6',
	Magenta              => 'FF00FF',
	Maroon               => '800000',
	MediumAquaMarine     => '66CDAA',
	MediumBlue           => '0000CD',
	MediumOrchid         => 'BA55D3',
	MediumPurple         => '9370D8',
	MediumSeaGreen       => '3CB371',
	MediumSlateBlue      => '7B68EE',
	MediumSpringGreen    => '00FA9A',
	MediumTurquoise      => '48D1CC',
	MediumVioletRed      => 'C71585',
	MidnightBlue         => '191970',
	MintCream            => 'F5FFFA',
	MistyRose            => 'FFE4E1',
	Moccasin             => 'FFE4B5',
	NavajoWhite          => 'FFDEAD',
	Navy                 => '000080',
	OldLace              => 'FDF5E6',
	Olive                => '808000',
	OliveDrab            => '6B8E23',
	Orange               => 'FFA500',
	OrangeRed            => 'FF4500',
	Orchid               => 'DA70D6',
	PaleGoldenRod        => 'EEE8AA',
	PaleGreen            => '98FB98',
	PaleTurquoise        => 'AFEEEE',
	PaleVioletRed        => 'D87093',
	PapayaWhip           => 'FFEFD5',
	PeachPuff            => 'FFDAB9',
	Peru                 => 'CD853F',
	Pink                 => 'FFC0CB',
	Plum                 => 'DDA0DD',
	PowderBlue           => 'B0E0E6',
	Purple               => '800080',
	Red                  => 'FF0000',
	RosyBrown            => 'BC8F8F',
	RoyalBlue            => '4169E1',
	SaddleBrown          => '8B4513',
	Salmon               => 'FA8072',
	SandyBrown           => 'F4A460',
	SeaGreen             => '2E8B57',
	SeaShell             => 'FFF5EE',
	Sienna               => 'A0522D',
	Silver               => 'C0C0C0',
	SkyBlue              => '87CEEB',
	SlateBlue            => '6A5ACD',
	SlateGray            => '708090',
	SlateGrey            => '708090',
	Snow                 => 'FFFAFA',
	SpringGreen          => '00FF7F',
	SteelBlue            => '4682B4',
	Tan                  => 'D2B48C',
	Teal                 => '008080',
	Thistle              => 'D8BFD8',
	Tomato               => 'FF6347',
	Turquoise            => '40E0D0',
	Violet               => 'EE82EE',
	Wheat                => 'F5DEB3',
	White                => 'FFFFFF',
	WhiteSmoke           => 'F5F5F5',
	Yellow               => 'FFFF00',
	YellowGreen          => '9ACD32',
);


sub lab_difference {
	my ( $lab1, $lab2 ) = @_;
	return _lab_difference_perl( @$lab1, @$lab2 );
}


sub rgb255_difference {
	my ( $rgb1, $rgb2 ) = @_;
	return _lab_difference_perl( map { @{ RGB_to_Lab( RGB255_to_RGB($_) ) } } $rgb1, $rgb2 );
}


sub rgbhex_difference {
	my ( $rgb1, $rgb2 ) = @_;
	return _lab_difference_perl( map { @{ RGB_to_Lab( RGBhex_to_RGB($_) ) } } $rgb1, $rgb2 );
}


sub colors_for_file {
	my $file = shift;
	my $img;
	if(blessed $file && $file->isa('Image::Magick')){
		$img = $file;
	} else {
		$img = Image::Magick->new;
		$img->Read($file . '[200x200]' );
	}
	$img->Quantize( dither => 0, colors => 12 );

	my @raw_histogram = $img->Histogram;
	my @histogram;
	my $total = 0;

	while (@raw_histogram) {
		my ( $r, $g, $b, $o, $c ) = splice( @raw_histogram, 0, 5 );
		$total += $c;
		push( @histogram,
			{ hex_color => RGB_to_RGBhex( RGB255_to_RGB( [ map { ( $_ / 255 ) } $r, $g, $b ] ) ), count => $c }
		);
	}

	@histogram = sort { $b->{count} <=> $a->{count} } @histogram;

	foreach my $h (@histogram) {
		$h->{weight} = int( delete( $h->{count} ) * 100 / $total );
		$h->{color_name} = hex_color_name( $h->{hex_color} );
	}

	return @histogram;
}


sub hex_color_name {
	my $color = shift;
	my $match_score = -1;
	my $match = 'Unknown';
	foreach my $name(keys %COLOR_NAMES){
		my $score = rgbhex_difference($color, $COLOR_NAMES{$name});
		if($match_score < 0 || $score < $match_score){
			$match = $name;
			$match_score = $score;
		}
	}
	return $match;
}


sub color_name_hex {
	my $name = shift;
	$name =~ s/\s//g;
	foreach my $n(keys %COLOR_NAMES){
		return $COLOR_NAMES{$n} if lc $n eq lc $name;
	}
	croak "Unknown color name $name";
}

# 
# This code demonstrates the CIEDE-2000 color difference algorithm
# Adapted from http://www.codingtiger.com/questions/algorithm/How-can-I-further-optimize-this-color-difference-function.html which
# in turn was adapted from http://www.ece.rochester.edu/~gsharma/ciede2000/
# 
sub _lab_difference_perl {
	my($L1, $a1, $b1, $L2, $a2, $b2) = (@_);

    # Cab = sqrt(a^2 + b^2)
    my $Cab1 = sqrt($a1 ** 2 + $b1 ** 2);
    my $Cab2 = sqrt($a2 ** 2 + $b2 ** 2);

    # CabAvg = (Cab1 + Cab2) / 2
    my $CabAvg = ($Cab1 + $Cab2) / 2;

    # G = 1 + (1 - sqrt((CabAvg^7) / (CabAvg^7 + 25^7))) / 2
    my $CabAvg7 = $CabAvg ** 7;
    my $G = 1 + (1 - sqrt($CabAvg7 / ($CabAvg7 + 25 ** 7))) / 2;

    # ap = G * a
    my $ap1 = $G * $a1;
    my $ap2 = $G * $a2;

    # Cp = sqrt(ap^2 + b^2)
    my $Cp1 = sqrt($ap1 ** 2 + $b1 ** 2);
    my $Cp2 = sqrt($ap2 ** 2 + $b2 ** 2);

    # CpProd = (Cp1 * Cp2)
    my $CpProd = $Cp1 * $Cp2;

    # hp1 = atan2(b1, ap1)
    my $hp1 = atan2($b1, $ap1);
    # ensure hue is between 0 and 2pi
    if ($hp1 < 0) {
        # hp1 = hp1 + 2pi
        $hp1 += pi2;
    }

    # hp2 = atan2(b2, ap2)
    my $hp2 = atan2($b2, $ap2);
    # ensure hue is between 0 and 2pi
    if ($hp2 < 0) {
        # hp2 = hp2 + 2pi
        $hp2 += pi2;
    }

    # dL = L2 - L1
    my $dL = $L2 - $L1;

    # dC = Cp2 - Cp1
    my $dC = $Cp2 - $Cp1;

    # computation of hue difference
    my $dhp = 0;
    # set hue difference to zero if the product of chromas is zero
    if ($CpProd != 0) {
        # dhp = hp2 - hp1
        $dhp = $hp2 - $hp1;
        if ($dhp >  pi) {
            # dhp = dhp - 2pi
            $dhp -=  pi2;
        } elsif ($dhp < - pi) {
            # dhp = dhp + 2pi
            $dhp += pi2;
        }
    }

    # dH = 2 * sqrt(CpProd) * sin(dhp / 2)
    my $dH = 2 * sqrt($CpProd) * sin($dhp / 2);

    # weighting functions
    # Lp = (L1 + L2) / 2 - 50
    my $Lp = ($L1 + $L2) / 2 - 50;

    # Cp = (Cp1 + Cp2) / 2
    my $Cp = ($Cp1 + $Cp2) / 2;

    # average hue computation
    # hp = (hp1 + hp2) / 2
    my $hp = ($hp1 + $hp2) / 2;

    # identify positions for which abs hue diff exceeds 180 degrees
    if (abs($hp1 - $hp2) > pi) {
        # hp = hp - pi
        $hp -= pi;
    }
    # ensure hue is between 0 and 2pi
    if ($hp < 0) {
        # hp = hp + 2pi
        $hp += pi2;
    }

    # LpSqr = Lp^2
    my $LpSqr = $Lp * $Lp;

    # Sl = 1 + 0.015 * LpSqr / sqrt(20 + LpSqr)
    my $Sl = 1 + 0.015 * $LpSqr / sqrt(20 + $LpSqr);

    # Sc = 1 + 0.045 * Cp
    my $Sc = 1 + 0.045 * $Cp;

    # T = 1 - 0.17 * cos(hp - pi / 6) +
    #       + 0.24 * cos(2 * hp) +
    #       + 0.32 * cos(3 * hp + pi / 30) -
    #       - 0.20 * cos(4 * hp - 63 * pi / 180)
    my $hphp = $hp + $hp;
    my $T = 1 - 0.17 * cos($hp - pi / 6)
            + 0.24 * cos($hphp)
            + 0.32 * cos($hphp + $hp + pi / 30)
            - 0.20 * cos($hphp + $hphp - (63 * pi / 180));

    # Sh = 1 + 0.015 * Cp * T
    my $Sh = 1 + 0.015 * $Cp * $T;

    # deltaThetaRad = (pi / 3) * e^-(36 / (5 * pi) * hp - 11)^2
    my $powerBase = $hp - 4.799655442984406;
    my $deltaThetaRad = (pi / 3) * exp(-5.25249016001879 * $powerBase * $powerBase);

    # Rc = 2 * sqrt((Cp^7) / (Cp^7 + 25^7))
    my $Cp7 = $Cp ** 7;
    my $Rc = 2 * sqrt($Cp7 / ($Cp7 + 25 ** 7));

    # RT = -sin(delthetarad) * Rc
    my $RT = -sin($deltaThetaRad) * $Rc;

    # de00 = sqrt((dL / Sl)^2 + (dC / Sc)^2 + (dH / Sh)^2 + RT * (dC / Sc) * (dH / Sh))
    my $dLSl = $dL / $Sl;
    my $dCSc = $dC / $Sc;
    my $dHSh = $dH / $Sh;
    return sqrt($dLSl * $dLSl + $dCSc * $dCSc + $dHSh * $dHSh + $RT * $dCSc * $dHSh);
}

1;


__END__
=pod

=head1 NAME

Imdex::ColorUtil - routines for dealing with colors

=head1 VERSION

version 0.001

=head1 SYNOPSIS

	use Imdex::ColorUtil qw(rgbhex_difference colors_for_file color_name_hex hex_color_name);

	rgbhex_difference('000000','FFFFFF'); # returns 100
	rgbhex_difference('000000','000000'); # returns 0

	# returns a list of colors sorted by weight, descending in the file passed in
	my @colors = colors_for_file('/path/to/image.jpg');

	my $primary_color        = $colors[0]->{hex_color};    # RGB hexidecimal representation of the color
	my $primary_color_weight = $colors[0]->{weight};       # 0 - 100 percentage
	my $primary_color_name   = $colors[0]->{color_name};   # color name that approximates the actual color

	my $color_name = hex_color_name('ABCDEF');     # returns color name that approximates the passed in hexidecimal value
	my $color_hex  = color_name_hex('DarkBlue');   # canonical RGB hexidecimal value for this color name

=head1 DESCRIPTION

This library implements a few color-handling functions for Imdex.

=head1 FUNCTIONS

=head2 lab_difference

Computes the differents (on a scale of 1-100) of two C<L*a*b*> color values passed in (as two array refs) using the CIEDE-2000 algorithm.

=head2 rgb255_difference

Computes the differents (on a scale of 1-100) of two C<RGB> color values passed in (as two array refs) using the CIEDE-2000 algorithm.

=head2 rgbhex_difference

Computes the differents (on a scale of 1-100) of two hexidecimal color values passed in using the CIEDE-2000 algorithm.

=head2 colors_for_file

Returns the list of hashrefs containing the colors sorted by most common
to least common.  The list of hashrefs that are returned has the following structure:

	{
		hex_color  => 'FF0000',    # hexidecimal RGB value
		color_name => 'Red',       # canonical name for that color
		weight     => '40'         # percentage of the picture that consists of this color
	}

Before calculating the different colors in the image, the image is
resized a max height or width of 200px and quantized down to 12 colors.

=head2 hex_color_name

Returns the color name (based on the W3C list of HTML color names)
that most closely reflects the hexidecimal value that is passed in.
The comparison is based on the CIEDE-2000 color difference algorithm.

=head2 color_name_hex

Returns the hexidecimal value for the color name that is passed into the
function.  The color name must be on the list of Web color names (see
L<http://en.wikipedia.org/wiki/Web_colors#X11_color_names>).

=head1 AUTHOR

Brian Phillips <bphillips@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Brian Phillips.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

