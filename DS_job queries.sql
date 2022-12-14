-- Let's check the data set
SELECT *
FROM ds_job
LIMIT 10;

--Removing the (glassdoor) from Salary_Estimate
SELECT Salary_Estimate, 
       SUBSTRING_INDEX(Salary_Estimate,' ', 1) salary_estimate
FROM ds_job;

-- Updating the table with new salary estimate
UPDATE ds_job
SET Salary_Estimate = SUBSTRING_INDEX(Salary_Estimate,' ', 1);

SELECT *
FROM ds_job;

-- Removing rating from the `Company_Name`
SELECT `Company_Name`,
       SUBSTRING_INDEX(`Company_Name`, '
', 1) company_name       
FROM ds_job;

-- Counting charactor length  and comparing with the the Comapny_name column 
WITH subtring AS (SELECT `Company_Name`,
       SUBSTRING_INDEX(`Company_Name`, '
', 1) company       
FROM ds_job)
SELECT D.`Company_Name`,
       LENGTH(D.`Company_Name`) total_D_length,
       S.company, 
       LENGTH(S.company) total_length
FROM ds_job D
JOIN subtring S
ON D.`Company_Name` = S.`Company_Name`;

-- Updating the column Company_Name
UPDATE ds_job 
SET `Company_Name` = SUBSTRING_INDEX(`Company_Name`, '
', 1);

SELECT *
FROM ds_job;

-- Removing the 'Company' in `Type_of_ownership`
SELECT `Type_of_ownership`,
       SUBSTRING_INDEX(`Type_of_ownership`, '- ', -1) ownership
FROM ds_job;

UPDATE ds_job
SET `Type_of_ownership` = SUBSTRING_INDEX(`Type_of_ownership`, '- ', -1);

-- See the new table
SELECT *
FROM ds_job;

-- Counting '-1' in each column these columns
SELECT (SELECT COUNT(Rating) FROM ds_job WHERE Rating = -1)  rating, 
       (SELECT COUNT(`Headquarters`) FROM ds_job WHERE `Headquarters`= -1) headquarters, 
       (SELECT COUNT(Size) FROM ds_job WHERE `Size` = -1) size,
       (SELECT COUNT(Type_of_ownership) FROM ds_job WHERE Type_of_ownership = -1) type_of_ownership,
       (SELECT COUNT(Industry) FROM ds_job WHERE Industry = -1) industry,
       (SELECT COUNT(Sector) FROM ds_job WHERE Sector = -1) sector,
       (SELECT COUNT(Revenue) FROM ds_job WHERE Revenue = -1) revenue
FROM ds_job
LIMIT 1;

-- Now, removing the '-1' values with 'Unknown' and 'Unknown / Non-Applicable' with Unknown in Revenue column
UPDATE ds_job
SET `Rating` = REPLACE(Rating, '-1', '0')
WHERE `Rating` = -1;
UPDATE ds_job
SET `Headquarters` = REPLACE(`Headquarters`, '-1', 'Unknown')
WHERE `Headquarters` = '-1';
UPDATE ds_job
SET `Size` = REPLACE(`Size`, '-1', 'Unknown')
WHERE `Size` = '-1';
UPDATE ds_job
SET `Type_of_ownership` = REPLACE(`Type_of_ownership`, '-1', 'Unknown')
WHERE `Type_of_ownership` = '-1';
UPDATE ds_job
SET `Industry` = REPLACE(`Industry`, '-1', 'Unknown')
WHERE `Industry` = '-1';
UPDATE ds_job
SET `Sector` = REPLACE(`Sector`, '-1', 'Unknown')
WHERE `Sector` = '-1';
UPDATE ds_job
SET `Revenue` = REPLACE(`Revenue`, '-1', 'Unknown')
WHERE `Revenue` = '-1';
UPDATE ds_job
SET Revenue = REPLACE(`Revenue`, 'Unknown / Non-Applicable', 'Uknown')
WHERE `Revenue` = 'Unknown / Non-Applicable';

-- There was a spelling mistake while changing the Revenue column value 'Unknown / Non-Applicable' to 'Unkown'
-- Now, we're going to change 'Uknown' to 'Unknown'  
SET Revenue = REPLACE(`Revenue`, 'Uknown', 'Unknown')
WHERE `Revenue` = 'Uknown';

-- Deleting unuse columns Index_, Founded and Competitors
ALTER TABLE ds_job
DROP COLUMN index_,
DROP COLUMN Founded,
DROP COLUMN Competitors;

--let's look at the cleaned dataset
SELECT *
FROM ds_job
LIMIT 10;

-- let's analyise it a little bit about job description
WITH skill AS (SELECT `Job_Description`,
       CASE
       WHEN `Job_Description` LIKE "%Python%"
       THEN '1' 
       ELSE '0'
       END AS Python,
       CASE
       WHEN `Job_Description` LIKE "%Excel%"
       THEN '1' 
       ELSE '0'
       END AS Excel,
       CASE
       WHEN `Job_Description` LIKE "%AWS%"
       THEN '1' 
       ELSE '0'
       END AS AWS,
       CASE
       WHEN `Job_Description` LIKE "%SQL%"
       THEN '1' 
       ELSE '0'
       END AS 'SQL'
FROM ds_job)
SELECT *
FROM ds_job d
JOIN skill s
ON d.`Job_Description` = s.`Job_Description`;
