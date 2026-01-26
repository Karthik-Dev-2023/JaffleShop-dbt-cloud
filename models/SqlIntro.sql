-- SELECT 
-- id as Order_ID,
-- user_id as customer_id,
-- order_date,
-- status as order_status
-- from {{ source('jaffle_shop', 'orders') }}
-- -- select * from jaffle-shop-485109.my_analytics.customers
-- where status not in ('completed');

-- -- where status not in ('placed','completed','shipped')


-- SELECT 
-- id,
-- user_id ,
-- order_date,
-- status
-- from jaffle-shop-485109.my_analytics.orders
-- where status = 'completed' order by 1 desc ,3

-- -- Write a SQL statement using the raw.stripe.payment table


-- -- Include all fields except created and _batched_at
-- select id,orderid,paymentmethod,status,amount  from jaffle-shop-485109.my_analytics.payment

-- -- Exclude where payment method is not gift card or coupon and where the amount is more than 600 but less than or equal to 2000

-- select id,orderid,paymentmethod,status,amount  from jaffle-shop-485109.my_analytics.payment where paymentmethod !='gift_card' and amount between 600 and 2000

-- -- Sort by highest payment amount and then smallest order_id
-- select id,
-- orderid,
-- paymentmethod,
-- status,
-- amount 
-- from jaffle-shop-485109.my_analytics.payment 
-- where paymentmethod !='gift_card' and 
-- amount between 600 and 2000 
-- order by 5 desc, 1;
-- -- Note: If you are using BigQuery, your database is not `raw`, it is `dbt-tutorial`.



-- -- SQL TRANSFORMATIONS
-- SELECT
--     case when paymentmethod in ('coupon','gift_card')
--         then 'promotion'
--         when paymentmethod='bank_transfer' then 'wirepayment'
--         else paymentmethod
--     end as methodcategory,
--     sum(amount) as total_amount
-- from jaffle-shop-485109.my_analytics.payment
-- group by 1;



-- select * from jaffle-shop-485109.my_analytics.payment;

-- SELECT
--     case when amount > 1900
--         then 'Large'
--         when amount between 500 and 1900 
--         then 'Medium'
--         else 'Small'
--     end as methodcategory,
--     sum(amount) as total_amount
-- from jaffle-shop-485109.my_analytics.payment
-- group by 1;
-- -- Using raw.stripe.payment as your table, create a new field called ‘amount_category’
-- -- Where if the amount is greater than 1900 call it ‘Large’, if amount is between 500 and 1900 call it ‘Medium’ otherwise the category is ‘Small’select 
-- select
--     case when amount>1900
--         then 'Large'
--         when amount between 500 and 1900 then 'Medium'
--         else 'Small'
--     end as amount_category,
--     sum(amount) as total_amount
-- from jaffle-shop-485109.my_analytics.payment
-- group by 1
-- order by 1

-- -- Sum the amount, and count the number of payments that map to the ‘amount_category’

-- -- Note: If you are using BigQuery, your database is not `raw`, it is `dbt-tutorial`.

-- select 
-- 	case when amount >1900
-- 		then 'Large'
-- 		when amount between 500 and 1900
-- 		then 'Medium'
-- 		else 'Small'
-- 	end as amount_category,
-- 	sum(amount) as total_amount,
-- 	-- count(id) as payment_count
-- from jaffle-shop-485109.my_analytics.payment
-- group by 1
-- order by 1


-- 4.SQL Joins

select* from jaffle-shop-485109.my_analytics.payment
select *from jaffle-shop-485109.my_analytics.orders
select * from jaffle-shop-485109.my_analytics.customers

-- Inner Join - it will return all the matched rows

select * from jaffle-shop-485109.my_analytics.customers
    Inner join jaffle-shop-485109.my_analytics.orders
        on customers.id = orders.user_id
order by customers.id,orders.id


-- Left join - i will return all the rows from the left table and give matched rows from right rows

select * from jaffle-shop-485109.my_analytics.customers
 left join jaffle-shop-485109.my_analytics.orders
    on customers.id= orders.user_id
where orders.user_id is null
order by customers.id,orders.id

-- Right rows - It returns all the rows from right table abnd matched values from the left table

select * from jaffle-shop-485109.my_analytics.customers
 right join jaffle-shop-485109.my_analytics.orders
    on customers.id=orders.user_id
order by customers.id,orders.id

-- full outer join - it returns all the rows from the left and right tables

select * from jaffle-shop-485109.my_analytics.customers
    Inner join jaffle-shop-485109.my_analytics.orders
        on customers.id=orders.user_id
order by customers.id,orders.id

-- Write a SQL statement that pulls all order fields, minus _etl_loaded_at, customer first name, last name, payment method, payment status and payment amount

select * from jaffle-shop-485109.my_analytics.orders

-- Join raw.jaffle_shop.orders to raw.jaffle_shop.customers using orders.user_id and customers.id

select * from jaffle-shop-485109.my_analytics.customers
    Inner Join jaffle-shop-485109.my_analytics.orders
        on customers.id=orders.user_id
order by customers.id,orders.id

-- Join raw.jaffle_shop.orders to raw.stripe.payment using payment.orderid and orders.id

select * from jaffle-shop-485109.my_analytics.orders
    Inner Join jaffle-shop-485109.my_analytics.payment
        on orders.id=payment.orderid
order by orders.id,payment.id

-- Filter to only credit card payments and the amount is over 1000
select * from jaffle-shop-485109.my_analytics.orders
    Inner Join jaffle-shop-485109.my_analytics.payment
        on orders.id=payment.orderid
where payment.paymentmethod='credit_card' and payment.amount>1000
order by orders.id,payment.id

-- Sort by highest payment amount and then by earliest order date

select * from jaffle-shop-485109.my_analytics.orders
    Inner Join jaffle-shop-485109.my_analytics.payment
        on orders.id=payment.orderid
where payment.paymentmethod='credit_card' and payment.amount>1000
order by payment.amount desc, orders.order_date

-- Exclude orders that were returned

select * from jaffle-shop-485109.my_analytics.orders
    Inner Join jaffle-shop-485109.my_analytics.payment
        on orders.id=payment.orderid
where payment.paymentmethod='credit_card' and payment.amount>1000 and orders.status not like "r%"
order by payment.amount desc, orders.order_date


-- Rename the orders.id field to order_id, orders.user_id to customer_id, orders.status to order_status and payment.status to payment_status

-- Note: If you are using BigQuery, your database is not `raw`, it is `dbt-tutorial`.

select 
    orders.id as order_id, 
    orders.user_id as customer_id, 
    orders.order_date, 
    orders.status as order_status,
    customers.first_name,
    customers.last_name,
    payment.paymentmethod,
    payment.status as payment_status,
    payment.amount 
from jaffle-shop-485109.my_analytics.orders
    inner join jaffle-shop-485109.my_analytics.customers
        on orders.user_id = customers.id 
    inner join jaffle-shop-485109.my_analytics.payment
        on orders.id = payment.orderid
where paymentmethod = 'credit_card'
    and amount > 1000
    and orders.status <> 'returned'
order by amount desc, order_date