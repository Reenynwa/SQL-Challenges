
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
--Assume that you are given the table below containing information on viewership by device type (where the three types are laptop, tablet, and phone). 
--Define “mobile” as the sum of tablet and phone viewership numbers. Write a query to compare the viewership on laptops versus mobile devices. Output the total viewership for laptop and mobile devices in the format of "laptop views" and "mobile_views" 

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

--__________________________________________________________________________________________________________________________________________________________________________
--Question 9
--A phone call is considered an international call when the person calling is in a different country than the person receiving the call.
--What percentage of phone calls are international? Round the result to 1 decimal.
--Assumption:
--•The caller_id in phone_info table refers to both the caller and receiver.
--From <https://datalemur.com/questions/international-call-percentage> 

SELECT
ROUND(
AVG(CASE 
 WHEN pic.country_id <> prc.country_id 
   THEN 1 ELSE 0 END) *100,1) AS intl_calls
FROM phone_calls pc  
JOIN phone_info pic ON pc.caller_id = pic.caller_id
JOIN phone_info prc ON pc.receiver_id = prc.caller_id
--__________________________________________________________________________________________________________________________________________________________________________

--Question 10
--Julia just finished conducting a coding contest, and she needs your help assembling the leaderboard! Write a query to print the respective hacker_id and name of hackers who achieved full scores for more than one challenge. Order your output in descending order by the total number of challenges in which the hacker earned a full score. If more than one hacker received full scores in same number of challenges, then sort them by ascending hacker_id.
--From <https://www.hackerrank.com/challenges/full-score/problem?isFullScreen=true> 
 
SELECT  h.name, h.hacker_id
FROM hackers h
JOIN submissions s 
ON h.hacker_id = s.hacker_id 
JOIN difficulty d 
ON s.score = d.score
WHERE s.score = d.score 
GROUP BY 1,2
HAVING  COUNT(s.challenge_id ) > 1
ORDER BY COUNT(s.challenge_id) DESC, h.hacker_id ASC
--__________________________________________________________________________________________________________________________________________________________________________

--Question 11
--This is the same question as problem #8 in the SQL Chapter of Ace the Data Science Interview!
--Assume you are given the table below that shows job postings for all companies on the LinkedIn platform. Write a query to get the number of companies that have posted duplicate job listings.
--Clarification:
--• Duplicate job listings refer to two jobs at the same company with the same title and description.
--From <https://datalemur.com/questions/duplicate-job-listings> 

WITH Ranks  
AS (SELECT
ROW_NUMBER () OVER(PARTITION BY title) as rank, 
company_id, title, description
FROM job_listings)

SELECT COUNT(DISTINCT company_id)
FROM ranks 
WHERE rank > 1
--__________________________________________________________________________________________________________________________________________________________________________

--Question 12
--Given a table of candidates and their skills, you're tasked with finding the candidates best suited for an open Data Science job. You want to find candidates who are proficient in Python, Tableau, and PostgreSQL.Write a query to list the candidates who possess all of the required skills for the job. Sort the the output by candidate ID in ascending order.
--From <https://datalemur.com/questions/matching-skills> 

SELECT candidate_id
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY 1
HAVING COUNT (candidate_id) = 3
ORDER BY candidate_id ASC

--__________________________________________________________________________________________________________________________________________________________________________

--Question 13
--Assume there are three Spotify tables containing information about the artists, songs, and music charts. Write a query to determine the top 5 artists whose songs appear in the Top 10 of the global_song_rank table the highest number of times. From now on, we'll refer to this ranking number as "song appearances". 
--Output the top 5 artist names in ascending order along with their song appearances ranking (not the number of song appearances, but the rank of who has the most appearances). The order of the rank should take precedence.
--For example, Ed Sheeran's songs appeared 5 times in Top 10 list of the global song rank table; this is the highest number of appearances, so he is ranked 1st. Bad Bunny's songs appeared in the list 4, so he comes in at a close 2nd.
--Assumptions:
--• If two artists' songs have the same number of appearances, the artists should have the same rank.
--• The rank number should be continuous (1, 2, 2, 3, 4, 5) and not skipped (1, 2, 2, 4, 5).
--From <https://datalemur.com/questions/top-fans-rank> 

