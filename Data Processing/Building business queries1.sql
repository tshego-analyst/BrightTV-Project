-- Databricks notebook source
--Tables overview
SELECT * FROM dbo.viewership LIMIT 100;
SELECT * FROM dbo.userprofile LIMIT 100;

--Get minimum date
SELECT MIN(RecordDate) AS start_date
FROM dbo.viewership;

--Get Maximum date
SELECT MAX(RecordDate) AS End_Date
FROM dbo.viewership;

--Get min and max viewership 
SELECT MIN(Duration)
FROM dbo.viewership;

SELECT MAX(Duration)
FROM dbo.viewership;

--Get hours, minites, seconds

SELECT HOUR(Duration)
FROM dbo.viewership
WHERE HOUR(Duration);

SELECT MINUTE(Duration) 
FROM dbo.viewership;

SELECT SECOND(DURATION), duration
FROM dbo.viewership;

--South Africs is 2 hours ahead of UTC, so I am adding 2 HOURS to the Date
SELECT DATEADD(hour, 2, RecordDate) AS View_Date, RecordDate
FROM dbo.viewership
WHERE HOUR(RecordDate) = 23;-- checking if its working and changes the day

--checking if I can specify hour as 3 and not 03
SELECT  HOUR(RecordDate), RecordDate
FROM dbo.viewership
WHERE HOUR(RecordDate) = 3; -- checking if its working and changes the day

--chcking for null ages
SELECT age 
FROM dbo.userprofile
WHERE age IS NULL;

--=====================================MINI BUSINESS QUERES=========================================================

--Which age group watches BrightTV the most?
SELECT 
COUNT(v.userID) AS Total_Number_Of_Viewers,
CASE --My age rage is between 13 and 90
WHEN u.Age IS NULL THEN 'Invalid Age'
WHEN u.Age BETWEEN 13 AND 19 THEN 'Teenagers'
WHEN u.Age BETWEEN 20 AND 35 THEN 'Young Adults'
WHEN u.Age BETWEEN 36 AND 64 THEN 'Middle Aged'
ELSE 'Senior Citizen'
END AS Age_Group
FROM dbo.viewership AS v
LEFT JOIN dbo.userprofile AS u
ON u.UserID=v.UserID
GROUP BY 
CASE --My age rage is between 13 and 90
WHEN u.Age IS NULL THEN 'Invalid Age'
WHEN u.Age BETWEEN 13 AND 19 THEN 'Teenagers'
WHEN u.Age BETWEEN 20 AND 35 THEN 'Young Adults'
WHEN u.Age BETWEEN 36 AND 64 THEN 'Middle Aged'
ELSE 'Senior Citizen'
END 
ORDER BY Total_Number_Of_Viewers DESC;

/*
Finidngs: Teenagers
--> Low registration rates
--> Possibly using parents accounts
---> Underrepresented in data but may actually watch more than data shows

Senior citizens:
-->Low tech adoption
-->Less likely to have social media or email accounts
-->May watch TV but through traditional means not tracked here

*/


--Which Gender Watches BrightTV the most

SELECT
IFNULL(u.gender, 'Empty') AS Gender,
COUNT(v.UserID) AS Total_Number_Of_Views
FROM dbo.viewership AS v
LEFT JOIN dbo.userprofile AS u
ON u.UserID=v.UserID
GROUP BY u.Gender
ORDER BY Total_Number_Of_Views DESC;

--checking how many viewers have null geders
SELECT COUNT(*) AS users_with_null_gender -- COUNT(UserID) would also work 
FROM dbo.viewership AS v
LEFT JOIN dbo.userprofile AS u
ON u.UserID = v.UserID
WHERE u.Gender IS NULL;

 



--=====================================SKELETON QUERY=========================================================

SELECT 
--WHO
u.Race, 
u.Gender,
CASE --My age rage is between 13 and 90
WHEN u.Age IS NULL THEN 'Invalid Age'
WHEN u.Age BETWEEN 13 AND 19 THEN 'Teenagers'
WHEN u.Age BETWEEN 20 AND 35 THEN 'Young Adults'
WHEN u.Age BETWEEN 36 AND 64 THEN 'Middle Aged'
ELSE 'Senior Citizen'
END AS Age_Group,

--WHAT
v.Channel,

--WHEN
 DATEADD(hour, 2, v.RecordDate) AS View_Date, 
 MONTHNAME(DATEADD(hour, 2, v.RecordDate)) AS MonthName,
 DAYNAME(DATEADD(hour, 2, v.RecordDate)) AS Day_Of_Week,
 CASE 
 WHEN HOUR(DATEADD(hour, 2, v.RecordDate)) BETWEEN  0 AND 5 THEN 'Midnight_To_EarlyMorning'
 WHEN HOUR(DATEADD(hour, 2, v.RecordDate)) BETWEEN  6 AND 11 THEN 'Morning'
 WHEN HOUR(DATEADD(hour, 2, v.RecordDate)) BETWEEN  12 AND 15 THEN 'During_The_Day'
 WHEN HOUR(DATEADD(hour, 2, v.RecordDate)) BETWEEN  16 AND 18 THEN 'Afternoon'
 ELSE 'Evening/Night'
 END AS Daily_Hours,

--HOW LONG
v.Duration,

CASE 
WHEN (SECOND(v.Duration) BETWEEN 0 AND 2) AND (HOUR(v.Duration) =0 AND MINUTE(v.Duration)=0) THEN 'Clicked and Left' -- 0 secnonds to 2 seconds
WHEN SECOND(v.Duration) BETWEEN 3 AND 60 AND (HOUR(v.Duration) =0 AND MINUTE(v.Duration)=0) THEN 'Clicked and Not Commited'--3 secnds to 1 minute
WHEN MINUTE(v.Duration) >= 1 AND HOUR(v.Duration) = 0 THEN 'Casual Commitment'
WHEN HOUR(v.Duration) BETWEEN 1 AND 4 THEN 'Valid Commitment'
ELSE 'Solid Commitment'
END AS Viewership_Engagement,


--WHERE
u.Province

FROM dbo.viewership AS v
LEFT JOIN dbo.userprofile AS u
ON v.UserID=u.UserID;





