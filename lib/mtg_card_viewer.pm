package mtg_card_viewer;
use Dancer2;
use Dancer2::Plugin::Database;
use Dancer2::Plugin::Auth::Extensible;
use Cache::Memcached;
use Web::Query;
use v5.16;

=head1 NAME

MTG-card viewer

=head1 VERSION

Version 0.01

=cut

my $memd = new Cache::Memcached {
    'servers' => [ "0.0.0.0:11211"],
    'debug' => 0,
    'compress_threshold' => 10_000,
};

our $VERSION = '0.1';

=head1 SYNOPSIS

Небольшое веб-приложение для поиска карт Magic: the Gathering

=head1 SUBROUTINES/METHODS

=head2 id_by_name

Функция на вход принимает имя пользователя и возвращает его id в базе данных

=cut

sub id_by_name {
    my $name = shift;
    database->quick_lookup('users', { username => $name }, 'id' );
}

=head2 check_serach_history

Функция принимает на вход имя пользователя и поисковый запрос, и возвращает True или False в зависимости от того
выполнял ли его пользователь

=cut

sub check_search_histroy {
    my $username = shift;
    my $request = shift;
    $request = "\L$request";
    my $id = id_by_name($username);
    
    my $sth = database->prepare("select * from searched where request = ? and user_id = ?;");
    $sth->execute($request, $id);
    my $array_ref = $sth->fetchall_arrayref();
    
    return scalar @{$array_ref}; 
}

=head2 find_card

Функция принимает на вход поисковый запрос и возвращает ссылку на карту, если карта с такми именем найдена, или
False если поиск завершился неудачей

=cut

sub find_card {
    my $request = shift;
    $request = fc($request);
    my $key = $request;
    $key =~ s/\s/_/g;
    my $id = id_by_name(session('logged_in_user'));
    
    #проверяем есть ли ссылка в memcached
    my $link = $memd->get($key);
    if ($link) {
        set_searched($id, $request);
        return $link;
    }
    
    #выполняем поиск на сайте http://magiccards.info/
    $link = 0;
    my $wq = Web::Query->new("http://magiccards.info/query?q=$request&v=scan&s=cname");
    $wq->find("img")->filter(
        sub {
            my ($i, $elem) = @_;
            $link = $elem->attr('src') if ($elem->attr('alt') =~ /^$request$/i);
        }
    );
    
    if ($link) {
       $memd->set($key, $link);
       set_searched($id, $request)
    }
    
    return $link;
}

=head2 set_balance

Процедура на вход принимает имя пользовталея и целое число, и устанавливает баланс пользователя равынй ему

=cut

sub set_balance {
    my $username = shift;
    my $new_balance = shift;
    my $id = id_by_name($username);
    database->quick_update('users', {id => $id}, {balance => $new_balance});
}

=head2 get_balance

Функция на вход принимает имя пользователя, и вовзращает его текущий баланс

=cut

sub get_balance {
    my $username = shift;
    my $id = id_by_name($username);
    return database->quick_lookup('users', { id => $id }, 'balance');
}

=head2

Функция на вход принимает имя пользователя, и реализует списание с его баланса средств за поиск карты
и возвращает True или False в зависимоти от того удалось ли списать средства

=cut

sub pay_for_search {
    my $username = shift;
    my $price = shift;
    
    my $balance = get_balance($username);
    if ($balance >= $price) {
        set_balance($username, $balance-$price);
        return 1;
    } else {
        return 0;
    }
}

=head2 set_searched

Добавляет запись в историю поиска

=cut

sub set_searched {
    my $id =shift;
    my $request = shift;
    my $username = session('logged_in_user');
    my $searched = check_search_histroy($username, $request);
    
    unless ($searched) { 
        database->quick_insert('searched', {'user_id' => $id, 'request' => $request});
    }
}

=head1 PROCESSING REQUESTS

=head2 get '/'

Генерация стартовой страницы

=cut

get '/' => require_login sub {
    my $request = params->{search};
    my $username = session('logged_in_user');
    my $balance = get_balance($username);
      
    template 'index' => {
      title => 'mtg_card_viewer',
      username => $username,
      balance => $balance,
    };
};

=head2 get '/login'

Генерация страницы авторизации

=cut

get '/login' => sub {
    return template 'login'; 
};

=head2 post '/login'

Обработка поискового запроса

=cut

post '/' => require_login sub {
    my $request = params->{search};
    my $username = session('logged_in_user');
    my $searched = check_search_histroy($username, $request);
    my $img_link = find_card($request) if $request;
    my @err;
    
    #платим за поиск если он удался и такой поисковый запрос не совершался
    my $payed = 1;
    $payed = pay_for_search($username, 100) if $img_link and not $searched;
    my $balance = get_balance($username);
    
    #проверяем результаты поиска и оплаты
    push @err, "can't find card" unless $img_link;
    unless ($payed) {
        $img_link = 0;
        push @err, "not enough points";
    }
    
      
    template 'index' => {
      title => 'mtg_card_viewer',
      username => $username,
      balance => $balance,
      img_link => $img_link,
      err => @err,
    };
};

=head2 post '/login'

Авторизация пользвателя

=cut

post '/login' => sub {
        my ($success, $realm) = authenticate_user(
            params->{username}, params->{password}
        );
        if ($success) {
            session logged_in_user => params->{username};
            session logged_in_user_realm => $realm;
            redirect '/';
        } else {
            return template 'login' => {err => ['Wrong username or password']};
        }
};

true;
