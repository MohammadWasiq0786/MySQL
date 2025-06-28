create database if not exists studentDb
use studentDb;
show tables ;

create table students(
student_id INT primary key auto_increment,
name varchar(100) not null,
email varchar(100) unique,
dob date,
registered_on timestamp default current_timestamp);


create table courses(
couurse_id int primary key auto_increment,
course_name varchar(200) not null,
credit_hour int default 3 );

create table enrollment(
enrollment_id int primary key auto_increment,
student_id int,
course_id int ,
enrollment_date date default (current_date),

foreign key (student_id) references students(student_id),
foreign key (course_id)  references courses(couurse_id)
);

insert into students (name,email,dob) values
("sudhanshu","sudhanshu@euron.one",'2002-05-10'),
("sudhanshu","sudhanshu0@euron.one",'2007-05-10'),
("raushan","sudhanshu1@euron.one",'2006-05-10'),
("princece","sudhanshu2@euron.one",'2005-05-10');

select * from students;

insert into courses (course_name,credit_hour) values 
("stats for data sci",6),
("sql masters",9)

select * from courses ;


insert into enrollment(student_id , course_id) values
(5,1),
(5,2),
(6,1),
(7,2);

select * from enrollment;

alter table students add phone varchar(15);

alter table students modify phone varchar(20);

alter table students drop column phone;

select * from students;

rename table enrollment to courseEnrollment;

show tables;

drop table courseEnrollment;
