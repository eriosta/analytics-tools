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