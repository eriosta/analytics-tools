-- SQLite
-- Selecting and retrieving data with SQL

PRAGMA table_info(salary_range_by_job_classification)

SELECT DISTINCT Extended_Step 
FROM salary_range_by_job_classification
-- 0
-- 6
-- 11
-- 2

SELECT Biweekly_High_Rate
FROM salary_range_by_job_classification
ORDER BY Biweekly_High_Rate ASC

SELECT Biweekly_High_Rate
FROM salary_range_by_job_classification
ORDER BY Biweekly_High_Rate DESC

SELECT Job_Code, Pay_Type
FROM salary_range_by_job_classification
WHERE Job_Code LIKE '3%'

SELECT Eff_Date, Sal_End_Date, "Grade " as grade --- There is a space after the column name
FROM salary_range_by_job_classification
WHERE grade=='Q90H0'

SELECT Biweekly_Low_Rate
FROM salary_range_by_job_classification
ORDER BY Biweekly_Low_Rate ASC
-- No

SELECT Step, Job_Code
FROM salary_range_by_job_classification
WHERE Job_Code BETWEEN 0110 and 0400

-- `Step` are `Job_Code` 0110 through 0400

SELECT Step, 
        REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Job_Code,'Q',''), 'H',''), 'P',''), 'AC',''),'AB',''), ' ','') AS Clean_Job_Code
FROM salary_range_by_job_classification
WHERE Job_Code BETWEEN 110 AND 400
-- Need to convert TEXT to INT/FLOAT

SELECT Job_Code, Biweekly_High_Rate, Biweekly_Low_Rate, (Biweekly_High_Rate - Biweekly_Low_Rate)
FROM salary_range_by_job_classification
WHERE Job_Code == 0170
--- This happens to be right but  the substraction did not occur normally because both data types are TEXT and not NUMERIC

SELECT Extended_Step, Pay_Type
FROM salary_range_by_job_classification
WHERE Pay_Type IN ('M','H','D')