# Week 3
## Subqueries and Joins in SQL
### Chinook Database
Open source Chinook database: https://www.sqlitetutorial.net/sqlite-sample-database/

### Tasks

How many albums does the artist Led Zeppelin have?

```sql
SELECT ART.NAME, COUNT(DISTINCT(ALB.AlbumId)) AS UniqueAlbumCount
    FROM albums ALB
        LEFT JOIN artists ART
            ON ART.ArtistId = ALB.ArtistId
    WHERE ART.NAME = "Led Zeppelin"\

-- Name UniqueAlbumCount
-- Led Zeppelin 14

SELECT ART.NAME, ALB.TITLE
    FROM albums ALB
        LEFT JOIN artists ART
            ON ART.ArtistId = ALB.ArtistId
    WHERE ART.NAME = "Led Zeppelin"

-- Name Title
-- Led Zeppelin	BBC Sessions [Disc 1] [Live]
-- Led Zeppelin	Physical Graffiti [Disc 1]
-- Led Zeppelin	BBC Sessions [Disc 2] [Live]
-- Led Zeppelin	Coda
-- Led Zeppelin	Houses Of The Holy
-- Led Zeppelin	In Through The Out Door
-- Led Zeppelin	IV
-- Led Zeppelin	Led Zeppelin I
-- Led Zeppelin	Led Zeppelin II
-- Led Zeppelin	Led Zeppelin III
-- Led Zeppelin	Physical Graffiti [Disc 2]
-- Led Zeppelin	Presence
-- Led Zeppelin	The Song Remains The Same (Disc 1)
-- Led Zeppelin	The Song Remains The Same (Disc 2)
```

Create a list of album titles and the unit prices for the artist `Audioslave`. How many records are returned?

```sql
SELECT ART.Name, ALB.Title, TRK.Name, TRK.UnitPrice
FROM albums ALB
LEFT JOIN artists ART ON ART.ArtistId = ALB.ArtistId
LEFT JOIN tracks TRK ON TRK.AlbumId = ALB.AlbumId 
WHERE ART.Name = "Audioslave"
-- Name	Title	Name	UnitPrice
-- Audioslave	Audioslave	Cochise	0.99
-- Audioslave	Audioslave	Show Me How to Live	0.99
-- Audioslave	Audioslave	Gasoline	0.99
-- Audioslave	Audioslave	What You Are	0.99
-- Audioslave	Audioslave	Like a Stone	0.99
-- Audioslave	Audioslave	Set It Off	0.99
-- Audioslave	Audioslave	Shadow on the Sun	0.99
-- Audioslave	Audioslave	I am the Highway	0.99
-- Audioslave	Audioslave	Exploder	0.99
-- Audioslave	Audioslave	Hypnotize	0.99
-- Audioslave	Audioslave	Bring'em Back Alive	0.99
-- ... 40 records total 
```

Find the first and last name of any customer who does **not** have an invoice. Are there any customers returned from the query?

```sql
SELECT c.FirstName, c.LastName
FROM customers c
WHERE c.CustomerId NOT IN (SELECT i.CustomerId FROM invoices i);
-- None
```

Find the total price for each album. What is the total price for the album `Big Ones`?

```sql
SELECT albums.Title, SUM(invoice_items.UnitPrice * invoice_items.Quantity) AS Total_Price
FROM albums
JOIN tracks ON albums.AlbumId = tracks.AlbumId
JOIN invoice_items ON tracks.TrackId = invoice_items.TrackId
GROUP BY albums.Title
HAVING albums.Title = 'Big Ones'
-- The total price for the album "Big Ones" is $9.9
```

How many records are created when you apply a **Cartesian join** to the invoice and invoice items table? How many records were retrieved?

``` sql
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
-- 922880
```
