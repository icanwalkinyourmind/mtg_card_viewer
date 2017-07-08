use strict;
use warnings;
use utf8;
use FindBin; use lib "$FindBin::Bin/../lib";
use DDP;

use mtg_card_viewer;
use Test::More tests => 4;
use Plack::Test;
use HTTP::Request::Common;

my $app = mtg_card_viewer->to_app;
is( ref $app, 'CODE', 'Got app' );

my $test = Plack::Test->create($app);

my $res  = $test->request( GET '/login' );
ok( $res->is_success, '[GET /login] successful' );

$res = $test->request( POST '/login', Content => [username => 'admin', password => 'admin'] );
ok( $res->is_redirect, '[POST /login] successful' );

$res  = $test->request( GET '/' );
ok( $res->is_redirect, '[GET /] successful' );


