create database chat character set utf8;
use chat;
create user 'chat'@'%' identified by 'password';
GRANT ALL PRIVILEGES ON chat.* TO 'chat'@'%'IDENTIFIED BY 'password' WITH GRANT OPTION;
use mysql;
update user set host='%' where user='chat';
flush privileges;
use chat;
