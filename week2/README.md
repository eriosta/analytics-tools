# Week 2
## Filtering, Sorting, and Calculating Data with SQL
### Salary by Job Range Table
For all the questions in this practice set, you will be using the *Salary by Job Range Table*. This is a single table titled: `salary_range_by_job_classification`. This table contains the following columns:
* `SetID`
* `Job_Code`
* `Eff_Date`
* `Sal_End_Date`
* `Salary_setID`
* `Sal_Plan`
* `Grade`
* `Step`
* `Biweekly_High_Rate`
* `Biweekly_Low_Rate`
* `Union_Code`
* `Extended_Step`
* `Pay_Type`

### Tasks

Find the distinct values for `Extended_Step`. The code has been started for you, but you will need to program the third line yourself before running the query. 

```sql
SELECT DISTINCT Extended_Step 
FROM salary_range_by_job_classification
-- 0
-- 6
-- 11
-- 2
```

Excluding $0.00, what is the minimum `Biweekly_High_Rate` of pay? Please include the dollar sign and decimal point in your answer.

```sql
SELECT Biweekly_High_Rate
FROM salary_range_by_job_classification
ORDER BY Biweekly_High_Rate ASC
--- $0.00 
--- ...
--- $1,073.00
```

What is the maximum biweekly high rate of pay (please include the dollar sign and decimal point in your answer)?

```sql
FROM salary_range_by_job_classification
ORDER BY Biweekly_High_Rate DESC
--- $9,726.38
```

What is the pay type for all `Job_Code` that start with '03'? (Note: Nothing with "03")
```sql
SELECT Job_Code, Pay_Type
FROM salary_range_by_job_classification
WHERE Job_Code LIKE '3%'
--- All B except for 3210 == H
```

Run a query to find the `Eff_Date` or `Sal_End_Date` for `Grade` == Q90H0.
``` sql
SELECT Eff_Date, Sal_End_Date, "Grade " as grade --- There is a space after the column name
FROM salary_range_by_job_classification
WHERE grade=='Q90H0'
-- Eff_Date	 Sal_End_Date	                        grade
-- 12/26/2009   12:00:00 AM	06/30/2010 12:00:00 AM	Q90H0
```

Sort the `Biweekly_Low_Rate` in ascending order. Hint: there are 4 lines to run this query. Are these values properly sorted?
```sql
SELECT Biweekly_Low_Rate
FROM salary_range_by_job_classification
ORDER BY Biweekly_Low_Rate ASC
-- No
```

Write and run a query: What `Step` are `Job_Code` 0110-0400 (*through*?)? Hint: there are 6 lines to run this query.
```sql
SELECT Step, 
        REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Job_Code,'Q',''), 'H',''), 'P',''), 'AC',''),'AB',''), ' ','') AS Clean_Job_Code
FROM salary_range_by_job_classification
WHERE Job_Code BETWEEN 110 AND 400
-- Need to convert TEXT to INT/FLOAT
```

Write and run a query: What is the`Biweekly_High_Rate` minus the `Biweekly_Low_Rate` for `Job_Code` 0170?
```sql
SELECT Job_Code, Biweekly_High_Rate, Biweekly_Low_Rate, (Biweekly_High_Rate - Biweekly_Low_Rate)
FROM salary_range_by_job_classification
WHERE Job_Code == 0170
--- 0
--- This happens to be right but  the substraction did not occur normally because both data types are TEXT and not NUMERIC
```

Write and run a query: What is the `Extended_Step` for `Pay_Type` == M, H, and D?
```sql
SELECT Extended_Step, Pay_Type
FROM salary_range_by_job_classification
WHERE Pay_Type IN ('M','H','D')
-- Extended_Step    Pay_Type
-- 0	            D
-- 0	            D
-- 0	            D
-- 0	            M
-- 0	            D
-- 0	            D
-- 0	            M
-- 0	            H
-- 0	            H
-- 0	            H
-- 0	            H
-- 0	            H
-- 0	            H
-- 0	            H
-- 0	            H
```

Write and run a query: What is the `Step` for `Union_Code` 990 and `SetID` of SFMTA or COMMN?
```sql
SELECT Step,Union_Code,SetID
FROM salary_range_by_job_classification
WHERE Union_Code==990 AND (SetID=='SFMTA' OR SetID=='COMMN')
--- Step    Union_Code	SetID
--- 1	    990     	COMMN
```
