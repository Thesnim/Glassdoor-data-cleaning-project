
/* 1. Remove Ratings from Company Name */
SELECT 
    [Company Name],
    CASE 
        WHEN CHARINDEX('.', REVERSE([Company Name])) = 0 
            THEN [Company Name]
        ELSE LEFT([Company Name], LEN([Company Name]) - CHARINDEX('.', REVERSE([Company Name])) - 1)
    END AS CleanedCompanyName
FROM [portfolio project]..Uncleaned_DS_jobs;

UPDATE [portfolio project]..Uncleaned_DS_jobs
SET CleanedCompanyName = 
    CASE 
        WHEN CHARINDEX('.', REVERSE([Company Name])) = 0 
            THEN [Company Name]
        ELSE LEFT([Company Name], LEN([Company Name]) - CHARINDEX('.', REVERSE([Company Name])) - 1)
    END;

/* 2. Remove Duplicates */
WITH ROWNUMCTE AS(
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY [Job Title], [Salary Estimate], [Company Name], [Location]
               ORDER BY [index]) row_num
    FROM [portfolio project]..Uncleaned_DS_jobs
)
DELETE FROM ROWNUMCTE
WHERE row_num > 1;

/* 3. Find Null Values */
SELECT COUNT(*) AS MissingSalaryEstimate
FROM [portfolio project]..Uncleaned_DS_jobs
WHERE [Salary Estimate] IS NULL;

SELECT COUNT(*) AS MissingIndustry
FROM [portfolio project]..Uncleaned_DS_jobs
WHERE [Industry] IS NULL;

SELECT COUNT(*) AS MissingOwnership
FROM [portfolio project]..Uncleaned_DS_jobs
WHERE [Type of ownership] IS NULL;

/* 4. Clean Unknown Values */
UPDATE [portfolio project]..Uncleaned_DS_jobs
SET Revenue = NULLIF(Revenue, 'Unknown / Non-Applicable');

UPDATE [portfolio project]..Uncleaned_DS_jobs
SET Competitors = NULLIF(Competitors, '-1');

UPDATE [portfolio project]..Uncleaned_DS_jobs
SET Founded = NULLIF(Founded, '-1');

UPDATE [portfolio project]..Uncleaned_DS_jobs
SET Industry = NULLIF(Industry, '-1');

UPDATE [portfolio project]..Uncleaned_DS_jobs
SET Sector = NULLIF(Sector, '-1');

UPDATE [portfolio project]..Uncleaned_DS_jobs
SET Headquarters = NULLIF(Headquarters, '-1');

/* 5. Salary Cleaning */
SELECT [Salary Estimate],
       REPLACE(
           LEFT(REPLACE([Salary Estimate], '$', ''), PATINDEX('%[^0-9k-]%', REPLACE([Salary Estimate], '$', '') + ' ') - 1),  
           'k', '000'
       ) AS formatted_salary_range
FROM [portfolio project]..Uncleaned_DS_jobs;

ALTER TABLE [portfolio project]..Uncleaned_DS_jobs
ADD formatted_salary_range NVARCHAR(100);

UPDATE [portfolio project]..Uncleaned_DS_jobs
SET formatted_salary_range = REPLACE(
    LEFT(REPLACE([Salary Estimate], '$', ''), PATINDEX('%[^0-9k-]%', REPLACE([Salary Estimate], '$', '') + ' ') - 1),  
    'k', '000'
);

/* 6. Populate Location into City, State */
ALTER TABLE [portfolio project]..Uncleaned_DS_jobs
ADD Location_City NVARCHAR(100), Location_State NVARCHAR(100);

UPDATE [portfolio project]..Uncleaned_DS_jobs
SET 
    Location_City = CASE 
        WHEN CHARINDEX(',', Location) > 0 
        THEN LEFT(Location, CHARINDEX(',', Location) - 1) 
        ELSE Location 
    END,
    Location_State = CASE 
        WHEN CHARINDEX(',', Location) > 0 
        THEN RIGHT(Location, LEN(Location) - CHARINDEX(',', Location)) 
        ELSE NULL 
    END;

/* 7. Extract Min/Max Salary */
ALTER TABLE [portfolio project]..Uncleaned_DS_jobs
ADD Min_Salary INT, Max_Salary INT;

UPDATE [portfolio project]..Uncleaned_DS_jobs
SET 
    Min_Salary = TRY_CAST(LEFT(formatted_salary_range, CHARINDEX('-', formatted_salary_range) - 1) AS INT),
    Max_Salary = TRY_CAST(RIGHT(formatted_salary_range, LEN(formatted_salary_range) - CHARINDEX('-', formatted_salary_range)) AS INT)
WHERE CHARINDEX('-', formatted_salary_range) > 0;

/* 8. Drop unnecessary columns */
ALTER TABLE [portfolio project]..Uncleaned_DS_jobs
DROP COLUMN [Salary Estimate], [Company Name], [Location];

/* 9. Count by Industry */
SELECT Industry, COUNT(*) AS Count
FROM [portfolio project]..Uncleaned_DS_jobs
GROUP BY Industry
ORDER BY Count DESC;



