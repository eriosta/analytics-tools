SELECT ART.NAME, ALB.TITLE
    FROM albums ALB
        LEFT JOIN artists ART
            ON ART.ArtistId = ALB.ArtistId
    WHERE ART.NAME = "Led Zeppelin"

SELECT ART.Name, ALB.Title
    FROM albums ALB
        LEFT JOIN artists ART
            ON ART.ArtistId = ALB.ArtistId
    WHERE ART.NAME = "Led Zeppelin"

-- Create a list of album titles and the unit prices for the artist
--  `Audioslave`. How many records are returned?
SELECT ART.Name, ALB.Title, TRK.Name, TRK.UnitPrice
FROM albums ALB
LEFT JOIN artists ART ON ART.ArtistId = ALB.ArtistId
LEFT JOIN tracks TRK ON TRK.AlbumId = ALB.AlbumId 
WHERE ART.Name = "Audioslave"

-- Find the first and last name of any customer who does not
--  have an invoice. Are there any customers returned from the query?
SELECT c.FirstName, c.LastName
FROM customers c
WHERE c.CustomerId NOT IN (SELECT i.CustomerId FROM invoices i);

-- Find the total price for each album. What is the total price 
-- for the album `Big Ones`?
SELECT albums.Title, SUM(invoice_items.UnitPrice * invoice_items.Quantity) AS Total_Price
FROM albums
JOIN tracks ON albums.AlbumId = tracks.AlbumId
JOIN invoice_items ON tracks.TrackId = invoice_items.TrackId
GROUP BY albums.Title
HAVING albums.Title = 'Big Ones'
-- The total price for the album "Big Ones" is $9.9


SELECT *
FROM invoices
JOIN invoice_items
ON 1=1;

SELECT COUNT(*)
FROM (
SELECT *
FROM invoices
JOIN invoice_items
ON 1=1
) as result;

SELECT Name
FROM tracks
WHERE AlbumId = (
  SELECT AlbumId
  FROM albums
  WHERE Title = 'Californication'
);

SELECT Name
FROM (
  SELECT Name,
         ROW_NUMBER() OVER (ORDER BY TrackId) AS RowNumber
  FROM tracks
  WHERE AlbumId = (
    SELECT AlbumId
    FROM albums
    WHERE Title = 'Californication'
  )
)
WHERE RowNumber = 8;

---12
SELECT
    Customer.FirstName || ' ' || Customer.LastName AS "Full Name",
    Customer.Email,
    COUNT(Invoice.InvoiceId) AS "Total Invoices",
    Customer.City
FROM customers Customer
INNER JOIN invoices Invoice ON Customer.CustomerId = Invoice.CustomerId
GROUP BY Customer.CustomerId
HAVING "Full Name" = 'František Wichterlová'

---13 
SELECT tracks.Name AS track_name, albums.Title AS album_title, albums.ArtistId, tracks.TrackId 
FROM tracks 
JOIN albums ON tracks.AlbumId = albums.AlbumId;

SELECT tracks.Name AS track_name 
FROM tracks 
JOIN albums ON tracks.AlbumId = albums.AlbumId 
WHERE tracks.TrackId = 12 AND albums.Title = 'For Those About To Rock We Salute You';

---14
SELECT e1.LastName AS manager_last_name, e2.LastName AS employee_last_name
FROM employees e1
JOIN employees e2 ON e1.EmployeeId = e2.ReportsTo;

---15
SELECT artists.Name, artists.ArtistId
FROM artists
LEFT JOIN albums ON artists.ArtistId = albums.ArtistId
WHERE albums.ArtistId IS NULL;

---16
SELECT FirstName, LastName
FROM employees
UNION
SELECT FirstName, LastName
FROM customers
ORDER BY LastName DESC;

---17
SELECT COUNT(*) AS num_customers_different_cities
FROM customers c
JOIN invoices i ON c.CustomerId = i.CustomerId
WHERE c.City <> i.BillingCity;