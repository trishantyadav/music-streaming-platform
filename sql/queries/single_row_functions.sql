-- ============================================================
-- MUSIC STREAMING PLATFORM
-- DA2 - SINGLE-ROW FUNCTIONS
-- ============================================================

SET LINESIZE 180
SET PAGESIZE 50
SET WRAP OFF


-- ============================================================
-- 1. UPPER()
-- Display artist names in uppercase
-- ============================================================

SELECT
    Artist_id,
    Name,
    UPPER(Name) AS Artist_Name_Upper
FROM ARTIST
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 2. LOWER()
-- Display user email addresses in lowercase
-- ============================================================

SELECT
    User_id,
    Name,
    LOWER(Email) AS Email_Lower
FROM USERS
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 3. INITCAP()
-- Convert names to proper case
-- ============================================================

SELECT
    User_id,
    Name,
    INITCAP(Name) AS Formatted_Name
FROM USERS
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 4. LENGTH()
-- Find the length of song titles
-- ============================================================

SELECT
    Song_id,
    Title,
    LENGTH(Title) AS Title_Length
FROM SONG
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 5. SUBSTR()
-- Display first 10 characters of song titles
-- ============================================================

SELECT
    Song_id,
    Title,
    SUBSTR(Title, 1, 10) AS Short_Title
FROM SONG
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 6. INSTR()
-- Find the position of the character 'a'
-- in artist names
-- ============================================================

SELECT
    Artist_id,
    Name,
    INSTR(LOWER(Name), 'a') AS Position_Of_A
FROM ARTIST
WHERE INSTR(LOWER(Name), 'a') > 0
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 7. CONCAT()
-- Combine artist name with country
-- ============================================================

SELECT
    Artist_id,
    CONCAT(Name, ' - ') || Country AS Artist_Country
FROM ARTIST
WHERE Country IS NOT NULL
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 8. ROUND()
-- Convert song duration from milliseconds to minutes
-- ============================================================

SELECT
    Song_id,
    Title,
    ROUND(Duration / 60000, 2) AS Duration_Minutes
FROM SONG
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 9. TRUNC()
-- Truncate song duration to whole minutes
-- ============================================================

SELECT
    Song_id,
    Title,
    TRUNC(Duration / 60000) AS Whole_Minutes
FROM SONG
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 10. MOD()
-- Find remaining seconds after complete minutes
-- ============================================================

SELECT
    Song_id,
    Title,
    MOD(TRUNC(Duration / 1000), 60) AS Remaining_Seconds
FROM SONG
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 11. NVL()
-- Replace missing artist country with 'Unknown'
-- ============================================================

SELECT
    Artist_id,
    Name,
    NVL(Country, 'Unknown') AS Artist_Country
FROM ARTIST
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 12. NVL2()
-- Check whether artist biography is available
-- ============================================================

SELECT
    Artist_id,
    Name,
    NVL2(
        Bio,
        'Biography Available',
        'Biography Not Available'
    ) AS Biography_Status
FROM ARTIST
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 13. TO_CHAR() - DATE
-- Format user signup date
-- ============================================================

SELECT
    User_id,
    Name,
    TO_CHAR(Signup_date, 'DD-MON-YYYY') AS Signup_Date
FROM USERS
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 14. TO_CHAR() - NUMBER
-- Format song duration in minutes
-- ============================================================

SELECT
    Song_id,
    Title,
    TO_CHAR(
        ROUND(Duration / 60000, 2),
        '990.00'
    ) AS Duration_Minutes
FROM SONG
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 15. TO_CHAR() - DATE WITH MONTH
-- ============================================================

SELECT
    User_id,
    Name,
    TO_CHAR(Signup_date, 'DD MONTH YYYY') AS Formatted_Signup_Date
FROM USERS
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 16. TO_DATE()
-- Convert a character value into an Oracle DATE
-- ============================================================

SELECT
    TO_DATE('13-SEP-2026', 'DD-MON-YYYY') AS Converted_Date
FROM DUAL;


-- ============================================================
-- 17. ADD_MONTHS()
-- Find subscription renewal date after 1 month
-- ============================================================

SELECT
    Subscription_id,
    User_id,
    Start_date,
    ADD_MONTHS(Start_date, 1) AS One_Month_Later
FROM SUBSCRIPTION
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 18. MONTHS_BETWEEN()
-- Calculate subscription duration in months
-- ============================================================

SELECT
    Subscription_id,
    User_id,
    ROUND(
        MONTHS_BETWEEN(End_date, Start_date),
        2
    ) AS Subscription_Months
FROM SUBSCRIPTION
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 19. LAST_DAY()
-- Find the last day of the subscription start month
-- ============================================================

SELECT
    Subscription_id,
    Start_date,
    LAST_DAY(Start_date) AS Month_End
FROM SUBSCRIPTION
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 20. SYSDATE
-- Display current database date
-- ============================================================

SELECT SYSDATE AS Current_Database_Date
FROM DUAL;