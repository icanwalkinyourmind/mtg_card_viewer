use strict;
use warnings;
use FindBin; use lib "$FindBin::Bin/../lib";
use utf8;

use mtg_card_viewer;
use Test::More tests => 2;

my $searched = mtg_card_viewer::check_search_histroy('admin', 'test');
ok ($searched, 'searched OK');

$searched = mtg_card_viewer::check_search_histroy('admin', 'Brian Molko');
ok (!$searched, 'do not searched OK');