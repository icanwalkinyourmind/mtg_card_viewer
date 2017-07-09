use strict;
use warnings;
use FindBin; use lib "$FindBin::Bin/../lib";
use utf8;

use mtg_card_viewer;
use Test::More tests => 1;

my $new_balance = 2000;

mtg_card_viewer::set_balance('admin', $new_balance);

my $balance = mtg_card_viewer::get_balance('admin');

is($new_balance, $balance, 'Balnce set and get OK');