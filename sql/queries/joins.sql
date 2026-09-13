-- ============================================================
-- MUSIC STREAMING PLATFORM
-- DA2 - JOINS
-- ============================================================

SET LINESIZE 180
SET PAGESIZE 50
SET WRAP OFF;


-- ============================================================
-- 1. INNER JOIN
-- Songs with their album names
-- ============================================================

SELECT
    s.Song_id,
    s.Title AS Song_Name,
    a.Title AS Album_Name
FROM SONG s
INNER JOIN ALBUM a
    ON s.Album_id = a.Album_id
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 2. INNER JOIN
-- Albums with their artists
-- ============================================================

SELECT
    a.Album_id,
    a.Title AS Album_Name,
    ar.Name AS Artist_Name
FROM ALBUM a
INNER JOIN ARTIST ar
    ON a.Artist_id = ar.Artist_id
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 3. THREE-TABLE INNER JOIN
-- Songs, albums and artists
-- ============================================================

SELECT
    s.Song_id,
    s.Title AS Song_Name,
    al.Title AS Album_Name,
    ar.Name AS Artist_Name
FROM SONG s
JOIN ALBUM al
    ON s.Album_id = al.Album_id
JOIN ARTIST ar
    ON al.Artist_id = ar.Artist_id
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 4. INNER JOIN
-- Users and their playlists
-- ============================================================

SELECT
    u.User_id,
    u.Name AS User_Name,
    p.Playlist_id,
    p.Name AS Playlist_Name
FROM USERS u
JOIN PLAYLIST p
    ON u.User_id = p.User_id
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 5. INNER JOIN
-- Users and their listening history
-- ============================================================

SELECT
    u.User_id,
    u.Name AS User_Name,
    lh.Song_id,
    lh.Played_at,
    lh.Duration_played
FROM USERS u
JOIN LISTENING_HISTORY lh
    ON u.User_id = lh.User_id
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 6. INNER JOIN
-- Songs and their genres
-- ============================================================

SELECT
    s.Song_id,
    s.Title AS Song_Name,
    g.Name AS Genre
FROM SONG s
JOIN SONG_GENRE sg
    ON s.Song_id = sg.Song_id
JOIN GENRE g
    ON sg.Genre_id = g.Genre_id
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 7. INNER JOIN
-- Premium users and subscriptions
-- ============================================================

SELECT
    u.User_id,
    u.Name,
    su.Subscription_id,
    su.Plan_type,
    su.Start_date,
    su.End_date
FROM USERS u
JOIN PREMIUM_USER pu
    ON u.User_id = pu.User_id
JOIN SUBSCRIPTION su
    ON pu.User_id = su.User_id
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 8. INNER JOIN
-- Subscriptions and payments
-- ============================================================

SELECT
    su.Subscription_id,
    su.Plan_type,
    p.Payment_id,
    p.Amount,
    p.Status
FROM SUBSCRIPTION su
JOIN PAYMENT p
    ON su.Subscription_id = p.Subscription_id
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 9. LEFT OUTER JOIN
-- All users including users without playlists
-- ============================================================

SELECT
    u.User_id,
    u.Name,
    p.Playlist_id,
    p.Name AS Playlist_Name
FROM USERS u
LEFT OUTER JOIN PLAYLIST p
    ON u.User_id = p.User_id
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 10. LEFT OUTER JOIN
-- All artists including artists without albums
-- ============================================================

SELECT
    ar.Artist_id,
    ar.Name AS Artist_Name,
    al.Album_id,
    al.Title AS Album_Name
FROM ARTIST ar
LEFT OUTER JOIN ALBUM al
    ON ar.Artist_id = al.Artist_id
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 11. LEFT OUTER JOIN
-- All songs including songs without ratings
-- ============================================================

SELECT
    s.Song_id,
    s.Title,
    r.Rating
FROM SONG s
LEFT OUTER JOIN RATING r
    ON s.Song_id = r.Song_id
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 12. RIGHT OUTER JOIN
-- All playlists and their users
-- ============================================================

SELECT
    u.User_id,
    u.Name AS User_Name,
    p.Playlist_id,
    p.Name AS Playlist_Name
FROM USERS u
RIGHT OUTER JOIN PLAYLIST p
    ON u.User_id = p.User_id
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 13. RIGHT OUTER JOIN
-- All payments including their subscription information
-- ============================================================

SELECT
    su.Subscription_id,
    su.Plan_type,
    p.Payment_id,
    p.Amount
FROM SUBSCRIPTION su
RIGHT OUTER JOIN PAYMENT p
    ON su.Subscription_id = p.Subscription_id
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 14. FULL OUTER JOIN
-- All users and playlists
-- ============================================================

SELECT
    u.User_id,
    u.Name AS User_Name,
    p.Playlist_id,
    p.Name AS Playlist_Name
FROM USERS u
FULL OUTER JOIN PLAYLIST p
    ON u.User_id = p.User_id
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 15. FULL OUTER JOIN
-- All artists and albums
-- ============================================================

SELECT
    ar.Artist_id,
    ar.Name AS Artist_Name,
    al.Album_id,
    al.Title AS Album_Name
FROM ARTIST ar
FULL OUTER JOIN ALBUM al
    ON ar.Artist_id = al.Artist_id
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 16. JOIN + GROUP BY
-- Number of songs for each artist
-- ============================================================

SELECT
    ar.Artist_id,
    ar.Name AS Artist_Name,
    COUNT(s.Song_id) AS Song_Count
FROM ARTIST ar
JOIN ALBUM al
    ON ar.Artist_id = al.Artist_id
JOIN SONG s
    ON al.Album_id = s.Album_id
GROUP BY ar.Artist_id, ar.Name
ORDER BY Song_Count DESC
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 17. JOIN + GROUP BY
-- Number of listening records for each song
-- ============================================================

SELECT
    s.Song_id,
    s.Title,
    COUNT(lh.History_id) AS Play_Count
FROM SONG s
JOIN LISTENING_HISTORY lh
    ON s.Song_id = lh.Song_id
GROUP BY s.Song_id, s.Title
ORDER BY Play_Count DESC
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 18. JOIN + GROUP BY
-- Total listening time for each user
-- ============================================================

SELECT
    u.User_id,
    u.Name,
    ROUND(SUM(lh.Duration_played) / 60000, 2)
        AS Total_Minutes
FROM USERS u
JOIN LISTENING_HISTORY lh
    ON u.User_id = lh.User_id
GROUP BY u.User_id, u.Name
ORDER BY Total_Minutes DESC
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 19. CROSS JOIN
-- Users and subscription plans
-- ============================================================

SELECT
    u.User_id,
    u.Name,
    su.Plan_type
FROM USERS u
CROSS JOIN (
    SELECT DISTINCT Plan_type
    FROM SUBSCRIPTION
) su
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 20. SELF JOIN
-- Find pairs of artists from the same country
-- ============================================================

SELECT
    a1.Name AS Artist_1,
    a2.Name AS Artist_2,
    a1.Country
FROM ARTIST a1
JOIN ARTIST a2
    ON a1.Country = a2.Country
   AND a1.Artist_id < a2.Artist_id
FETCH FIRST 20 ROWS ONLY;