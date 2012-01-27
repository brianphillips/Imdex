use Test::More;

use strict;
use warnings;

use Imdex;
use App::Cmd::Tester;
use Imdex::Schema;

my $schema = Imdex::Schema->connect('dbi:SQLite:dbname=:memory:');
$schema->deploy;
$schema->storage->dbh_do(
	sub {
		my ( undef, $dbh ) = @_;
		foreach my $sql (<DATA>) {
			$sql =~ s/;//;
			$dbh->do($sql);
		}
	}
);

my $app = Imdex->new();
$app->{schema} = $schema;
my $result = test_app( $app => [qw(--database :memory: search)] );

like($result->stdout, qr/DSCF3700/, 'returns expected image');
is($result->stderr, '', 'no errors');

$app = Imdex->new();
$app->{schema} = $schema;
$result = test_app( $app => [qw(--database :memory: info /path/to/DSCF3700.JPG)] );

like($result->stdout, qr{Tags: restaurant, shrimp}, 'has tags');
like($result->stdout, qr{Colors: Black}, 'has colors');
is($result->stderr, '', 'no errors');

done_testing;


__DATA__
INSERT INTO "images" VALUES(1,'/path/to/DSCF3700.JPG','I prefer my seafood a little less ... natural','2006-01-17 23:13:49','2012-01-27 03:45:26');
INSERT INTO "people" VALUES(1,'Brian Phillips');

INSERT INTO "tags" VALUES(1,'restaurant');
INSERT INTO "tags" VALUES(2,'shrimp');

INSERT INTO "image_colors" VALUES(1,1,'100C08','Black',28);
INSERT INTO "image_colors" VALUES(2,1,'97A1A8','DarkGray',11);
INSERT INTO "image_colors" VALUES(3,1,'261E1B','Black',10);
INSERT INTO "image_colors" VALUES(4,1,'614B3C','SaddleBrown',8);
INSERT INTO "image_colors" VALUES(5,1,'9FB9CA','LightSteelBlue',8);
INSERT INTO "image_colors" VALUES(6,1,'A3695C','IndianRed',7);
INSERT INTO "image_colors" VALUES(7,1,'C38971','DarkSalmon',5);
INSERT INTO "image_colors" VALUES(8,1,'E7E5E3','Gainsboro',5);
INSERT INTO "image_colors" VALUES(9,1,'D0AAA3','RosyBrown',5);
INSERT INTO "image_colors" VALUES(10,1,'788C98','LightSlateGrey',4);
INSERT INTO "image_colors" VALUES(11,1,'B3673B','Chocolate',3);
INSERT INTO "image_colors" VALUES(12,1,'727D85','SlateGray',3);

INSERT INTO "image_people" VALUES(1,1,1);

INSERT INTO "image_tags" VALUES(1,1,'1');
INSERT INTO "image_tags" VALUES(2,1,'2');

INSERT INTO "imdex" (docid, caption, tags, people) values(1, "I prefer my seafood a little less ... natural", "restaurant, shrimp", "Brian Phillips");
