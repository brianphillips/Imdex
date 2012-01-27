use Test::More;
use Imdex::Schema;
use Test::Number::Delta within => 1e-4;

my $schema = Imdex::Schema->connect('dbi:SQLite:dbname=:memory:');
$schema->deploy;
$schema->storage->dbh_do(sub {
	my(undef, $dbh) = @_;
	delta_ok( $dbh->selectrow_array('select rgbhex_difference("000000","111111")'), 2.96295, 'rgbhex_difference function deployed successfully');
});

done_testing;
