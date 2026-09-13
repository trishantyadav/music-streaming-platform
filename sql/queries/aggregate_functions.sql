-- ============================================================
-- MUSIC STREAMING PLATFORM
-- DA2 - AGGREGATE FUNCTIONS, GROUP BY AND HAVING
-- ============================================================

SET LINESIZE 180
SET PAGESIZE 50
SET WRAP OFF


-- ============================================================
-- 1. COUNT()
-- Total number of users
-- ============================================================

SELECT COUNT(*) AS Total_Users
FROM USERS;


-- ============================================================
-- 2. COUNT()
-- Total number of songs
-- ============================================================

SELECT COUNT(*) AS Total_Songs
FROM SONG;


-- ============================================================
-- 3. COUNT()
-- Total listening-history records
-- ============================================================

SELECT COUNT(*) AS Total_Listening_Records
FROM LISTENING_HISTORY;


-- ============================================================
-- 4. COUNT(DISTINCT)
-- Number of different artists
-- ============================================================

SELECT COUNT(DISTINCT Artist_id) AS Total_Artists
FROM ARTIST;


-- ============================================================
-- 5. AVG()
-- Average song duration
-- ============================================================

SELECT
    ROUND(AVG(Duration) / 60000, 2) AS Average_Duration_Minutes
FROM SONG;


-- ============================================================
-- 6. MIN() AND MAX()
-- Shortest and longest songs
-- ============================================================

SELECT
    ROUND(MIN(Duration) / 60000, 2) AS Shortest_Minutes,
    ROUND(MAX(Duration) / 60000, 2) AS Longest_Minutes
FROM SONG;


-- ============================================================
-- 7. SUM()
-- Total amount received from payments
-- ============================================================

SELECT
    ROUND(SUM(Amount), 2) AS Total_Payment_Amount
FROM PAYMENT;


-- ============================================================
-- 8. AVG()
-- Average payment amount
-- ============================================================

SELECT
    ROUND(AVG(Amount), 2) AS Average_Payment
FROM PAYMENT;


-- ============================================================
-- 9. MIN() AND MAX()
-- Minimum and maximum payment
-- ============================================================

SELECT
    MIN(Amount) AS Minimum_Payment,
    MAX(Amount) AS Maximum_Payment
FROM PAYMENT;


-- ============================================================
-- 10. GROUP BY
-- Number of songs in each album
-- ============================================================

SELECT
    Album_id,
    COUNT(*) AS Number_Of_Songs
FROM SONG
GROUP BY Album_id
ORDER BY Number_Of_Songs DESC;


-- ============================================================
-- 11. GROUP BY
-- Number of albums released by each artist
-- ============================================================

SELECT
    Artist_id,
    COUNT(*) AS Number_Of_Albums
FROM ALBUM
GROUP BY Artist_id
ORDER BY Number_Of_Albums DESC;


-- ============================================================
-- 12. GROUP BY
-- Number of songs for each artist
-- ============================================================

SELECT
    a.Artist_id,
    a.Name AS Artist_Name,
    COUNT(s.Song_id) AS Number_Of_Songs
FROM ARTIST a
JOIN ALBUM al
    ON a.Artist_id = al.Artist_id
JOIN SONG s
    ON al.Album_id = s.Album_id
GROUP BY
    a.Artist_id,
    a.Name
ORDER BY Number_Of_Songs DESC
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 13. GROUP BY
-- Number of users in each country
-- ============================================================

SELECT
    Country,
    COUNT(*) AS Number_Of_Users
FROM USERS
GROUP BY Country
ORDER BY Number_Of_Users DESC;


-- ============================================================
-- 14. GROUP BY
-- Average rating for each song
-- ============================================================

SELECT
    Song_id,
    ROUND(AVG(Rating), 2) AS Average_Rating,
    COUNT(*) AS Number_Of_Ratings
FROM RATING
GROUP BY Song_id
ORDER BY Average_Rating DESC
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 15. GROUP BY
-- Number of ratings for each rating value
-- ============================================================

SELECT
    Rating,
    COUNT(*) AS Number_Of_Ratings
FROM RATING
GROUP BY Rating
ORDER BY Rating;


-- ============================================================
-- 16. GROUP BY
-- Listening records for each user
-- ============================================================

SELECT
    User_id,
    COUNT(*) AS Listening_Count
FROM LISTENING_HISTORY
GROUP BY User_id
ORDER BY Listening_Count DESC
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 17. SUM() + GROUP BY
-- Total listening duration for each user
-- ============================================================

SELECT
    User_id,
    ROUND(SUM(Duration_played) / 60000, 2) AS Total_Minutes_Listened
FROM LISTENING_HISTORY
GROUP BY User_id
ORDER BY Total_Minutes_Listened DESC
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 18. HAVING
-- Users with more than 100 listening records
-- ============================================================

SELECT
    User_id,
    COUNT(*) AS Listening_Count
FROM LISTENING_HISTORY
GROUP BY User_id
HAVING COUNT(*) > 100
ORDER BY Listening_Count DESC;


-- ============================================================
-- 19. HAVING
-- Artists having more than 5 albums
-- ============================================================

SELECT
    Artist_id,
    COUNT(*) AS Album_Count
FROM ALBUM
GROUP BY Artist_id
HAVING COUNT(*) > 5
ORDER BY Album_Count DESC;


-- ============================================================
-- 20. HAVING
-- Songs with an average rating of at least 4
-- ============================================================

SELECT
    Song_id,
    ROUND(AVG(Rating), 2) AS Average_Rating,
    COUNT(*) AS Rating_Count
FROM RATING
GROUP BY Song_id
HAVING AVG(Rating) >= 4
ORDER BY Average_Rating DESC;


-- ============================================================
-- 21. GROUP BY + HAVING
-- Countries having more than 50 users
-- ============================================================

SELECT
    Country,
    COUNT(*) AS Number_Of_Users
FROM USERS
GROUP BY Country
HAVING COUNT(*) > 50
ORDER BY Number_Of_Users DESC;


-- ============================================================
-- 22. GROUP BY + SUM()
-- Total revenue by subscription
-- ============================================================

SELECT
    Subscription_id,
    ROUND(SUM(Amount), 2) AS Subscription_Revenue
FROM PAYMENT
WHERE Status = 'Success'
GROUP BY Subscription_id
ORDER BY Subscription_Revenue DESC
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 23. GROUP BY + AVG()
-- Average listening duration per user
-- ============================================================

SELECT
    User_id,
    ROUND(AVG(Duration_played) / 60000, 2)
        AS Average_Played_Minutes
FROM LISTENING_HISTORY
GROUP BY User_id
ORDER BY Average_Played_Minutes DESC
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 24. MULTIPLE AGGREGATE FUNCTIONS
-- Overall listening statistics
-- ============================================================

SELECT
    COUNT(*) AS Total_Records,
    ROUND(SUM(Duration_played) / 60000, 2)
        AS Total_Minutes,
    ROUND(AVG(Duration_played) / 60000, 2)
        AS Average_Played_Minutes,
    MIN(Duration_played) AS Minimum_Played_MS,
    MAX(Duration_played) AS Maximum_Played_MS
FROM LISTENING_HISTORY;