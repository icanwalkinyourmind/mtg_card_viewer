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

Функция на вход принимет имя пользователя и возвращает его id в базе данных

=cut

sub id_by_name {

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

=head2 check_balance

Функция на вход принимает имя пользователя, и вовзращает его текущий баланс

=cut

sub check_balance {
    
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

get '/' => sub  {
    template 'index' => { 'title' => 'mtg_card_viewer' };
};

=head2 post '/'

Обработка поискового запроса и генерация ответа

=cut

post '/' => sub {
      
};

true;
