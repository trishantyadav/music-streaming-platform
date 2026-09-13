-- ============================================================
-- MUSIC STREAMING PLATFORM
-- DA2 - BASIC SQL QUERIES AND OPERATORS
-- ============================================================

-- ============================================================
-- 1. SELECT ALL USERS
-- ============================================================

SELECT *
FROM USERS;


-- ============================================================
-- 2. SELECT SPECIFIC COLUMNS
-- ============================================================

SELECT User_id, Name, Email, Country
FROM USERS;


-- ============================================================
-- 3. DISTINCT COUNTRIES
-- ============================================================

SELECT DISTINCT Country
FROM USERS
ORDER BY Country;


-- ============================================================
-- 4. COMPARISON OPERATOR
-- Users with ID greater than 900
-- ============================================================

SELECT User_id, Name, Country
FROM USERS
WHERE User_id > 900;


-- ============================================================
-- 5. COMPARISON OPERATOR
-- Songs longer than 5 minutes
-- Duration is stored in milliseconds
-- 5 minutes = 300000 milliseconds
-- ============================================================

SELECT Song_id, Title, Duration
FROM SONG
WHERE Duration > 300000;


-- ============================================================
-- 6. EQUALITY OPERATOR
-- ============================================================

SELECT User_id, Name, Country
FROM USERS
WHERE Country = 'India';


-- ============================================================
-- 7. NOT EQUAL OPERATOR
-- ============================================================

SELECT User_id, Name, Country
FROM USERS
WHERE Country <> 'India';


-- ============================================================
-- 8. BETWEEN OPERATOR
-- Songs between 3 and 5 minutes
-- ============================================================

SELECT Song_id, Title, Duration
FROM SONG
WHERE Duration BETWEEN 180000 AND 300000;


-- ============================================================
-- 9. IN OPERATOR
-- ============================================================

SELECT User_id, Name, Country
FROM USERS
WHERE Country IN ('India', 'USA', 'UK');


-- ============================================================
-- 10. AND OPERATOR
-- ============================================================

SELECT User_id, Name, Country
FROM USERS
WHERE User_id > 500
AND Country = 'India';


-- ============================================================
-- 11. OR OPERATOR
-- ============================================================

SELECT User_id, Name, Country
FROM USERS
WHERE Country = 'India'
OR Country = 'USA';


-- ============================================================
-- 12. NOT OPERATOR
-- ============================================================

SELECT User_id, Name, Country
FROM USERS
WHERE NOT Country = 'India';


-- ============================================================
-- 13. LIKE - NAMES STARTING WITH A
-- ============================================================

SELECT User_id, Name
FROM USERS
WHERE Name LIKE 'A%';


-- ============================================================
-- 14. LIKE - NAMES ENDING WITH A
-- ============================================================

SELECT User_id, Name
FROM USERS
WHERE Name LIKE '%a';


-- ============================================================
-- 15. LIKE - NAMES CONTAINING 'an'
-- ============================================================

SELECT User_id, Name
FROM USERS
WHERE LOWER(Name) LIKE '%an%';


-- ============================================================
-- 16. LIKE - EMAILS FROM A DOMAIN
-- ============================================================

SELECT User_id, Name, Email
FROM USERS
WHERE Email LIKE '%@gmail.com';


-- ============================================================
-- 17. NULL CHECK
-- ============================================================

SELECT Artist_id, Name, Country
FROM ARTIST
WHERE Country IS NULL;


-- ============================================================
-- 18. NOT NULL CHECK
-- ============================================================

SELECT Artist_id, Name, Country
FROM ARTIST
WHERE Country IS NOT NULL;


-- ============================================================
-- 19. ARITHMETIC OPERATOR
-- Convert song duration from milliseconds to minutes
-- ============================================================

SELECT
    Song_id,
    Title,
    Duration,
    ROUND(Duration / 60000, 2) AS Duration_Minutes
FROM SONG;


-- ============================================================
-- 20. ARITHMETIC OPERATOR WITH FILTER
-- Songs whose duration is greater than 4 minutes
-- ============================================================

SELECT
    Song_id,
    Title,
    ROUND(Duration / 60000, 2) AS Duration_Minutes
FROM SONG
WHERE Duration / 60000 > 4
ORDER BY Duration DESC;