WITH top_10_arstist AS 
(
SELECT a.Artist_name, 
DENSE_RANK() OVER( ORDER BY COUNT (a.artist_name) DESC ) AS artist_rank
FROM global_song_rank g  
JOIN  songs s ON s.song_id = g.song_id
JOIN artists a ON a.artist_id = s.artist_id
WHERE g.rank < 11
GROUP BY 1
ORDER BY artist_rank  ASC )

SELECT * 
FROM top_10_arstist
where artist_rank < 6

--__________________________________________________________________________________________________________________________________________________________________________

--Question 14
--Your team at JPMorgan Chase is soon launching a new credit card, and to gain some context, you are analyzing how many credit cards were issued each month.
--Write a query that outputs the name of each credit card and the difference in issued amount between the month with the most cards issued, and the least cards issued. Order the results according to the biggest difference.
--From <https://datalemur.com/questions/cards-issued-difference> 

SELECT 
  card_name, (max(issued_amount) - MIN(issued_amount)) AS Card_difference                       
FROM monthly_cards_issued                                                                                                                               
GROUP BY 1                                                                                                                                                       order by  2 desc

--__________________________________________________________________________________________________________________________________________________________________________

--Question 15
--CVS Health is trying to better understand its pharmacy sales, and how well different products are selling. Each drug can only be produced by one manufacturer.
--Write a query to find the top 3 most profitable drugs sold, and how much profit they made. Assume that there are no ties in the profits. Display the result from the highest to the lowest total profit.
--Definition:
--• Cogs stands for Cost of Goods Sold which is the direct cost associated with producing the drug.
--• Total Profit = Total Sales - Cost of Goods Sold
--From <https://datalemur.com/questions/top-profitable-drugs> 

SELECT drug, (  total_sales - cogs ) total_profit
FROM pharmacy_sales
ORDER BY 2 DESC
LIMIT 3
--__________________________________________________________________________________________________________________________________________________________________________

--Question 16
--Your team at JPMorgan Chase is soon launching a new credit card. You are asked to estimate how many cards you'll issue in the first month.
--Before you can answer this question, you want to first get some perspective on how well new credit card launches typically do in their first month.
--Write a query that outputs the name of the credit card, and how many cards were issued in its launch month. The launch month is the earliest record in the monthly_cards_issued table for a given card. Order the results starting from the biggest issued amount.
--From <https://datalemur.com/questions/card-launch-success> 

WITH rank AS
(
SELECT *,
Row_Number()OVER(PARTITION BY card_name ORDER BY issue_year, issue_month) issue_rank
FROM monthly_cards_issued
)
SELECT card_name,issued_amount
FROM rank
WHERE issue_rank =1
ORDER BY issued_amount DESC
--__________________________________________________________________________________________________________________________________________________________________________

--Question 17
--Given a table of Facebook posts, for each user who posted at least twice in 2021, write a query to find the number of days between each user’s first post of the year and last post of the year in the year 2021. Output the user and number of the days between each user's first and last post.
--From <https://datalemur.com/questions/sql-average-post-hiatus-1> 


WITH first_last_post AS 
(
SELECT user_id, MIN(Post_date) AS first_post , MAX(post_date) AS last_post
FROM posts
WHERE post_date BETWEEN '01/01/2021' AND '12/31/2021'
GROUP BY 1
HAVING COUNT(user_id) > 2
)
SELECT 
user_id , EXTRACT(day from last_post - first_post) AS days_between
FROM First_last_post
 
OR
SELECT user_id, 
EXTRACT(DAY FROM MAX(post_date)-MIN(post_date)) as days_between
FROM posts
WHERE EXTRACT(YEAR FROM post_date) = 2021
GROUP BY 1
HAVING COUNT(post_id) >=2;
--__________________________________________________________________________________________________________________________________________________________________________

--Question 18
--This is the same question as problem #1 in the SQL Chapter of Ace the Data Science Interview!
--Assume you have an events table on app analytics. Write a query to get the app’s click-through rate (CTR %) in 2022. Output the results in percentages rounded to 2 decimal places.
--Notes:
--Percentage of click-through rate = 100.0 * Number of clicks / Number of impressions
--To avoid integer division, you should multiply the click-through rate by 100.0, not 100.
--From <https://datalemur.com/questions/click-through-rate> 

