create database sale_store;
use sale_store;
select * from sale_store_data;
alter table sale_store_data change column  `ï»¿Row ID`  Row_id int ;
# First import the sale_store_data in sql.
# Then Divide into four part and insert values  for analysis in sql.


# 1. Customer Data.
create table Customer_Table(Customer_id varchar(20) primary key ,
Name varchar(30), 
City varchar(30),State varchar(30)); 


insert into Customer_Table select `Customer ID`,`Customer Name`,City,State  from Sale_store_data;
# 2. Product Data.

create table Product_Table(Product_id varchar(30) primary key ,
Product_Name varchar(100),
Category varchar(20),
Sub_Category varchar(100));

# 3. Order Data.
create table Order_Table(Order_id varchar(50) primary key ,
Order_date date,Ship_date  date,
Customer_id varchar(20), 
foreign key(Customer_id) references Customer_Table(Customer_id) on delete cascade on update cascade);

# 4. Order Details Data.
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




