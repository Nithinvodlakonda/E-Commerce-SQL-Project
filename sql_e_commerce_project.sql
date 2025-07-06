
-- PART 1: Customer Insights
-- How many new customers joined each month?
select year(join_date) as year  ,month(join_date) as month ,count(customer_id) as new_customers ,sum(count(customer_id)) over (order by year(join_date),month(join_date)) as total_customers_now
from customers 
group by year,month ;
-- Which cities have the most number of customers?
select city ,count(customer_id) as total_customers from customers 
group by city
order by total_customers desc; 
-- Who are the top 5 customers by total amount spent?
select c.name,sum(p.price*t.quantity) as amount from customers c 
join orders o on c.customer_id=o.customer_id 
join order_items t on o.order_id=t.order_id 
join products p on p.product_id= t.product_id
group by c.name
order by amount desc
limit 5;
-- Which customers ordered more than 1 times?
select c.customer_id,c.name,count(o.order_id) as orders from customers c 
join orders o on c.customer_id=o.customer_id 
group by customer_id
HAVING COUNT(o.order_id) > 1
order by orders desc ;
-- List all customers who haven’t placed any orders.
SELECT c.customer_id, c.name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- PART 2: Order Analysis
-- How many total orders were placed in the last 2 years ?
select count(order_id) from orders
where order_date>curdate() - INTERVAL 2 year;
-- What is the average order value (AOV)?
select avg(average) from 
(select o.order_id,sum(p.price*t.quantity) as average from orders o 
join order_items t on o.order_id=t.order_id 
join products p on p.product_id= t.product_id
group by o.order_id ) as order_payment ;
-- Which day of the week sees the most orders?
select dayname(order_date),count(order_id) from orders
group by dayname(order_date) 
order by count(order_id) desc;
-- What is the cancelation rate of orders?
SELECT 
    total,
    cancelled,
    (cancelled * 100 / total) AS 'cancelation rate'
FROM
    (SELECT 
        COUNT(*) AS total
    FROM
        orders) AS total,
    (SELECT 
        COUNT(order_id) AS cancelled
    FROM
        orders
    WHERE
        status = 'cancelled') AS cancelled;
-- List orders that were paid more than 5 days after ordering.
select o.order_id,date(order_date) , date(payment_date) from orders o join payments a on o.order_id=a.order_id
where   datediff(date(payment_date) ,date(order_date) ) >=5 ;

-- PART 3: Product Analysis
-- Which product categories generated the most revenue?
select sum(price*quantity) as price ,category from products p 
join order_items t on p.product_id=t.product_id group by category ;
-- List the top 10 best-selling products by quantity.
select name,sum(quantity) as quantities from products p join order_items t on p.product_id=t.product_id
group by name 
order by quantities desc limit 10;
-- Find products that were ordered but never paid for.
select o.order_id,name,customer_id from orders o join order_items i on o.order_id =i.order_id join products t on i.product_id=t.product_id  left join payments p on o.order_id=p.order_id
where payment_id is null;
-- Which products have never been ordered at all?
select p.product_id,name from products p left join order_items i on p.product_id = i.product_id left join orders o on i.order_id=o.order_id
where o.order_id is null;
-- What is the average price per category?
select avg(price),count(product_id),category from products
group by category; 

-- PART 4: Revenue & Sales Insights

-- What is the total revenue per month for the last year?
select  sum(price*quantity) as revenue , monthname(payment_date) from orders o  join order_items i on o.order_id=i.order_id 
join products p on p.product_id=i.product_id join payments t on t.order_id=o.order_id
where o.status != 'cancelled' and year(payment_date) = year(current_date())-1
group by monthname(payment_date) ,month(payment_date)
order by month(payment_date);
-- Which 3 months had the highest revenue?
select sum(price*quantity) as revenue ,monthname(payment_date) from payments p join orders o on o.order_id=p.order_id 
join order_items t on t.order_id=o.order_id join products i on i.product_id = t.product_id 
where o.status != 'cancelled' 
group by monthname(payment_date),month(payment_date)
order by revenue desc limit 3;
-- What is the total revenue per city?
select city , sum(price*quantity) as revenue from customers c join orders o on o.customer_id=c.customer_id join order_items t on o.order_id=t.order_id
join products p on p.product_id = t.product_id 
group by city;
-- Calculate monthly growth rate of total revenue.
select year,month , revenue , 
lag(revenue) over (order by year,month) as previous_revenue ,
round((revenue - lag (revenue) over (order by year,month))
/nullif(lag (revenue) over (order by year,month),0)*100,2) AS revenue_growth_percent from 
(SELECT 
    SUM(price * quantity) AS revenue,
    MONTH(payment_date) AS month,
    YEAR(payment_date) AS year
FROM
    orders o
        JOIN
    order_items i ON o.order_id = i.order_id
        JOIN
    products p ON p.product_id = i.product_id
        JOIN
    payments t ON t.order_id = o.order_id
WHERE
    o.status != 'cancelled'
GROUP BY year , month) as monthly_revenue ;

-- Find the % of revenue from returning customers.
WITH customer_revenue AS (select sum(price*quantity) as revenue ,count(o.order_id) as count ,c.customer_id from customers c join orders o on o.customer_id=c.customer_id
join order_items t on t.order_id=o.order_id join products p on p.product_id = t.product_id
group by c.customer_id 
), revenue as ( select sum(case when count >1 then revenue else 0 end ) as return_revenue ,
sum(revenue) as total_revenue from customer_revenue ) select (return_revenue*100)/total_revenue from   revenue;
--  PART 5: Operational/ETL-Type Analysis

-- List all orders with missing or null payment details.
select o.order_id from orders o left join payments p on p.order_id=o.order_id
where payment_id is null;
-- Find duplicate customers (same name, different email).
select count(distinct(email)),name from customers 
group by name 
having count(distinct(email))>1;
-- Find products with price = 0 or NULL.
select product_id from products 
where price is null or price='0';
-- Which orders had quantity = 0 in any order item?
select order_id ,quantity from order_items 
where quantity = 0;
-- Show how many unique products each customer ordered.
select c.customer_id ,count(distinct(p.name)) from customers c left join orders o on o.customer_id=c.customer_id 
left join order_items t on t.order_id= o.order_id 
left join products p on p.product_id=t.product_id
group by c.customer_id
;