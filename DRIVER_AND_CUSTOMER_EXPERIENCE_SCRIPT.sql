-- DRIVERS AND CUSTOMER EXPERIENCE
USE SQL_PROJECT_FASSOS;
SELECT * FROM DRIVER;
SELECT * FROM INGREDIENTS;
SELECT * FROM  ROLLS;
SELECT * FROM ROLLS_RECIPES;
SELECT * FROM DRIVER_ORDER;
SELECT * FROM CUSTOMERS_ORDERS;

-- 1. WHAT WAS THE AVERAGE TIME AVERAGE TIME IN MINUTE IT TOOK FOR EACH DRIVER TO ARRIVE AT THE FASSOS HEADQUATER TO PICK THE ORDER

WITH TABLE1(MINUTE_DIFF,driver_id) AS
(SELECT TIMESTAMPDIFF(MINUTE,TIME(C.Order_Date) ,TIME(D.Pickup_time)) AS MINUTE_DIFF,driver_id
FROM Customers_Orders C
JOIN Driver_Order D
ON C.order_id=D.order_id
WHERE D.pickup_time IS NOT NULL)

SELECT driver_id,ROUND(AVG(MINUTE_DIFF),2) AS AVG_MINUTE 
FROM TABLE1
GROUP BY driver_id;

-- 2. IS THERE ANY RELATIONSHIP BETWEEN THE NUMBER OF ROLLS AND HOW LONG THE ORDER TAKES TO PREPARE

WITH TABLE1(MINUTE_DIFF,driver_id,roll_id,order_id,customer_id) AS
(SELECT TIMESTAMPDIFF(MINUTE,TIME(C.Order_Date) ,TIME(D.Pickup_time)) AS MINUTE_DIFF,driver_id,C.roll_id,C.order_id,C.customer_id
FROM Customers_Orders C
JOIN Driver_Order D
ON C.order_id=D.order_id
WHERE D.pickup_time IS NOT NULL)

SELECT  order_id, COUNT(roll_id) COUNT_ROLL ,round(SUM(MINUTE_DIFF)/COUNT(roll_id),0) AS TIME_TAKEN from
(SELECT roll_id,Order_id,customer_id,MINUTE_DIFF
FROM TABLE1) final 
GROUP BY  order_id;


-- 3. WHAT WAS THE AVERAGE DISTANCE TRAVEL FOR EACH CUSTOMER 

SELECT Customer_id,Round(AVG(distance),2) as Average_distance
FROM
(SELECT Customer_id,cast(trim(REPLACE(lower(distance),"km","")) AS DECIMAL(4,2)) distance 
FROM CUSTOMERS_ORDERS C
JOIN DRIVER_ORDER D
ON C.order_id=D.order_id) Final
GROUP BY Final.Customer_id;

-- 4. What was the longest and shortest deilivery times for all orders?

SELECT MAX(d)-MIN(d) as difference
FROM
(SELECT cast(final.duration_clean as decimal) as d
from
(SELECT *,
CASE WHEN duration LIKE '%min%' THEN substring(duration,1,2) ELSE duration END AS duration_clean
FROM driver_order
WHERE duration IS NOT NULL) Final) FF;

-- 5.WHAT WAS THE AVERAGE SPEED FOR EACH DRIVER FOR EACH DEILIVERY AND DO YOU NOTICE ANY TREND FOR THIS VALUES

WITH TABLE1 (Speed,order_id,driver_id)
AS
(SELECT distance/time_ AS Speed,order_id,driver_id
FROM
(SELECT cast(trim(REPLACE(lower(distance),"km","")) AS DECIMAL) distance
,CASE WHEN duration LIKE '%min%' then substring(duration,1,2) ELSE duration END AS Time_,order_id,driver_id
FROM DRIVER_ORDER) FINAL)

SELECT X.order_id,COUNT(roll_id),ROUND(avg(speed),2) as Average_speed 
FROM
(SELECT Speed,C.order_id,driver_id,roll_id FROM table1 T
JOIN customers_orders C
ON T.order_id=C.order_id
WHERE Speed IS NOT NULL) X
GROUP BY X.order_id;

-- 6. WHAT IS THE SUCCESSFUL PERCENTAGE FOR EACH DRIVER

SELECT driver_id,(round(SUM(PERCEN)/COUNT(DRIVER_ID),2)*100) AS SUCCESSFUL_DELIVERY_PERCENTAGE
FROM 
(SELECT driver_id,
CASE WHEN Cancellation LIKE '%Cancel%' THEN 0
ELSE 1 END AS PERCEN
FROM DRIVER_ORDER) FINAL
GROUP BY driver_id;





