use Test::More;

use strict;
use warnings;

use Imdex;
use App::Cmd::Tester;

my $result = test_app( Imdex => [qw(--database :memory: index)] );
my $app = $result->app;

is($result->stdout, 'Indexed 0 images', 'no images indexed');
is($result->stderr, '', 'no errors');

done_testing;
