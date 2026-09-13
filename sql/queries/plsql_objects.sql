-- ============================================================
-- MUSIC STREAMING PLATFORM
-- DA2 - PL/SQL PROCEDURES, FUNCTIONS, CURSORS AND TRIGGERS
-- ============================================================

SET SERVEROUTPUT ON
SET LINESIZE 180;


-- ============================================================
-- 1. STORED PROCEDURE
-- Display complete information about a user
-- ============================================================

CREATE OR REPLACE PROCEDURE GET_USER_DETAILS (
    p_user_id IN USERS.User_id%TYPE
)
IS
    v_name      USERS.Name%TYPE;
    v_email     USERS.Email%TYPE;
    v_country   USERS.Country%TYPE;
BEGIN
    SELECT Name, Email, Country
    INTO v_name, v_email, v_country
    FROM USERS
    WHERE User_id = p_user_id;

    DBMS_OUTPUT.PUT_LINE('User ID : ' || p_user_id);
    DBMS_OUTPUT.PUT_LINE('Name    : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Email   : ' || v_email);
    DBMS_OUTPUT.PUT_LINE('Country : ' || v_country);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('User not found.');
END;
/


-- Execute procedure
EXEC GET_USER_DETAILS(1);


-- ============================================================
-- 2. STORED PROCEDURE
-- Display listening statistics for a user
-- ============================================================

CREATE OR REPLACE PROCEDURE GET_USER_LISTENING_STATS (
    p_user_id IN USERS.User_id%TYPE
)
IS
    v_total_plays NUMBER;
    v_total_time  NUMBER;
BEGIN
    SELECT
        COUNT(*),
        NVL(SUM(Duration_played), 0)
    INTO
        v_total_plays,
        v_total_time
    FROM LISTENING_HISTORY
    WHERE User_id = p_user_id;

    DBMS_OUTPUT.PUT_LINE('User ID: ' || p_user_id);
    DBMS_OUTPUT.PUT_LINE('Total Plays: ' || v_total_plays);
    DBMS_OUTPUT.PUT_LINE(
        'Total Listening Time: ' ||
        ROUND(v_total_time / 60000, 2) ||
        ' minutes'
    );
END;
/


-- Execute procedure
EXEC GET_USER_LISTENING_STATS(1);


-- ============================================================
-- 3. USER-DEFINED FUNCTION
-- Calculate average rating of a song
-- ============================================================

CREATE OR REPLACE FUNCTION GET_AVERAGE_RATING (
    p_song_id IN SONG.Song_id%TYPE
)
RETURN NUMBER
IS
    v_average_rating NUMBER;
BEGIN
    SELECT NVL(AVG(Rating), 0)
    INTO v_average_rating
    FROM RATING
    WHERE Song_id = p_song_id;

    RETURN ROUND(v_average_rating, 2);
END;
/


-- Test function
SELECT
    Song_id,
    Title,
    GET_AVERAGE_RATING(Song_id) AS Average_Rating
FROM SONG
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 4. USER-DEFINED FUNCTION
-- Calculate total listening minutes for a user
-- ============================================================

CREATE OR REPLACE FUNCTION GET_LISTENING_MINUTES (
    p_user_id IN USERS.User_id%TYPE
)
RETURN NUMBER
IS
    v_total_ms NUMBER;
BEGIN
    SELECT NVL(SUM(Duration_played), 0)
    INTO v_total_ms
    FROM LISTENING_HISTORY
    WHERE User_id = p_user_id;

    RETURN ROUND(v_total_ms / 60000, 2);
END;
/


-- Test function
SELECT
    User_id,
    Name,
    GET_LISTENING_MINUTES(User_id) AS Total_Minutes
FROM USERS
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 5. EXPLICIT CURSOR
-- Display top 10 artists by number of albums
-- ============================================================

DECLARE

    CURSOR artist_cursor IS
        SELECT
            ar.Name AS Artist_Name,
            COUNT(al.Album_id) AS Album_Count
        FROM ARTIST ar
        LEFT JOIN ALBUM al
            ON ar.Artist_id = al.Artist_id
        GROUP BY ar.Artist_id, ar.Name
        ORDER BY Album_Count DESC
        FETCH FIRST 10 ROWS ONLY;

