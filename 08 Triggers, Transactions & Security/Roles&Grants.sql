create user 'test_user'@'localhost' identified by 'pass1234';

grant select on tra.* to 'test_user'@'localhost';

create role 'analyst';
grant select,insert on tra.* to  'analyst';
grant 'analyst' to 'test_user'@'localhost';

select current_role();

set default role 'analyst' to 'test_user'@'localhost';

revoke insert on tra.* from 'analyst';

drop role 'analyst';

show grants for 'test_user'@'localhost';
