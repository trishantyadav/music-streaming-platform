SET LINESIZE 150
SET PAGESIZE 100
SET WRAP OFF

PROMPT
PROMPT ========================================
PROMPT Q1. Find songs longer than the average song duration
PROMPT ========================================

SELECT Song_id, Title, Duration
FROM SONG
WHERE Duration > (
    SELECT AVG(Duration)
    FROM SONG
)
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q2. Find users who have given at least one rating
PROMPT ========================================

SELECT User_id, Name
FROM USERS
WHERE User_id IN (
    SELECT User_id
    FROM RATING
)
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q3. Find users who have never given a rating
PROMPT ========================================

SELECT User_id, Name
FROM USERS
WHERE User_id NOT IN (
    SELECT User_id
    FROM RATING
)
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q4. Find songs that have received the maximum rating
PROMPT ========================================

SELECT Song_id, Title
FROM SONG
WHERE Song_id IN (
    SELECT Song_id
    FROM RATING
    WHERE Rating = (
        SELECT MAX(Rating)
        FROM RATING
    )
)
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q5. Find artists who have released more albums than average
PROMPT ========================================

SELECT Artist_id, COUNT(*) AS NUMBER_OF_ALBUMS
FROM ALBUM
GROUP BY Artist_id
HAVING COUNT(*) > (
    SELECT AVG(ALBUM_COUNT)
    FROM (
        SELECT COUNT(*) AS ALBUM_COUNT
        FROM ALBUM
        GROUP BY Artist_id
    )
);


PROMPT
PROMPT ========================================
PROMPT Q6. Find the user with the highest number of listening records
PROMPT ========================================

SELECT User_id, COUNT(*) AS LISTENING_COUNT
FROM LISTENING_HISTORY
GROUP BY User_id
HAVING COUNT(*) = (
    SELECT MAX(LISTENING_COUNT)
    FROM (
        SELECT COUNT(*) AS LISTENING_COUNT
        FROM LISTENING_HISTORY
        GROUP BY User_id
    )
);


PROMPT
PROMPT ========================================
PROMPT Q7. Find songs that have never been rated
PROMPT ========================================

SELECT Song_id, Title
FROM SONG
WHERE Song_id NOT IN (
    SELECT Song_id
    FROM RATING
)
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q8. Find users whose listening count is above average
PROMPT ========================================

SELECT User_id, COUNT(*) AS LISTENING_COUNT
FROM LISTENING_HISTORY
GROUP BY User_id
HAVING COUNT(*) > (
    SELECT AVG(USER_COUNT)
    FROM (
        SELECT COUNT(*) AS USER_COUNT
        FROM LISTENING_HISTORY
        GROUP BY User_id
    )
);


PROMPT
PROMPT ========================================
PROMPT Q9. Find songs whose duration is greater than the minimum duration
PROMPT ========================================

SELECT Song_id, Title, Duration
FROM SONG
WHERE Duration > (
    SELECT MIN(Duration)
    FROM SONG
)
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q10. Find users who have rated songs with rating 5
PROMPT ========================================

SELECT User_id, Name
FROM USERS
WHERE User_id IN (
    SELECT User_id
    FROM RATING
    WHERE Rating = 5
)
FETCH FIRST 20 ROWS ONLY;