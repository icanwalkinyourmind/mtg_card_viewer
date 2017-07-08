create table searched (user_id int, request varcahr(255),index  usr_id_idx (user_id),index  request_idx (request)) charset utf8;
create table users (id int primary key auto_increment, username varchar(40), password varchar(40), balance int) charset utf8; 
