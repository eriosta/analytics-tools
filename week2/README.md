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

Excluding $0.00, what is the minimum bi-weekly high rate of pay? Please include the dollar sign and decimal point in your answer.

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
-- Eff_Date	    Sal_End_Date	                    grade
-- 12/26/2009   12:00:00 AM	06/30/2010 12:00:00 AM	Q90H0
```

Sort the Biweekly low rate in ascending order. Hint: there are 4 lines to run this query. Are these values properly sorted?

Write and run a query: What Step are Job Codes 0110-0400? Hint: there are 6 lines to run this query.

Write and run a query: What is the Biweekly High Rate minus the Biweekly Low Rate for job Code 0170?

Write and run a query: What is the Extended Step for Pay Types M, H, and D?

Write and run a query: What is the step for Union Code 990 and a Set ID of SFMTA or COMMN?