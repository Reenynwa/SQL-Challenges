--Question 1
--Classify each business as either a restaurant, cafe, school, or other. 
--A restaurant should have the word 'restaurant' in the business name. For cafes, either 'cafe', 'café', or 'coffee' can be in the business name. 
--'School' should be in the business name for schools. All other businesses should be classified as 'other'. Output the business name and the calculated classification.

SELECT  business_name,
CASE    WHEN  (business_name) iLIKE any(array['%restaurant%'])THEN 'restaurant'
        WHEN  (business_name) iLIKE any(array['%cafe%', '%café%', '%coffee%']) THEN  'cafe'
        WHEN  (business_name) iLIKE any(array[ '%school%']) THEN 'school' 
        ELSE 'Other'
        END AS business_type
FROM sf_restaurant_health_violations;

--___________________________________________________________________________________________________________________________________________________________________________

--Question 2
--Count the number of movies that Abigail Breslin was nominated for an oscar.

SELECT
    COUNT(id) AS Abigail_movies
FROM oscar_nominees
WHERE nominee = 'Abigail Breslin' ;

--___________________________________________________________________________________________________________________________________________________________________________

--Question 3
--Find the date with the highest total energy consumption from the Meta/Facebook data centers. 
--Output the date along with the total energy consumption across all data centers.


WITH cte_energy AS
(
SELECT SUM(consumption) AS total_energy , date 
FROM
(
SELECT date,
consumption
FROM fb_eu_energy

UNION

SELECT
date,
consumption
FROM fb_asia_energy

UNION

SELECT
date,
consumption
FROM fb_na_energy
) AS energy
GROUP BY date
ORDER BY total_energy DESC
)

SELECT MAX(total_energy) AS max_total_energy, date
FROM cte_energy
GROUP BY date
ORDER BY max_total_energy DESC
LIMIT 2;
 
 --___________________________________________________________________________________________________________________________________________________________________________

--Question 4
--Find the average total compensation based on employee titles and gender. Total compensation is calculated by adding both the salary and bonus of each employee. However, not every employee receives a bonus so disregard employees without bonuses in your calculation. Employee can receive more than one bonus. Output the employee title, gender (i.e., sex), along with the average total compensation.


SELECT
 AVG(b.total_bonus+ salary ) AS Avg_compensation,
 e.employee_title,e.Sex 
FROM sf_employee e 
INNER JOIN 
(
SELECT worker_ref_id,sum(bonus) AS total_bonus
FROM sf_bonus 
GROUP BY worker_ref_id
HAVING sum(bonus) > 0
) b
ON e.id = b.worker_ref_id
GROUP BY e.employee_title , e.sex ;


--___________________________________________________________________________________________________________________________________________________________________________


--Question5
--Meta/Facebook has developed a new programing language called Hack.To measure the popularity of Hack they ran a survey with their employees. The survey included data on previous programing familiarity as well as the number of years of experience, age, gender and most importantly satisfaction with Hack. Due to an error location data was not collected, but your supervisor demands a report showing average popularity of Hack by office location. Luckily the user IDs of employees completing the surveys were stored. Based on the above, find the average popularity of the Hack per office location. Output the location along with the average popularity.


SELECT location,
   AVG(h.popularity)
FROM facebook_employees e
LEFT JOIN facebook_hack_survey h
ON e.id = h.employee_id
GROUP BY location


--___________________________________________________________________________________________________________________________________________________________________________


--Question 6
--Find the review_text that received the highest number of 'cool' votes. Output the business name along with the review text with the highest number of 'cool' votes.


 SELECT business_name,
review_text
FROM yelp_reviews
WHERE cool in (SELECT MAX(cool) from yelp_reviews)
GROUP BY business_name , review_text;

--___________________________________________________________________________________________________________________________________________________________________________

--Question7
--Find the top 5 businesses with most reviews. Assume that each row has a unique business_id such that the total reviews for each business is listed on each row.
--Output the business name along with the total number of reviews and order your results by the total reviews in descending order.


SELECT name,
SUM (review_count) AS Total_reviews
FROM yelp_business
GROUP BY name
ORDER BY  Total_reviews DESC
LIMIT 5;

