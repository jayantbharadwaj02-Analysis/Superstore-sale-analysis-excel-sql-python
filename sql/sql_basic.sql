
create database sale_store;
use sale_store;
select * from sale_store_data;
alter table sale_store_data change column  `ï»¿Row ID`  Row_id int ; # change column name.
# First import the sale_store_data in sql.
# Then Divide into four part and insert values  for analysis in sql.


# 1. Customer Data.
# create  Customer Table. 
create table Customer_Table(Customer_id varchar(20) primary key ,
Name varchar(30), 
City varchar(30),State varchar(30)); 
desc Customer_Table;
select * from customer_table;
select * from product_table;

# Insert into Customer Table 
INSERT INTO Customer_Table (Customer_id, Name, City, State)
SELECT 
   `Customer ID`,max(`Customer Name`),
    MAX(city),
    MAX(state)
FROM Sale_store_data
GROUP BY `Customer ID`;


# 2. Product Data.
# create Product table.
create table Product_Table(Product_id varchar(30) primary key ,
Product_Name varchar(100),
Category varchar(20),
Sub_Category varchar(100));


# Insert Into Product Table.
INSERT INTO product_table(Product_id,Product_Name,Category,Sub_Category) 
select `Product ID`,
max(`Product Name`),
max(Category),max(`Sub-Category`) 
from sale_store_data  group by `Product ID`;



# 3. Order Data.
# create Order table.
create table Order_Table(Order_id varchar(50) primary key ,
Order_date date,Ship_date  date,
Customer_id varchar(20), 
foreign key(Customer_id) references Customer_Table(Customer_id) on delete cascade on update cascade);

# insert into order_table.
insert into Order_table(Order_id,Order_date,Ship_date,Customer_id) 
select 
`Order ID`,max(`Order Date`),
max(`Ship Date`),
max(`Customer ID`) 
from sale_store_data group by `Order ID`; 



# 4. Order Details Data.
# Create Order Details table.
create table Order_Details(Order_id varchar(50),
Product_id varchar(100),
Sales float,
Quantity int,
Profit float,
foreign key(Order_id) references Order_Table(Order_id)
on delete cascade 
on update cascade,

foreign key(Product_id) references Product_Table(Product_id)
on delete cascade 
on update cascade );

# insert into order_details
select * from order_details;
INSERT INTO order_details (order_id, product_id, sales, quantity, profit)
SELECT 
    `Order ID`,
    `Product ID`,
    Sales,
    Quantity,
    Profit
FROM sale_store_data;







