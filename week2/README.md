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

1. Find the distinct values for `Extended_Step`. The code has been started for you, but you will need to program the third line yourself before running the query. 

```sql
SELECT DISTINCT Extended_Step 
FROM salary_range_by_job_classification
-- 0
-- 6
-- 11
-- 2
```

2. Excluding $0.00, what is the minimum bi-weekly high rate of pay? Please include the dollar sign and decimal point in your answer.

```sql
SELECT Biweekly_High_Rate
FROM salary_range_by_job_classification
ORDER BY Biweekly_High_Rate ASC
--- $0.00 
--- ...
--- $1,073.00
```

3. What is the maximum biweekly high rate of pay (please include the dollar sign and decimal point in your answer)?

4. What is the pay type for all the job codes that start with '03'?

5. Run a query to find the Effective Date (eff_date) or Salary End Date (sal_end_date) for grade Q90H0? What is the Salary End Date (sal_end_date) for grade Q90H0?

6. Sort the Biweekly low rate in ascending order. Hint: there are 4 lines to run this query. Are these values properly sorted?

7. Write and run a query: What Step are Job Codes 0110-0400? Hint: there are 6 lines to run this query.

8. Write and run a query: What is the Biweekly High Rate minus the Biweekly Low Rate for job Code 0170?

9.  Write and run a query: What is the Extended Step for Pay Types M, H, and D?

10.  Write and run a query: What is the step for Union Code 990 and a Set ID of SFMTA or COMMN?