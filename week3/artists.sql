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

-- Find the first and last name of any customer who does **not** 
-- have an invoice. Are there any customers returned from the query?
