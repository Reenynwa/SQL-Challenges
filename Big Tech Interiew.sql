
--Question 1
--Write a query to find the user ids of those who placed a third order on or after 9/21/22 with at least one order from the ATG holding company.

SELECT o.user_id AS user_id
FROM orders o
JOIN brands b ON b.brand_id = o.brand_id
WHERE o.order_id = 3 AND   o.date < '2022-09-21' OR  holding_company_name = 'ATG'

--or
WITH CTE AS (SELECT user_id, RANK() OVER(ORDER BY date) AS rank
FROM brands b
JOIN orders o
ON b.brand_id = o.brand_id
WHERE date >= '9/21/22'
)
SELECT user_id
FROM CTE 
WHERE rank=3;
--______________________________________________________________________________________________________________________________________________________________________

--Question2
--Write a query to find how many bids have been completed in each category for each day of the week. Please order the results by day of week in ASC order.

SELECT  item_category ,  To_char(order_datetime,'Day') AS day_of_week, count(bid_id) AS count
FROM bids 
JOIN items  ON bids.item_id = items.item_id
GROUP BY  day_of_week, item_category
ORDER BY day_of_week ASC;
--__________________________________________________________________________________________________________________________________________________________________________

--Question 3
--Write a query to return the total sales for each Brand Name owned by Beam Suntory (holding company) for each and every date between 3/13/2020 and 6/27/2020 inclusive.

SELECT date as date_sales ,b.brand_name AS brand_name ,sum(price * quantity) AS Total_sales
FROM orders o
JOIN brands b ON o.brand_id = b.brand_id
WHERE  date BETWEEN '2020-03-13' AND  '2020-06-27' 
AND holding_company_name = 'Beam Suntory'
GROUP BY  date_sales,brand_name