BEGIN

    FOR artist_rec IN artist_cursor
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            artist_rec.Artist_Name ||
            ' -> ' ||
            artist_rec.Album_Count ||
            ' albums'
        );
    END LOOP;

END;
/


-- ============================================================
-- 6. EXPLICIT CURSOR
-- Display top 10 most listened songs
-- ============================================================

DECLARE

    CURSOR song_cursor IS
        SELECT
            s.Title AS Song_Name,
            COUNT(*) AS Play_Count
        FROM SONG s
        JOIN LISTENING_HISTORY lh
            ON s.Song_id = lh.Song_id
        GROUP BY s.Song_id, s.Title
        ORDER BY Play_Count DESC
        FETCH FIRST 10 ROWS ONLY;

BEGIN

    FOR song_rec IN song_cursor
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            song_rec.Song_Name ||
            ' -> ' ||
            song_rec.Play_Count ||
            ' plays'
        );
    END LOOP;

END;
/


-- ============================================================
-- 7. CURSOR WITH USER DATA
-- Display premium users
-- ============================================================

DECLARE

    CURSOR premium_cursor IS
        SELECT
            u.User_id,
            u.Name,
            su.Plan_type
        FROM USERS u
        JOIN PREMIUM_USER pu
            ON u.User_id = pu.User_id
        JOIN SUBSCRIPTION su
            ON pu.User_id = su.User_id
        FETCH FIRST 10 ROWS ONLY;

BEGIN

    FOR user_rec IN premium_cursor
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            user_rec.User_id ||
            ' - ' ||
            user_rec.Name ||
            ' - ' ||
            user_rec.Plan_type
        );
    END LOOP;

END;
/


-- ============================================================
-- 8. TRIGGER
-- Prevent invalid song duration
-- ============================================================

CREATE OR REPLACE TRIGGER TRG_VALIDATE_SONG_DURATION
BEFORE INSERT OR UPDATE OF Duration
ON SONG
FOR EACH ROW
BEGIN

    IF :NEW.Duration <= 0 THEN

        RAISE_APPLICATION_ERROR(
            -20001,
            'Song duration must be greater than zero.'
        );

    END IF;

END;
/


-- ============================================================
-- Test trigger
-- This should fail intentionally
-- ============================================================

BEGIN

    INSERT INTO SONG (
        Song_id,
        Album_id,
        Title,
        Duration,
        Spotify_track_uri
    )
    VALUES (
        999999,
        1,
        'Trigger Test Song',
        0,
        'spotify:track:test'
    );

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(
            'Trigger Test: ' || SQLERRM
        );

END;
/


-- ============================================================
-- 9. TRIGGER
-- Prevent invalid rating values
-- ============================================================

CREATE OR REPLACE TRIGGER TRG_VALIDATE_RATING
BEFORE INSERT OR UPDATE OF Rating
ON RATING
FOR EACH ROW
BEGIN

    IF :NEW.Rating < 1 OR :NEW.Rating > 5 THEN

        RAISE_APPLICATION_ERROR(
            -20002,
            'Rating must be between 1 and 5.'
        );

    END IF;

END;
/


-- ============================================================
-- 10. TRIGGER
-- Automatically set Rated_at if not supplied
-- ============================================================

CREATE OR REPLACE TRIGGER TRG_RATING_DATE
BEFORE INSERT
ON RATING
FOR EACH ROW
BEGIN

    IF :NEW.Rated_at IS NULL THEN
        :NEW.Rated_at := SYSDATE;
    END IF;

END;
/


-- ============================================================
-- Display created procedures/functions/triggers
-- ============================================================

SELECT
    OBJECT_NAME,
    OBJECT_TYPE,
    STATUS
FROM USER_OBJECTS
WHERE OBJECT_TYPE IN ('PROCEDURE', 'FUNCTION', 'TRIGGER')
ORDER BY OBJECT_TYPE, OBJECT_NAME;