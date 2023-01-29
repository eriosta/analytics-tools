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

