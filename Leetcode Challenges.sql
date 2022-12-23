
--Question 1
--Write an SQL query to report the latest login for all users in the year 2020. Do not include the users who did not login in 2020.

SELECT  user_id , max(time_stamp) AS Last_stamp
FROM Logins
WHERE time_stamp LIKE '%2020%'
GROUP BY 1;

OR 

SELECT DISTINCT user_id, MAX(time_stamp) last_stamp
FROM Logins
WHERE YEAR(time_stamp) = '2020'
GROUP BY user_id;

--__________________________________________________________________________________________________________________________________________________________________________

--Question2
--Write an SQL query that will, for each user, return the number of followers.
--Return the result table ordered by user_id in asc.

SELECT user_id , count(follower_id) AS Followers_countFROM FollowersGROUP BY user_id   ORDER BY user_id ASC;
--_____________________________________________________________________________________________________________________________________________________________________

--Question3
--Write an SQL query to fix the names so that only the first character is uppercase and the rest are lowercase.

SELECT user_id,
    CONCAT(UPPER(SUBSTRING(name, 1, 1)), LOWER(SUBSTRING(name, 2, length(name)))) AS name
FROM users;

