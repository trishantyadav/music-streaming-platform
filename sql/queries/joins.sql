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
PROMPT Q3. Create a view for user rating information
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
PROMPT Q4. Display user ratings using the view
PROMPT ========================================

SELECT *
FROM USER_RATINGS_VIEW
FETCH FIRST 20 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q5. Create a view for listening history
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
PROMPT Q6. Display listening history using the view
PROMPT ========================================

SELECT *
FROM LISTENING_HISTORY_VIEW
FETCH FIRST 20 ROWS ONLY;