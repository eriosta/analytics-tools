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