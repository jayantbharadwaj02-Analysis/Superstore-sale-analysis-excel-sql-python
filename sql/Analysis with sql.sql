# # 1. Basic Questions
# 1.1 Find total sales.
select round(sum(Sales),2) as Total_Sales from  order_details;

# 1.2 Find total profit.
select round(sum(profit),2) as Total_profit from order_details;

# 1.3 Count total orders.
select count(order_id) as Total_order  from  order_table;

# 1.4 Find total quantity sold for each product.
select product_id,count(quantity) as Quantity from order_details group by product_id  ;

# 1.5 Find total sales for each category.
select p.category,round(sum(o.sales),3) Total_Sales  from product_table p join order_details o on p.Product_id= o.Product_id  group by p.Category;


# 2. Basic JOIN Questions
# 2.1 Show customer name and order date.
select c.Name,o.order_date from customer_table c join order_table o on c.Customer_id = o.Customer_id ;

# 2.2 Show customer name, product name, and sales.
select c.name,p.product_name,o.sales from customer_table c join order_table on c.Customer_id = order_table.Customer_id 
join order_details o on order_table.Order_id = o.Order_id join product_table p on o.Product_id = p.Product_id; 

# 2.3 Find total sales for each customer.
select c.name, round(sum(o.sales),3) Total_sales from customer_table c join order_table on c.Customer_id = order_table.Customer_id join order_details o  on order_table.Order_id = o.Order_id
 ;

# 2.4 Find total profit for each product.
select p.Product_Name,round(sum(o.profit),3) Total_profit from  product_table p join order_details o   on p.Product_id = o.Product_id  group by p.Product_Name;

# 2.5 Find total sales for each order.

select ob.order_id,round(sum(o.sales),3) total_sales from order_table ob join order_details o on ob.Order_id =  o.Order_id group by ob.Order_id ;




# 3. Basic Subquery Questions
# 3.1 Find orders where sales is greater than average sales.

select order_id,round(sum(sales),3) Total_sales from  order_details   where sales>( select round(avg(sales),3) as avg_sales from  order_details  ) group by Order_id;
select round(avg(sales),2) from order_details;

# 3.2 Find products where profit is greater than average profit.
select order_id, profit   from order_details where Profit>(select  avg(Profit)  from order_details )  ;

# 3.3 Find the order with highest sales.
select order_id,sales from order_details where sales=(select  max(sales) as highest_sales from order_details);
select * from order_details;

# 3.4 Find customers who placed more than average number of orders.
select customer_id, count(order_id) as Total_order from order_table group by customer_id 
having count(order_id) > (select avg(order_count) from
 (  	select count(order_id) as order_count from order_table  group by Customer_id) as  Avg_table) ;
  

# 3.5 Find product with highest total sales.

select product_id ,round(sum(sales),3) as total_sales
from order_details
group by Product_id 
having  sum(sales) =
(select max(total_sales) from( 
select Product_id,sum(sales) as total_sales
 from order_details group by Product_id ) as temp ) ;





# 4. JOIN + Subquery 
# 4.1 Find customers whose total sales is greater than average customer sales.
select c.customer_id,round(sum(o.sales),3) as Total_sales from customer_table c 
join  order_table ob  
on c.customer_id = ob.Customer_id 
join order_details o 
on ob.Order_id = o.Order_id  
group by c.Customer_id 
having sum(o.Sales) >(select avg(total_sales) from 
(select ob.Customer_id,sum(o.Sales) as total_sales from order_table ob join order_details  o  on ob.Order_id =  o.Order_id group by ob.Customer_id )
as avg_sales)  ;


with customer_sales as (select c.customer_id,round(sum(o.sales),3) as Total_sales from customer_table c 
	join  order_table ob  on c.customer_id = ob.Customer_id 
	join order_details o on ob.Order_id = o.Order_id  
	group by c.Customer_id 
	having sum(o.Sales) >(select avg(total_sales) from 
	(select ob.Customer_id,sum(o.Sales) as total_sales from order_table ob join order_details  o  on ob.Order_id =  o.Order_id group by ob.Customer_id )
	as avg_sales)) 
select * from customer_sales
;
 

# 4.2 Find top product in each category.
select Category,Product_Name,Total_sales 
from 
(select p.Category,p.Product_Name,round(sum(o.sales),3) total_sales ,rank() over (partition by p.category order by sum(o.sales)  desc) as  rnk
from product_table p join order_details o on p.Product_id= o.Product_id group by p.Category,p.Product_Name ) as temp where rnk=1;

SELECT category, product_name, total_sales
FROM (
    SELECT 
        p.category,
        p.product_name,
        SUM(od.sales) AS total_sales,
        RANK() OVER (PARTITION BY p.category ORDER BY SUM(od.sales) DESC) AS rnk
    FROM product_table p
    JOIN order_details od ON p.product_id = od.product_id
    GROUP BY p.category, p.product_name
) AS temp
WHERE rnk = 1;
# 4.3 Find orders with total sales greater than average order sales.
select o.order_id,c.name,round(sum(od.sales),3) Total_order from customer_table c join order_table o  on c.Customer_id= o.Customer_id 
join order_details od on o.Order_id = od.Order_id group by o.Order_id 
having sum(sales) >(select avg(order_total) from (select sum(od.Sales) as order_total  from order_details od group by od.Order_id) avg_t ) ;

SELECT 
    o.orderv_id,
    c.Name,
    SUM(od.sales) AS total_sales
FROM Order_Table o
JOIN Customer_Table c ON o.Customer_id = c.Customer_id
JOIN Order_Details od ON o.Order_id = od.order_id
GROUP BY o.order_id, c.Name
HAVING SUM(od.sales) > (
    SELECT AVG(order_total)
    FROM (
        SELECT SUM(sales) AS order_total
        FROM Order_Details
        GROUP BY order_id
    ) AS temp
);

# 4.4 Find customer with highest total profit.
select c.name,round(sum(od. profit),3) as Total_profit from customer_table c join order_table o  on c.Customer_id = o.Customer_id 
join order_details od on o.Order_id = od.Order_id group by c.Name having sum(Profit) =( select max(total_profit) from 
(select  c2.customer_id,sum(od2.Profit) as total_profit from customer_table c2 join order_table on c2.Customer_id = order_table.Customer_id 
join order_details od2 on order_table.Order_id = od2.Order_id  group by c2.Customer_id ) as temp );

SELECT c.Name, SUM(od.profit) AS total_profit
FROM Customer_Table c
JOIN Order_Table o ON c.Customer_id = o.Customer_id
JOIN Order_Details od ON o.Order_id = od.order_id
GROUP BY c.Name
HAVING SUM(profit) = (
    SELECT MAX(total_profit)
    FROM (
        SELECT c2.Customer_id, SUM(od.profit) AS total_profit
        FROM Customer_Table c2
        JOIN Order_Table o2 ON c2.Customer_id = o2.Customer_id
        JOIN Order_Details od2 ON o2.Order_id = od2.order_id
        GROUP BY c2.Customer_id
    ) AS temp
);

# 4.5 Find products with negative profit.
select p.product_name,round(sum(od.profit),3) as total_profit from product_table p join order_details od on p.Product_id = od.Product_id group by p.product_name
having sum(od.Profit) <0;

SELECT p.Product_Name, SUM(od.profit) AS total_profit
FROM Product_Table p
JOIN Order_Details od ON p.product_id = od.product_id
GROUP BY p.Product_Name
HAVING SUM(od.profit) < 0;