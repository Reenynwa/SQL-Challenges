
					
--Question1
--Given a users table, write a query to return only its duplicate rows.


SELECT id, name, created at 
FROM users
GROUP BY 1,2,3
HAVING COUNT(*) >1
--____________________________________________________________________________________________________________________________________________________________________________

--Question 2
--Let’s say you work at an advertising firm. You have a table of users’ impressions of ad campaigns over time. 
--Each impression_id consists of values of user engagement specified by Excited and Bored.
--Write a query to find all users that are currently “Excited” and have never been “Bored” with a campaign.


SELECT DISTINCT user_id
 FROM ad_impressions
 WHERE impression_id = 'Excited' 
AND  
 user_id NOT IN (SELECT user_id FROM ad_impressions 
 WHERE impression_id = 'Bored') 

OR

WITH CTE1 AS (
SELECT DISTINCT user_id AS users
FROM ad_impressions
WHERE impression_id = 'Bored'
),
CTE2 AS (
SELECT DISTINCT user_id AS users
FROM ad_impressions
WHERE impression_id = 'Excited' 
)
SELECT CTE2.users as user_id
FROM CTE2
LEFT JOIN CTE1 ON CTE2.users = CTE1.users 
WHERE CTE1.users IS NULL;

--____________________________________________________________________________________________________________________________________________________________________________



--Question3
--Let’s say that we work for a B2B SaaS company that has been around for three years.
--The company has two revenue lines (product_type): the first is labeled as "service" and is a consulting type model where clients are serviced on an hourly rate for a one-off project. The second revenue line is "software", which clients can purchase on an ongoing subscription basis.
--Given a table of payments data, write a query to calculate the average revenue per client.
--Note: Round the result to two decimals.


SELECT ROUND(SUM(amount_per_unit * quantity)
/
COUNT(DISTINCT user_id),2) average_lifetime_revenue
FROM payments;


 