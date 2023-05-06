WITH 
customer_data AS (
    SELECT 
        CustomerID,
        PersonID,
        TerritoryID
    FROM Customer
),

person_data AS (
    SELECT
        BusinessEntityID AS PersonID,
        TotalPurchaseYTD,
        DateFirstPurchase,
        MaritalStatus,
        YearlyIncome,
        Gender,
        TotalChildren,
        NumberChildrenAtHome,
        Education,
        Occupation,
        HomeOwnerFlag,
        NumberCarsOwned,
        CommuteDistance,
        CAST((julianday('2007-10-31') - julianday(SUBSTR(BirthDate, 7, 4) || '-' || SUBSTR(BirthDate, 1, 2) || '-' || SUBSTR(BirthDate, 4, 2))) / 365.25 AS INTEGER) AS Age
    FROM Person
),

bicycle_customers AS (
    SELECT DISTINCT
        soh.CustomerID
    FROM SalesOrderHeader soh
    JOIN SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Product p ON sod.ProductID = p.ProductID
    WHERE p.ProductSubcategoryID IN (1, 2, 3)
),

combined_data AS (
    SELECT
        c.CustomerID,
        c.TerritoryID,
        p.TotalPurchaseYTD,
        p.DateFirstPurchase,
        p.MaritalStatus,
        p.YearlyIncome,
        p.Gender,
        p.TotalChildren,
        p.NumberChildrenAtHome,
        p.Education,
        p.Occupation,
        p.HomeOwnerFlag,
        p.NumberCarsOwned,
        p.CommuteDistance,
        p.Age,
        CASE
            WHEN bc.CustomerID IS NOT NULL THEN 1
            ELSE 0
        END AS BicyclePurchaseFlag
    FROM customer_data c
    JOIN person_data p ON c.PersonID = p.PersonID
    LEFT JOIN bicycle_customers bc ON c.CustomerID = bc.CustomerID
)

SELECT * FROM combined_data;
