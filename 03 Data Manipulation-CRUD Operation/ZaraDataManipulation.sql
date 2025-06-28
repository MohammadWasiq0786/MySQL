use zara;
select * from products;
select name,price from products;
select name as Prodcutname ,price as ProductPrice from products;
select * from products where promotion ='yes';
select * from products where product_position = 'Front of Store';
select * from products where price > 100 ; 
select * from products where price > 100 and promotion = 'yes' ; 
select * from products where price > 100 or seasonal = 'yes';
select * from products where not promotion = 'yes';
select * from products where name like '%jack%';
select * from products where description like '%slim fit%';
select * from products where section in ('man','women');
select * from products where terms in ('shoes','jeans');
select * from products where price between 100 and 150; 
select * from products where name is null ;
select * from products order by price asc ;
select * from products order by price desc ;
select * from products limit 4;
select * from products order by price asc limit 5 ; 

select count(*) from products;
select avg(price) from products;
select min(price) from products;
select max(price) from products;
select max(price) as m_price from products;
select * from products;
select terms,count(*) from products group by terms;
set sql_safe_updates = 0 ;
update products set promotion='yes' where price >100;
select * from products where price > 100 ;
update products set price = price + 10 where sales_volume > 1000;
select * from products where sales_volume > 1000;


set sql_safe_updates = 0 ;
select * from products;

delete from products where sales_volume < 1500;

truncate table products;
delete table products;
