use Test::More;

use Imdex::ColorUtil qw(color_name_hex);

is(color_name_hex('Azure'), 'F0FFFF', 'exact match');
is(color_name_hex('alice blue'), 'F0F8FF', 'lower-cased with spaces');
eval {color_name_hex('blanched-almond') };
ok($@, 'Exception thrown on unknown color');

done_testing;
