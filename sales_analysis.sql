-- select sales as default database
use sales;

/*check tables in the sales database*/
show tables;

-- each table info  
describe customers;
describe sales.date;
describe markets; 
describe products;
describe transactions;

-- total customer
select count(distinct(custmer_name)) from customers;
-- type of customers
select distinct(customer_type) from customers;
-- name of the markets
select distinct(markets_name) from markets;
-- name of the zones
select distinct(zone) from markets;

-- markets and zones
select distinct(markets_name),zone from markets order by zone; --  need to fix null values

-- type of the products
select distinct(product_type) from products;

-- total transaction
select count(*) as total_data from transactions;

-- see dist salse amount, qty and currency
select distinct(sales_amount) from transactions order by sales_amount; -- -1 and 0 is false data need to remove
select distinct(sales_qty) from transactions order by sales_qty; -- data is looks clean
select distinct(currency) from transactions; -- duplicate values are present in dataset 'INR' 'INR\r' 'USD' 'USD\r'


select * from transactions where currency = 'INR\r';
select * from transactions where currency = 'INR';

select * from transactions where currency = 'USD\r';
select * from transactions where currency = 'USD';

-- amount of data we need to delete
select @less_1:= count(*) from transactions where sales_amount<=0;
select @dup_curr_error:= count(*)  from transactions where currency = 'USD' or currency ='INR' and sales_amount > 0;
select @total_data:= count(*) from transactions;
select @true_data:= count(*) from transactions where currency = 'USD\r' or currency ='INR\r' and sales_amount > 0;

select @dup_curr_error+@true_data+@less_1;-- check we are delecting right data

select ((@less_1+@dup_curr_error)*100)/@total_data as '% delete';
 


select * from date;
select distinct(year) from date order by year;
select distinct(date_yy_mmm) from date order by year(date),month(date);
select min(date) as min_date, max(date) as max_date from date;



/* creat a view of the whith having information
of customer (name and type), market (market and zone), 
product (type), transaction (order date, quantity, amount, currency) 
and date (year and month)*/
create view full_table as
select c.custmer_name, c.customer_type, 
t.sales_qty, t.sales_amount, t.currency, t.order_date, 
m.markets_name,m.zone, 
p.product_type,
t.product_code, year(t.order_date) as year, monthname(t.order_date) as 'month' 
from customers as c 
right join transactions as t on t.customer_code = c.customer_code 
left join markets as m on t.market_code = m.markets_code 
left join products as p on t.product_code = p.product_code;






