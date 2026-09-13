-- ============================================================
-- MUSIC STREAMING PLATFORM
-- DA2 - VIEWS
-- ============================================================

SET LINESIZE 180
SET PAGESIZE 50
SET WRAP OFF;


-- ============================================================
-- 1. SONG DETAILS VIEW
-- Song + Album + Artist
-- ============================================================

CREATE OR REPLACE VIEW SONG_DETAILS_VIEW AS
SELECT
    s.Song_id,
    s.Title AS Song_Name,
    s.Duration,
    al.Album_id,
    al.Title AS Album_Name,
    ar.Artist_id,
    ar.Name AS Artist_Name
FROM SONG s
JOIN ALBUM al
    ON s.Album_id = al.Album_id
JOIN ARTIST ar
    ON al.Artist_id = ar.Artist_id;


-- Test View
SELECT *
FROM SONG_DETAILS_VIEW
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 2. SONG GENRE VIEW
-- Songs with their genres
-- ============================================================

CREATE OR REPLACE VIEW SONG_GENRE_VIEW AS
SELECT
    s.Song_id,
    s.Title AS Song_Name,
    g.Genre_id,
    g.Name AS Genre
FROM SONG s
JOIN SONG_GENRE sg
    ON s.Song_id = sg.Song_id
JOIN GENRE g
    ON sg.Genre_id = g.Genre_id;


-- Test View
SELECT *
FROM SONG_GENRE_VIEW
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 3. USER LISTENING SUMMARY VIEW
-- Total plays and listening time per user
-- ============================================================

CREATE OR REPLACE VIEW USER_LISTENING_SUMMARY AS
SELECT
    u.User_id,
    u.Name AS User_Name,
    COUNT(lh.History_id) AS Total_Plays,
    ROUND(SUM(lh.Duration_played) / 60000, 2)
        AS Total_Minutes_Listened
FROM USERS u
LEFT JOIN LISTENING_HISTORY lh
    ON u.User_id = lh.User_id
GROUP BY
    u.User_id,
    u.Name;


-- Test View
SELECT *
FROM USER_LISTENING_SUMMARY
ORDER BY Total_Plays DESC
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 4. ARTIST PERFORMANCE VIEW
-- Artist + albums + songs
-- ============================================================

CREATE OR REPLACE VIEW ARTIST_PERFORMANCE_VIEW AS
SELECT
    ar.Artist_id,
    ar.Name AS Artist_Name,
    COUNT(DISTINCT al.Album_id) AS Total_Albums,
    COUNT(s.Song_id) AS Total_Songs
FROM ARTIST ar
LEFT JOIN ALBUM al
    ON ar.Artist_id = al.Artist_id
LEFT JOIN SONG s
    ON al.Album_id = s.Album_id
GROUP BY
    ar.Artist_id,
    ar.Name;


-- Test View
SELECT *
FROM ARTIST_PERFORMANCE_VIEW
ORDER BY Total_Songs DESC
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 5. PREMIUM USER VIEW
-- Premium users with subscription information
-- ============================================================

CREATE OR REPLACE VIEW PREMIUM_USER_SUBSCRIPTION_VIEW AS
SELECT
    u.User_id,
    u.Name AS User_Name,
    u.Email,
    pu.Audio_quality,
    pu.Offline_downloads,
    su.Subscription_id,
    su.Plan_type,
    su.Start_date,
    su.End_date
FROM USERS u
JOIN PREMIUM_USER pu
    ON u.User_id = pu.User_id
JOIN SUBSCRIPTION su
    ON pu.User_id = su.User_id;


-- Test View
SELECT *
FROM PREMIUM_USER_SUBSCRIPTION_VIEW
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 6. SONG RATING VIEW
-- Songs with average rating and rating count
-- ============================================================

CREATE OR REPLACE VIEW SONG_RATING_SUMMARY AS
SELECT
    s.Song_id,
    s.Title AS Song_Name,
    ROUND(AVG(r.Rating), 2) AS Average_Rating,
    COUNT(r.Rating_id) AS Rating_Count
FROM SONG s
LEFT JOIN RATING r
    ON s.Song_id = r.Song_id
GROUP BY
    s.Song_id,
    s.Title;


-- Test View
SELECT *
FROM SONG_RATING_SUMMARY
WHERE Rating_Count > 0
ORDER BY Average_Rating DESC
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 7. PAYMENT SUMMARY VIEW
-- Subscription payment information
-- ============================================================

CREATE OR REPLACE VIEW PAYMENT_SUMMARY_VIEW AS
SELECT
    su.Subscription_id,
    su.User_id,
    su.Plan_type,
    COUNT(p.Payment_id) AS Payment_Count,
    ROUND(SUM(
        CASE
            WHEN p.Status = 'Success' THEN p.Amount
            ELSE 0
        END
    ), 2) AS Successful_Payment_Amount
FROM SUBSCRIPTION su
LEFT JOIN PAYMENT p
    ON su.Subscription_id = p.Subscription_id
GROUP BY
    su.Subscription_id,
    su.User_id,
    su.Plan_type;


-- Test View
SELECT *
FROM PAYMENT_SUMMARY_VIEW
ORDER BY Successful_Payment_Amount DESC
FETCH FIRST 20 ROWS ONLY;