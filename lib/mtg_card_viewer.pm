package mtg_card_viewer;
use Dancer2;
use Dancer2::Plugin::Database;
use Dancer2::Plugin::Auth::Extensible;
use HTML::Entities;
use Cache::Memcached;

=head1 NAME

MTG-card viewer

=head1 VERSION

Version 0.01

=cut


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

sub _check_search_histroy {
    
}

=head2 find_card

Функция принимает на вход поисковый запрос и возвращает ссылку на карту, если карта с такми именем найдена, или
False если поиск завершился неудачей

=cut

sub find_card {
    
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

=head2 check_balance

Функция на вход принимает имя пользователя, и вовзращает его текущий баланс

=cut

sub check_balance {
    my $username = shift;
    my $id = id_by_name($username);
    return database->quick_lookup('users', { id => $id }, 'balance');
}

=head2

Процедура на вход принимает имя пользователя, и реализует списание с его баланса средств за поиск карты

=cut

sub pay_for_search {
    
}

=head1 PROCESSING REQUESTS

=head2 get '/'

Генерация стартовой страницы

=cut

get '/' => require_login sub {
    template 'index' => { 'title' => 'mtg_card_viewer' };
};

=head2 get '/login'

Генерация страницы авторизации

=cut

get '/login' => sub {
    return template 'login'; 
};

=head2 post '/'

Обработка поискового запроса и генерация ответа

=cut

post '/' => require_login sub {
      
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
