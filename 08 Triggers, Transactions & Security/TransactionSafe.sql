use tra;
create table safe_talbe(id int primary key,value varchar(100)) engine=InnoDB;

create table UNsafe_talbe(id int primary key,value varchar(100))  engine=MyISAM;

INSERT INTO safe_talbe VALUES (1, 'OK');
INSERT INTO UNsafe_talbe VALUES (1, 'OK');
select * from safe_talbe;
select * from UNsafe_talbe;
commit;
show table status where name='UNsafe_talbe';

