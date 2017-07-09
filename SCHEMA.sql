create database mtg_viewer charset utf8;
create user mtg_viewer IDENTIFIED BY 'mtg_viewer';
GRANT ALL ON mtg_viewer.* to mtg_viewer;

select mtg_viewer;
create table searched (user_id int, request varcahr(255),index  usr_id_idx (user_id),index  request_idx (request)) charset utf8;
create table users (id int primary key auto_increment, username varchar(40), password varchar(40), balance int) charset utf8;

insert into searched (id, request) values (1, 'test');
insert into users (username, password, balance) values ('admin', 'admin', 2000);




