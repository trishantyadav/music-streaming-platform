-- ============================================================
-- MUSIC STREAMING PLATFORM
-- DA2 - SUBQUERIES
-- ============================================================

SET LINESIZE 180
SET PAGESIZE 50
SET WRAP OFF;


-- ============================================================
-- 1. Single-row subquery
-- Songs longer than the average song duration
-- ============================================================

SELECT Song_id, Title, Duration
FROM SONG
WHERE Duration > (
    SELECT AVG(Duration)
    FROM SONG
);


-- ============================================================
-- 2. Single-row subquery
-- Songs shorter than the average duration
-- ============================================================

SELECT Song_id, Title, Duration
FROM SONG
WHERE Duration < (
    SELECT AVG(Duration)
    FROM SONG
);


-- ============================================================
-- 3. Subquery with MAX()
-- Longest song
-- ============================================================

SELECT Song_id, Title, Duration
FROM SONG
WHERE Duration = (
    SELECT MAX(Duration)
    FROM SONG
);


-- ============================================================
-- 4. Subquery with MIN()
-- Shortest song
-- ============================================================

SELECT Song_id, Title, Duration
FROM SONG
WHERE Duration = (
    SELECT MIN(Duration)
    FROM SONG
);


-- ============================================================
-- 5. Subquery with AVG()
-- Payments above average payment
-- ============================================================

SELECT Payment_id, Subscription_id, Amount
FROM PAYMENT
WHERE Amount > (
    SELECT AVG(Amount)
    FROM PAYMENT
);


-- ============================================================
-- 6. IN subquery
-- Songs belonging to albums created by artists
-- ============================================================

SELECT Song_id, Title, Album_id
FROM SONG
WHERE Album_id IN (
    SELECT Album_id
    FROM ALBUM
    WHERE Artist_id IN (
        SELECT Artist_id
        FROM ARTIST
    )
);


-- ============================================================
-- 7. IN subquery
-- Premium users who have subscriptions
-- ============================================================

SELECT User_id
FROM PREMIUM_USER
WHERE User_id IN (
    SELECT User_id
    FROM SUBSCRIPTION
);


-- ============================================================
-- 8. NOT IN subquery
-- Users who have never created a playlist
-- ============================================================

SELECT User_id, Name
FROM USERS
WHERE User_id NOT IN (
    SELECT User_id
    FROM PLAYLIST
);


-- ============================================================
-- 9. IN subquery
-- Songs that have received ratings
-- ============================================================

SELECT Song_id, Title
FROM SONG
WHERE Song_id IN (
    SELECT Song_id
    FROM RATING
);


-- ============================================================
-- 10. NOT IN subquery
-- Songs that have never been rated
-- ============================================================

SELECT Song_id, Title
FROM SONG
WHERE Song_id NOT IN (
    SELECT Song_id
    FROM RATING
);


-- ============================================================
-- 11. ANY
-- Songs longer than at least one song rated 5
-- ============================================================

SELECT Song_id, Title, Duration
FROM SONG
WHERE Duration > ANY (
    SELECT s.Duration
    FROM SONG s
    JOIN RATING r
        ON s.Song_id = r.Song_id
    WHERE r.Rating = 5
);


-- ============================================================
-- 12. ALL
-- Songs longer than every song rated 5
-- ============================================================

SELECT Song_id, Title, Duration
FROM SONG
WHERE Duration > ALL (
    SELECT s.Duration
    FROM SONG s
    JOIN RATING r
        ON s.Song_id = r.Song_id
    WHERE r.Rating = 5
);


-- ============================================================
-- 13. EXISTS
-- Users who have at least one playlist
-- ============================================================

SELECT u.User_id, u.Name
FROM USERS u
WHERE EXISTS (
    SELECT 1
    FROM PLAYLIST p
    WHERE p.User_id = u.User_id
);


-- ============================================================
-- 14. NOT EXISTS
-- Users without playlists
-- ============================================================

SELECT u.User_id, u.Name
FROM USERS u
WHERE NOT EXISTS (
    SELECT 1
    FROM PLAYLIST p
    WHERE p.User_id = u.User_id
);


-- ============================================================
-- 15. EXISTS
-- Songs that have at least one rating
-- ============================================================

SELECT s.Song_id, s.Title
FROM SONG s
WHERE EXISTS (
    SELECT 1
    FROM RATING r
    WHERE r.Song_id = s.Song_id
);


-- ============================================================
-- 16. Correlated subquery
-- Ratings higher than the average rating of that song
-- ============================================================

SELECT r.Rating_id, r.User_id, r.Song_id, r.Rating
FROM RATING r
WHERE r.Rating > (
    SELECT AVG(r2.Rating)
    FROM RATING r2
    WHERE r2.Song_id = r.Song_id
);


-- ============================================================
-- 17. Correlated subquery
-- Users who have listened to more than the average number
-- of listening records per user
-- ============================================================

SELECT lh.User_id, COUNT(*) AS Listening_Count
FROM LISTENING_HISTORY lh
GROUP BY lh.User_id
HAVING COUNT(*) > (
    SELECT AVG(user_count)
    FROM (
        SELECT COUNT(*) AS user_count
        FROM LISTENING_HISTORY
        GROUP BY User_id
    )
);


-- ============================================================
-- 18. Subquery with GROUP BY
-- Artists having more albums than the average artist
-- ============================================================

SELECT Artist_id, COUNT(*) AS Album_Count
FROM ALBUM
GROUP BY Artist_id
HAVING COUNT(*) > (
    SELECT AVG(album_count)
    FROM (
        SELECT COUNT(*) AS album_count
        FROM ALBUM
        GROUP BY Artist_id
    )
);


-- ============================================================
-- 19. Nested subquery
-- Songs belonging to the artist with the most albums
-- ============================================================

SELECT Song_id, Title, Album_id
FROM SONG
WHERE Album_id IN (
    SELECT Album_id
    FROM ALBUM
    WHERE Artist_id = (
        SELECT Artist_id
        FROM (
            SELECT Artist_id, COUNT(*) AS Album_Count
            FROM ALBUM
            GROUP BY Artist_id
            ORDER BY Album_Count DESC
        )
        FETCH FIRST 1 ROW ONLY
    )
);


-- ============================================================
-- 20. Nested subquery
-- Highest-rated songs whose average rating is >= 4
-- ============================================================

SELECT Song_id, Title
FROM SONG
WHERE Song_id IN (
    SELECT Song_id
    FROM RATING
    GROUP BY Song_id
    HAVING AVG(Rating) >= 4
);