WITH cte1 AS 
 (SELECT  app_id, 
COUNT(*) as count_click 
FROM events
WHERE event_type = 'click'
AND EXTRACT( YEAR FROM timestamp) = '2022'
GROUP BY 1),

 cte2 AS
 ( SELECT app_id, 
COUNT(*) AS count_impression 
FROM events
WHERE event_type = 'impression'
and EXTRACT( YEAR FROM timestamp) = '2022'
GROUP BY 1)

Select cte1.app_id ,ROUND((count_click * 100.0  /count_impression),2) AS ctr 
FROM cte2
JOIN cte1 
USING (app_id)
GROUP BY  1 ,2

OR 

WITH CTE AS 
(
SELECT app_id AS app, SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) AS clicks,
      SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END) AS impressions
FROM events
WHERE EXTRACT(YEAR FROM timestamp) = 2022
GROUP BY 1
)

SELECT app as app_id, ROUND(100.0 * clicks/impressions,2) as ctr
FROM CTE



--__________________________________________________________________________________________________________________________________________________________________________

--Question 19
--Given the reviews table, write a query to get the average stars for each product every month.
--The output should include the month in numerical value, product id, and average star rating rounded to two decimal places. Sort the output based on month followed by the product id.
--From <https://datalemur.com/questions/sql-avg-review-ratings> 

SELECT EXTRACT(MONTH FROM submit_date) as month,product_id, 
ROUND(AVG(stars),2) 
FROM reviews
GROUP BY 1,2
ORDER BY 1,2
--__________________________________________________________________________________________________________________________________________________________________________

--Question 20
--Assume you are given the table containing information on Amazon customers and their spending on products in various categories. Identify the top two highest-grossing products within each category in 2022. Output the category, product, and total spend.
--From <https://datalemur.com/questions/sql-highest-grossing> 

SELECT Category, product, sum(spend) Total_spend 
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date) ='2022'
GROUP BY 1,2
ORDER BY category, total_spend DESC
LIMIT 4
--__________________________________________________________________________________________________________________________________________________________________________

--Question 21
--When you log in to your retailer client's database, you notice that their product catalog data is full of gaps in the category column. Can you write a SQL query that returns the product catalog with the missing data filled in?
--Assumptions
--• Each category is mentioned only once in a category column.
--• All the products belonging to same category are grouped together.
--• The first product from a product group will always have a defined category.
--• Meaning that the first item from each category will not have a missing category value.
--From <https://datalemur.com/questions/fill-missing-product> 

WITH fill_products
AS (SELECT
  product_id,
  category,
  name,
  COUNT(category) OVER (ORDER BY product_id) AS category_group
FROM products)
SELECT
  product_id,
  FIRST_VALUE (category) OVER (PARTITION BY category_group ORDER BY product_id) AS category,
  name
FROM fill_products
--__________________________________________________________________________________________________________________________________________________________________________

--Question 22
--This is the same question as problem #23 in the SQL Chapter of Ace the Data Science Interview!
--Assume you have the table below containing information on Facebook user actions. Write a query to obtain the active user retention in July 2022. Output the month (in numerical format 1, 2, 3) and the number of monthly active users (MAUs).
--Hint: An active user is a user who has user action ("sign-in", "like", or "comment") in the current month and last month
--From <https://datalemur.com/questions/user-retention> 

WITH active_users_last_month AS (
  SELECT DISTINCT user_id
  FROM user_actions
  WHERE DATE_TRUNC('month', "event_date") = DATE_TRUNC('month', date '2022-06-01')
    AND event_type IN ('sign-in', 'like', 'comment')
),
active_users_current_month AS (
  SELECT DISTINCT user_id
  FROM user_actions
  WHERE DATE_TRUNC('month', "event_date") = DATE_TRUNC('month', date '2022-07-01')
    AND event_type IN ('sign-in', 'like', 'comment')
)
SELECT 7 AS month, COUNT(DISTINCT aucm.user_id) AS monthly_active_users
FROM active_users_current_month aucm
JOIN active_users_last_month aulm ON aucm.user_id = aulm.user_id;
--__________________________________________________________________________________________________________________________________________________________________________

--Question8




