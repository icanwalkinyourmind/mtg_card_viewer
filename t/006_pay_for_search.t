use strict;
use warnings;
use FindBin; use lib "$FindBin::Bin/../lib";
use utf8;

use mtg_card_viewer;
use Test::More tests => 3;

my $balance = 2000;
mtg_card_viewer::set_balance('admin', $balance);

my $payed = mtg_card_viewer::pay_for_search('admin', 2000);
my $new_balance = mtg_card_viewer::get_balance('admin');
ok ($payed, 'payed OK');
ok ($new_balance == 0, 'right price payed');

$payed = mtg_card_viewer::pay_for_search('admin', 2000);
ok (!$payed, 'can not pay OK');

mtg_card_viewer::set_balance('admin', $balance);