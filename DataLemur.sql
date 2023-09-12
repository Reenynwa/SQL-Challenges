
--Question 1
--Facebook
--Assume you are given the tables below about Facebook pages and page likes. Write a query to return the page IDs of all the Facebook pages that don't have any likes. 
--The output should be in ascending order


SELECT p1.page_id 
FROM pages p1
LEFT JOIN page_likes p2 ON p1.page_id = p2.page_id
WHERE p2.liked_date IS NULL
ORDER BY  page_id ASC ; 

--__________________________________________________________________________________________________________________________________________________________________________________________

--Question 2
--New York Times Questions:
--Assume that you are given the table below containing information on viewership by device type (where the three types are laptop, tablet, and phone). Define “mobile” as the sum of tablet and phone viewership numbers. Write a query to compare the viewership on laptops versus mobile devices. Output the total viewership for laptop and mobile devices in the format of "laptop views" and "mobile_views" 

SELECT 
    SUM(CASE WHEN device_type = 'laptop' THEN 1 ELSE 0  END) AS laptop_views,
      SUM(CASE WHEN device_type IN ('tablet' , 'phone' ) THEN 1 ELSE 0 
        END ) AS mobile_views
FROM viewership

--__________________________________________________________________________________________________________________________________________________________________________________________

--Question 3
--Microsoft
--Write a query to find the top 2 power users who sent the most messages on Microsoft Teams in August 2022. Display the IDs of these 2 users along with the total number of messages they sent. Output the results in descending count of the messages.


SELECT 
    sender_id,
    COUNT(message_id) AS message_count
FROM messages
WHERE sent_date BETWEEN '08/01/2022' AND '08/31/2022'
GROUP BY sender_id
ORDER BY message_count DESC 
LIMIT 2;

OR


SELECT 
  sender_id,
  COUNT(message_id) AS count_messages
FROM messages
WHERE EXTRACT(MONTH FROM sent_date) = '8'
  AND EXTRACT(YEAR FROM sent_date) = '2022'
GROUP BY sender_id
ORDER BY count_messages 
LIMIT 2;

--__________________________________________________________________________________________________________________________________________________________________________________________

--Question 4 
--Walmart
--Assume you are given the following tables on Walmart transactions and products. 
--Find the number of unique product combinations that are bought together (purchased in the same transaction).
--For example, if I find two transactions where apples and bananas are bought, and another transaction where bananas and soy milk are bought, 
--my output would be 2 to represent the 2 unique combinations. Your output should be a single number.


WITH cte_unique_products AS
    (
SELECT   t.product_id AS Product_id, p.product_name, t.transaction_id,t.user_id
FROM products p
    INNER JOIN transactions t using (product_id))
SELECT *  
FROM cte_unique_products c1
  INNER JOIN cte_unique_products c2
    ON  c1.transaction_id  = c2.transaction_id 
    AND c1.product_id >c2.product_id;

--__________________________________________________________________________________________________________________________________________________________________________________________

--Question 5
--You are given the tables below containing information on Robinhood trades and users. Write a query to list the top three cities that have the most completed trade orders in descending order. Output the city and number of orders.

SELECT u.city , 
  COUNT(t.status) as trade_orders 
FROM trades t  
JOIN  users u using (user_id)
WHERE t.status = 'Completed'
GROUP BY 1
ORDER BY trade_orders DESC
LIMIT 3;

--__________________________________________________________________________________________________________________________________________________________________________________________

--Question 6 
--Tesla is investigating bottlenecks in their production, and they need your help to extract the relevant data. Write a SQL query that determines which parts have begun the assembly process but are not yet finished.

SELECT DISTINCT part  
FROM parts_assembly
WHERE finish_date is NULL;

--__________________________________________________________________________________________________________________________________________________________________________

--Question 7
--A Microsoft Azure Supercloud customer is a company that buys at least 1 product from each product category.
--Write a query to report the company ID which is a Supercloud customer.
--(From <https://datalemur.com/questions/supercloud-customer>) 

SELECT  c.Customer_id
FROM customer contracts c
JOIN products p USING (Product_id)
GROUP BY 1
HAVING COUNT( DISTINCT p.product_category)  = 3

--__________________________________________________________________________________________________________________________________________________________________________

--Question8
--New TikTok users sign up with their emails and each user receives a text confirmation to activate their account. Assume you are given the below tables about emails and texts.
--Write a query to display the ids of the users who did not confirm on the first day of sign-up, but confirmed on the second day.
--From <https://datalemur.com/questions/second-day-confirmation> 

SELECT e.user_id
FROM  emails e
JOIN texts t  
USING  (email_id)
WHERE signup_action = 'Confirmed' AND 
t.action_date = e.signup_date + interval '1 day'





