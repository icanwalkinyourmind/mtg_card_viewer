use strict;
use warnings;
use FindBin; use lib "$FindBin::Bin/../lib";
use utf8;

use mtg_card_viewer;
use Test::More tests => 2;

my $link = mtg_card_viewer::find_card('Python');
is ($link, "http://magiccards.info/scans/en/6e/150.jpg", 'Find OK');

$link = mtg_card_viewer::find_card('Tom Yorke');
ok (!$link, 'Wrong card name OK');