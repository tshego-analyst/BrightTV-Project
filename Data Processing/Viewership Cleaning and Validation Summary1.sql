-- Databricks notebook source
SELECT * FROM dbo.viewership LIMIT 100;

--Check Columns and Data types
DESCRIBE dbo.viewership;


--=============================================Cleaning the data==============================

/*

Mismatched UserIDs — find and delete those 485 rows
Break in transmission — intresting tell because this can tell us a pattern
Zero duration — this tells us impression vs actual views

*/

/* Since the userid4 is now dropped, the code is now hvaing an error, 
so I am commenting this blocke code  out

--See how many rows have a mismatch
SELECT UserID, userid4
FROM dbo.viewership
WHERE UserID <> userid4;

SELECT COUNT(*)
FROM dbo.viewership
WHERE UserID <> userid4;

/*Im deleting the rows because either for the two rows might be 
so it is important to maintain data integrity and ensure that we 
report of relibale data*/

DELETE 
FROM dbo.viewership
WHERE UserID <> userid4;

--confirm if the mismatching rows are deleted
SELECT COUNT(*)
FROM dbo.viewership
WHERE UserID == userid4;


---Now I can drop can drop either UserID or userid4 since they are duplicates

ALTER TABLE dbo.viewership 
SET TBLPROPERTIES ('delta.columnMapping.mode' = 'name');

ALTER TABLE dbo.viewership
DROP COLUMN userid4;

*/


--Check now many channels we have(21)
SELECT DISTINCT Channel
FROM dbo.viewership;

--check how many viewers wach channel has
SELECT COUNT(userID), Channel
FROM dbo.viewership
GROUP BY Channel;

--Standarise the two idenfied channels Supersport Live Events and sawsee

--SuperSport Live Events had 20 and Supersport Live Events had 1539
UPDATE dbo.viewership
SET Channel= 'SuperSport Live Events'
WHERE Channel= 'Supersport Live Events';

--sawsee had 4 and SawSee had 241
UPDATE dbo.viewership
SET Channel= 'SawSee'
WHERE Channel= 'Sawsee';
