SET LINESIZE 150
SET PAGESIZE 100
SET WRAP OFF

PROMPT
PROMPT ========================================
PROMPT Q1. Display all users
PROMPT ========================================

SELECT *
FROM USERS;


PROMPT
PROMPT ========================================
PROMPT Q2. Display selected user information
PROMPT ========================================

SELECT
    User_id,
    Name,
    Email,
    Country
FROM USERS
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q3. Display all distinct countries of users
PROMPT ========================================

SELECT DISTINCT Country
FROM USERS
ORDER BY Country;


PROMPT
PROMPT ========================================
PROMPT Q4. Find songs with duration greater than 200000 milliseconds
PROMPT ========================================

SELECT
    Song_id,
    Title,
    Duration
FROM SONG
WHERE Duration > 200000
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q5. Find songs with duration less than 180000 milliseconds
PROMPT ========================================

SELECT
    Song_id,
    Title,
    Duration
FROM SONG
WHERE Duration < 180000
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q6. Find songs with duration exactly 204346 milliseconds
PROMPT ========================================

SELECT
    Song_id,
    Title,
    Duration
FROM SONG
WHERE Duration = 204346;


PROMPT
PROMPT ========================================
PROMPT Q7. Find songs whose duration is not 204346 milliseconds
PROMPT ========================================

SELECT
    Song_id,
    Title,
    Duration
FROM SONG
WHERE Duration <> 204346
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q8. Find songs with duration between 180000 and 220000 milliseconds
PROMPT ========================================

SELECT
    Song_id,
    Title,
    Duration
FROM SONG
WHERE Duration BETWEEN 180000 AND 220000
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q9. Find users from selected countries using IN
PROMPT ========================================

SELECT
    User_id,
    Name,
    Country
FROM USERS
WHERE Country IN ('India', 'USA', 'Canada')
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q10. Find users who are from India AND have an email
PROMPT ========================================

SELECT
    User_id,
    Name,
    Email,
    Country
FROM USERS
WHERE Country = 'India'
AND Email IS NOT NULL
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q11. Find users from India OR USA
PROMPT ========================================

SELECT
    User_id,
    Name,
    Country
FROM USERS
WHERE Country = 'India'
OR Country = 'USA'
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q12. Find users NOT from India
PROMPT ========================================

SELECT
    User_id,
    Name,
    Country
FROM USERS
WHERE NOT Country = 'India'
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q13. Find artists whose names start with A
PROMPT ========================================

SELECT
    Artist_id,
    Name
FROM ARTIST
WHERE Name LIKE 'A%'
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q14. Find artists whose names end with a
PROMPT ========================================

SELECT
    Artist_id,
    Name
FROM ARTIST
WHERE LOWER(Name) LIKE '%a'
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q15. Find songs containing the word love
PROMPT ========================================

SELECT
    Song_id,
    Title
FROM SONG
WHERE LOWER(Title) LIKE '%love%'
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q16. Find artists whose country information is missing
PROMPT ========================================

SELECT
    Artist_id,
    Name,
    Country
FROM ARTIST
WHERE Country IS NULL
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q17. Find artists whose country information is available
PROMPT ========================================

SELECT
    Artist_id,
    Name,
    Country
FROM ARTIST
WHERE Country IS NOT NULL
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q18. Display song duration converted from milliseconds to seconds
PROMPT ========================================

SELECT
    Song_id,
    Title,
    Duration,
    Duration / 1000 AS DURATION_SECONDS
FROM SONG
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q19. Display song duration converted from milliseconds to minutes
PROMPT ========================================

SELECT
    Song_id,
    Title,
    Duration,
    ROUND(Duration / 60000, 2) AS DURATION_MINUTES
FROM SONG
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q20. Find payments greater than 500
PROMPT ========================================

SELECT
    Payment_id,
    Subscription_id,
    Amount,
    Status
FROM PAYMENT
WHERE Amount > 500
FETCH FIRST 20 ROWS ONLY;