-- USE DATABASE
USE SQL_PROJECT_FASSOS;

-- FETCHING RECORS 
SELECT * FROM DRIVER;
SELECT * FROM INGREDIENTS;
SELECT * FROM  ROLLS;
SELECT * FROM ROLLS_RECIPES;
SELECT * FROM DRIVER_ORDER;
SELECT * FROM CUSTOMERS_ORDERS;

-- ROLL METRICES

-- 1. HOW MANY ROLLS WERE ORDERED??
SELECT COUNT(roll_id) AS ROLLS_WERE_ORDERED 
FROM CUSTOMERS_ORDERS;

-- 2. HOW MANY UNIQUE CUSTOMER ORDERS WERE MADE?
SELECT COUNT(DISTINCT customer_id) UNIQUE_CUSTOMERS_WERE_ORDERED
FROM CUSTOMERS_ORDERS;

-- 3. HOW MANY SUCCESSFULL ORDERS WERE DELIVERED BY EACH DRIVER?

SELECT driver_id,count(order_id) AS SUCCESSFULL_ORDERS_DELIVERED
FROM DRIVER_ORDER
WHERE cancellation <> 'Cancellation' AND cancellation <> 'Customer Cancellation'
GROUP BY driver_id;

-- 4. HOW MANY OF EACH TYPE OF ROLL WAS DELIVERED?

SELECT roll_id,count(roll_id) AS count_roll_delivered
FROM CUSTOMERS_ORDERS C JOIN 
(SELECT *, 
CASE WHEN cancellation IN ('Cancellation','Customer Cancellation') THEN 'Cancel'
ELSE 'Not Cancel' END AS Is_Delivered
FROM DRIVER_ORDER) U  
ON U.order_id=C.order_id
WHERE Is_Delivered = 'Not Cancel'
GROUP BY  roll_id;

-- 5. HOW MANY VEG AND NON VEG ROLLS WERE ORDERED BY EACH CUSTOMER?

SELECT CUSTOMER_ID,
CASE WHEN ROLL_ID = 1 THEN 'Non Veg'
ELSE "Veg" END AS category,COUNT(ORDER_ID) AS ORDERS_COUNT
FROM CUSTOMERS_ORDERS
GROUP BY CUSTOMER_ID,ROLL_ID
ORDER BY  category DESC;

-- 6.WHAT WAS THE MAXIMUM NUMBERS OF ROLLS DELIVERED IN A SINGLE ORDER

SELECT x.order_id,count_roll_id 
FROM
(SELECT final.order_id,count_roll_id,
ROW_NUMBER() OVER (ORDER BY count_roll_id desc) AS row_num
FROM
(SELECT C.order_id,COUNT(C.roll_id) AS count_roll_id
FROM CUSTOMERS_ORDERS C
JOIN 
(SELECT *, 
CASE WHEN cancellation IN ('Cancellation','Customer Cancellation') THEN 'Cancel'
ELSE 'Not Cancel' END AS Is_Delivered
FROM DRIVER_ORDER) U
ON C.order_id = U.order_id
GROUP BY  U.order_id) final 
) x
WHERE row_num= 1; 

--- OR---- 
SELECT C.order_id,count(C.roll_id) as count_roll_id
FROM CUSTOMERS_ORDERS C
JOIN 
(SELECT *, 
CASE WHEN cancellation IN ('Cancellation','Customer Cancellation') THEN 'Cancel'
ELSE 'Not Cancel' END AS Is_Delivered
FROM DRIVER_ORDER) U
ON C.order_id = U.order_id
group by U.order_id
order by count_roll_id desc
limit 1;

-- 7. FOR EACH CUSTOMER HOW MANY DELIVERED ROLLS HAD ATLEAST ONE CHANGE AND HOW MANY HAD NO CHANGE 

WITH temp_t
(orders_id,driver_id,distance,new_cancellation)
AS (SELECT order_id,driver_id,distance,CASE WHEN cancellation ='Cancellation' OR cancellation='Customer Cancellation' then 'Cancel'
ELSE 'Not Cancel' END AS CNC
FROM driver_order) 

SELECT final.customer_id,final.case_count,COUNT(orders_id) AS count_order_id
FROM
(SELECT *,
CASE WHEN ff.no_include='No Change' AND ff.extra_include='No Change' THEN "NO Change"
ELSE " Atleast one Change" END Case_count
FROM
(select * from temp_t T
JOIN
(SELECT order_id,customer_id,
CASE WHEN not_include_items IS NULL OR not_include_items =''  THEN 'No Change'
else 'Change' end as no_include,
CASE WHEN extra_items_included IS NULL OR extra_items_included ='' OR extra_items_included = 'NaN' THEN 'No Change'
ELSE 'Change' END AS extra_include
FROM CUSTOMERS_ORDERS) T1
ON T.orders_id=T1.order_id
WHERE new_cancellation = 'Not Cancel') ff) final
GROUP BY final.customer_id,final.Case_count;

-- 8. HOW MANY ROLES WERE DELIVERED THAT HAD BOTH EXCLUSIONS AND EXTRAS 

WITH temp_t
(orders_id,driver_id,distance,new_cancellation)
AS (select order_id,driver_id,distance,
CASE WHEN cancellation ='Cancellation' OR cancellation='Customer Cancellation' then 'Cancel'
ELSE 'Not Cancel' end as CNC
from driver_order),
 
table1
(Order_id,customer_id,roll_id,exclude_items,include_items)
AS
(SELECT Order_id,customer_id,roll_id,
CASE WHEN not_include_items='' OR  not_include_items IS NULL OR not_include_items='NaN' THEN "No Change" 
ELSE "Exclude_change"  END AS exclude_items,
CASE WHEN extra_items_included='' OR extra_items_included IS NULL OR extra_items_included='NaN' THEN "No Change"
ELSE "Add_items_change" END AS include_items
FROM CUSTOMERS_ORDERS)

SELECT COUNT(*) as total_exclude_include_items
FROM temp_t T 
JOIN table1 T1
ON T.orders_id=T1.order_id
WHERE exclude_items='Exclude_change' AND include_items='Add_items_change';
 

-- 9. WHAT WAS THE TOTAL NUMBER OF ROLLS ORDERED FOR EACH HOURS OF THE DAY
SELECT concat(cast(hour(ORDER_DATE)AS CHAR),"-",cast(hour(ORDER_DATE)+1 AS CHAR)) hours, count(roll_id) AS Roll_Ordered_hours
FROM CUSTOMERS_ORDERS
GROUP BY hours 
ORDER BY Roll_Ordered_hours DESC;

-- 10. WHAT WAS THE NUMBER OF ORDER FOR EACH DAY OF THE WEEK 
SELECT dayname(order_date) AS Day,count(roll_id) AS roll_orders_day
FROM CUSTOMERS_ORDERS
GROUP BY dayname(order_date)
ORDER BY  roll_orders_day DESC;





