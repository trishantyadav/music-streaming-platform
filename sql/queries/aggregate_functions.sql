SET LINESIZE 150
SET PAGESIZE 100
SET WRAP OFF

PROMPT
PROMPT ========================================
PROMPT Q1. Find the total number of users
PROMPT ========================================

SELECT COUNT(*) AS TOTAL_USERS
FROM USERS;


PROMPT
PROMPT ========================================
PROMPT Q2. Find the total number of songs
PROMPT ========================================

SELECT COUNT(*) AS TOTAL_SONGS
FROM SONG;


PROMPT
PROMPT ========================================
PROMPT Q3. Find the total number of listening records
PROMPT ========================================

SELECT COUNT(*) AS TOTAL_LISTENING_RECORDS
FROM LISTENING_HISTORY;


PROMPT
PROMPT ========================================
PROMPT Q4. Find the total number of artists
PROMPT ========================================

SELECT COUNT(*) AS TOTAL_ARTISTS
FROM ARTIST;


PROMPT
PROMPT ========================================
PROMPT Q5. Find the average duration of all songs in minutes
PROMPT ========================================

SELECT ROUND(AVG(Duration) / 60000, 2) AS AVERAGE_DURATION_MINUTES
FROM SONG;


PROMPT
PROMPT ========================================
PROMPT Q6. Find the shortest and longest song duration in minutes
PROMPT ========================================

SELECT
    ROUND(MIN(Duration) / 60000, 2) AS SHORTEST_MINUTES,
    ROUND(MAX(Duration) / 60000, 2) AS LONGEST_MINUTES
FROM SONG;


PROMPT
PROMPT ========================================
PROMPT Q7. Find the total payment amount
PROMPT ========================================

SELECT ROUND(SUM(Amount), 2) AS TOTAL_PAYMENT_AMOUNT
FROM PAYMENT;


PROMPT
PROMPT ========================================
PROMPT Q8. Find the average payment amount
PROMPT ========================================

SELECT ROUND(AVG(Amount), 2) AS AVERAGE_PAYMENT
FROM PAYMENT;


PROMPT
PROMPT ========================================
PROMPT Q9. Find the minimum and maximum payment amount
PROMPT ========================================

SELECT
    MIN(Amount) AS MINIMUM_PAYMENT,
    MAX(Amount) AS MAXIMUM_PAYMENT
FROM PAYMENT;


PROMPT
PROMPT ========================================
PROMPT Q10. Count the number of songs in each album
PROMPT ========================================

SELECT
    Album_id,
    COUNT(*) AS NUMBER_OF_SONGS
FROM SONG
GROUP BY Album_id
ORDER BY NUMBER_OF_SONGS DESC
FETCH FIRST 15 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q11. Count the number of albums for each artist
PROMPT ========================================

SELECT
    Artist_id,
    COUNT(*) AS NUMBER_OF_ALBUMS
FROM ALBUM
GROUP BY Artist_id
ORDER BY NUMBER_OF_ALBUMS DESC
FETCH FIRST 15 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q12. Find artists having more than 5 songs
PROMPT ========================================

SELECT
    a.Artist_id,
    a.Name AS ARTIST_NAME,
    COUNT(s.Song_id) AS NUMBER_OF_SONGS
FROM ARTIST a
JOIN ALBUM al
    ON a.Artist_id = al.Artist_id
JOIN SONG s
    ON al.Album_id = s.Album_id
GROUP BY a.Artist_id, a.Name
HAVING COUNT(s.Song_id) > 5
ORDER BY NUMBER_OF_SONGS DESC;


PROMPT
PROMPT ========================================
PROMPT Q13. Find the total listening time in minutes
PROMPT ========================================

SELECT ROUND(SUM(Duration_played) / 60000, 2)
       AS TOTAL_LISTENING_MINUTES
FROM LISTENING_HISTORY;


PROMPT
PROMPT ========================================
PROMPT Q14. Find the average listening duration in minutes
PROMPT ========================================

SELECT ROUND(AVG(Duration_played) / 60000, 2)
       AS AVERAGE_LISTENING_MINUTES
FROM LISTENING_HISTORY;


PROMPT
PROMPT ========================================
PROMPT Q15. Find the number of songs listened to by each user
PROMPT ========================================

SELECT
    User_id,
    COUNT(*) AS SONGS_LISTENED
FROM LISTENING_HISTORY
GROUP BY User_id
ORDER BY SONGS_LISTENED DESC
FETCH FIRST 15 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q16. Find users with more than 100 listening records
PROMPT ========================================

SELECT
    User_id,
    COUNT(*) AS LISTENING_COUNT
FROM LISTENING_HISTORY
GROUP BY User_id
HAVING COUNT(*) > 100
ORDER BY LISTENING_COUNT DESC;


PROMPT
PROMPT ========================================
PROMPT Q17. Find the average rating given by users
PROMPT ========================================

SELECT ROUND(AVG(Rating), 2) AS AVERAGE_RATING
FROM RATING;


PROMPT
PROMPT ========================================
PROMPT Q18. Find the highest rating given to each song
PROMPT ========================================

SELECT
    Song_id,
    MAX(Rating) AS HIGHEST_RATING
FROM RATING
GROUP BY Song_id
ORDER BY Song_id
FETCH FIRST 15 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q19. Find the number of ratings for each rating value
PROMPT ========================================

SELECT
    Rating,
    COUNT(*) AS NUMBER_OF_RATINGS
FROM RATING
GROUP BY Rating
ORDER BY Rating;


PROMPT
PROMPT ========================================
PROMPT Q20. Find artists with more than one album
PROMPT ========================================

SELECT
    Artist_id,
    COUNT(*) AS NUMBER_OF_ALBUMS
FROM ALBUM
GROUP BY Artist_id
HAVING COUNT(*) > 1
ORDER BY NUMBER_OF_ALBUMS DESC;