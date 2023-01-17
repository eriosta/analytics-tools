-- SQLite
-- Selecting and retrieving data with SQL

-- #1
-- the following returns an error because it's missing commas between variables
-- SELECT
-- TrackID
-- Name
-- AlbumID
-- FROM tracks
-- Run below instead
SELECT TrackId, Name, AlbumId FROM tracks

-- #2 Prove one-to-many relationships to yourself
-- Artist to albumns
SELECT ArtistId, COUNT(AlbumId)
FROM albums
GROUP BY ArtistId

-- Customers to invoices
SELECT CustomerId, COUNT(InvoiceId)
FROM invoices
GROUP BY CustomerId