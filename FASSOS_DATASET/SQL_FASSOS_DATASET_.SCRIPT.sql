-- CREATE DATABASE
CREATE DATABASE SQL_PROJECT_FASSOS;

-- USE DB
USE SQL_PROJECT_FASSOS;

-- CREATE A TABLE DRIVER 
CREATE TABLE DRIVER(
Driver_id int,
Reg_Date date);

-- INSERT VALUES INTO TABLE

INSERT INTO DRIVER  VALUES 
(1,'2021-01-01'),
(2,'2021-01-03'),
(3,'2021-01-08'),
(4,'2021-01-15');

-- CREATE TABLE INGREDIENTS

CREATE TABLE INGREDIENTS(
Ingredients_id int,
Ingredients_name varchar(50));
 
 -- INSERT VALUES INTO INGRDIENTS
 
INSERT INTO INGREDIENTS VALUES 
(1,'BBQ Chicken'),
(2,'Chilli Sauce'),
(3,'Chicken'),
(4,'Cheese'),
(5,'Kebab'),
(6,'Mushrooms'),
(7,'Onions'),
(8,'Egg'),
(9,'Peppers'),
(10,'schezwan sauce'),
(11,'Tomatoes'),
(12,'Tomato Sauce');

-- CREATE TABLE ROLLS 

CREATE TABLE ROLLS (
Rolls_id int,
Rolls_Name varchar(50));

-- INSERT INTO VALUES IN ROLLS TABLE 
INSERT INTO ROLLS VALUES
(1	,'Non Veg Roll'),
(2	,'Veg Roll');

-- CREATE TABLE ROLLS_RECIPES
CREATE TABLE rolls_recipes(
Roll_id integer,
Ingredients varchar(24)); 

-- INSERT VALUES INTO ROLLS_RECIPES

INSERT INTO ROLLS_RECIPES VALUES
(1,'1,2,3,4,5,6,8,10'),
(2,'4,6,7,9,11,12');

-- CREATE TABLE DRIVER_ORDER 
CREATE TABLE DRIVER_ORDER(
order_id integer,
driver_id integer,
pickup_time datetime,
distance VARCHAR(7),
duration VARCHAR(10),
cancellation VARCHAR(23));

-- INSERT VALUES INTO DRIVER_ORDER
INSERT INTO DRIVER_ORDER VALUES
(1,1,'2021-01-01 18:15:34','20km','32 minutes',''),
(2,1,'2021-01-01 19:10:54','20km','27 minutes',''),
(3,1,'2021-01-02 23:57:37','13.4km','20 minutes','NaN'),
(4,2,'2021-01-04 13:53:03','23.4','40 minutes','NaN'),
(5,3,'2021-01-08 21:10:57','10','15 minutes','NaN'),
(6,3,null,null,null,'Cancellation'),
(7,2,'2021-01-08 21:30:45','25km','25 mins',null),
(8,2,'2021-01-09 23:58:02','23.4 km','15 minute',null),
(9,2,null,null,null,'Customer Cancellation'),
(10,1,'2021-01-11 18:50:20','10km','10 minutes',null);

-- CREATE TABLE CUSTOMER_ORDERS
CREATE TABLE CUSTOMERS_ORDERS (
order_id integer,
customer_id integer,
roll_id integer,
not_include_items VARCHAR(4),
extra_items_included VARCHAR(4),
order_date datetime);

-- INSERT VALUES INTO CUSTOMERS_ORDERS 
INSERT INTO CUSTOMERS_ORDERS VALUES
(1,101,1,'','','2021-01-01  18:05:02'),
(2,101,1,'','','2021-01-01 19:00:52'),
(3,102,1,'','','2021-01-02 23:51:23'),
(3,102,2,'','NaN','2021-01-02 23:51:23'),
(4,103,1,'4','','2021-01-04 13:23:46'),
(4,103,1,'4','','2021-01-04 13:23:46'),
(4,103,2,'4','','2021-01-04 13:23:46'),
(5,104,1,null,'1','2021-01-08 21:00:29'),
(6,101,2,null,null,'2021-01-08 21:03:13'),
(7,105,2,null,'1','2021-01-08 21:20:29'),
(8,102,1,null,null,'2021-01-09 23:54:33'),
(9,103,1,'4','1','2021-01-10 11:22:59'),
(10,104,1,null,null,'2021-01-11 18:34:49'),
(10,104,1,'2','6','2021-01-11 18:34:49');

