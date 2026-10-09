SET LINESIZE 180
SET PAGESIZE 100
SET WRAP OFF

PROMPT
PROMPT ========================================
PROMPT Q1. Create a view containing song and artist information
PROMPT ========================================

CREATE OR REPLACE VIEW SONG_ARTIST_VIEW AS
SELECT
    s.Song_id,
    s.Title AS Song_Name,
    ar.Name AS Artist_Name,
    al.Title AS Album_Name,
    s.Duration
FROM SONG s
JOIN ALBUM al
    ON s.Album_id = al.Album_id
JOIN ARTIST ar
    ON al.Artist_id = ar.Artist_id;


PROMPT
PROMPT ========================================
PROMPT Q2. Display data from SONG_ARTIST_VIEW
PROMPT ========================================

SELECT *
FROM SONG_ARTIST_VIEW
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q3. Find songs by a particular artist using the view
PROMPT ========================================

SELECT
    Song_Name,
    Artist_Name,
    Album_Name
FROM SONG_ARTIST_VIEW
WHERE LOWER(Artist_Name) LIKE '%arijit%'
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q4. Create a view containing user rating information
PROMPT ========================================

CREATE OR REPLACE VIEW USER_RATINGS_VIEW AS
SELECT
    u.User_id,
    u.Name AS User_Name,
    s.Title AS Song_Name,
    r.Rating,
    r.Review_text,
    r.Rated_at
FROM USERS u
JOIN RATING r
    ON u.User_id = r.User_id
JOIN SONG s
    ON r.Song_id = s.Song_id;


PROMPT
PROMPT ========================================
PROMPT Q5. Display data from USER_RATINGS_VIEW
PROMPT ========================================

SELECT *
FROM USER_RATINGS_VIEW
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q6. Display highly rated songs using the rating view
PROMPT ========================================

SELECT
    User_Name,
    Song_Name,
    Rating,
    Review_text
FROM USER_RATINGS_VIEW
WHERE Rating >= 4
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q7. Create a view containing user listening history
PROMPT ========================================

CREATE OR REPLACE VIEW LISTENING_HISTORY_VIEW AS
SELECT
    lh.User_id,
    u.Name AS User_Name,
    s.Title AS Song_Name,
    lh.Played_at,
    lh.Duration_played
FROM LISTENING_HISTORY lh
JOIN USERS u
    ON lh.User_id = u.User_id
JOIN SONG s
    ON lh.Song_id = s.Song_id;


PROMPT
PROMPT ========================================
PROMPT Q8. Display data from LISTENING_HISTORY_VIEW
PROMPT ========================================

SELECT *
FROM LISTENING_HISTORY_VIEW
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q9. Display listening history of User 1 using the view
PROMPT ========================================

SELECT
    User_Name,
    Song_Name,
    Played_at,
    Duration_played
FROM LISTENING_HISTORY_VIEW
WHERE User_id = 1
ORDER BY Played_at DESC
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q10. Display the structure of the song-artist view
PROMPT ========================================

DESC SONG_ARTIST_VIEW;


PROMPT
PROMPT ========================================
PROMPT Q11. Display the structure of the user ratings view
PROMPT ========================================

DESC USER_RATINGS_VIEW;


PROMPT
PROMPT ========================================
PROMPT Q12. Display the structure of the listening history view
PROMPT ========================================

DESC LISTENING_HISTORY_VIEW;