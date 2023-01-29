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

-- Employees to customers
-- Only EmployeeID 2, 3, 5 have a O2M relationship with customers (for them, EmployeeId == SupportRedId)
SELECT SupportRepId, COUNT(CustomerId)
FROM customers
GROUP BY SupportRepId

-- #3 Datatypes that can be assigned to a column when creating a table: 
-- NULL. The value is a NULL value.
-- INTEGER. The value is a signed integer, stored in 0, 1, 2, 3, 4, 6, or 8 bytes depending on the magnitude of the value.
-- REAL. The value is a floating point value, stored as an 8-byte IEEE floating point number.
-- TEXT. The value is a text string, stored using the database encoding (UTF-8, UTF-16BE or UTF-16LE).
-- BLOB. The value is a blob of data, stored exactly as it was input.

-- SQLite does NOT have a separate Boolean storage class, so they are stored as integers (0) false and (1) true
-- SQLite does NOT have a separate Time storage class, but the built-in Date And Time Functions can storage dates
-- and times as TEXT, REAL, or INTEGER values. Examples:
-- TEXT as ISO8601 strings ("YYYY-MM-DD HH:MM:SS.SSS")