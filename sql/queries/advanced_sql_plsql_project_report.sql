-- ============================================================
-- MUSIC STREAMING PLATFORM
-- DA2 PROJECT REPORT - ADVANCED SQL + PL/SQL
-- ============================================================
-- 5 Advanced SQL examples + 5 PL/SQL examples
-- ============================================================

-- ============================================================
-- PART A: ADVANCED SQL
-- ============================================================

-- Q1. VIEW
-- Question:
-- Create a view to display song details along with album
-- and artist information.
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW SONG_ARTIST_VIEW AS
SELECT
    s.Song_id,
    s.Title AS Song_Name,
    al.Title AS Album_Name,
    a.Name AS Artist_Name
FROM SONG s
JOIN ALBUM al ON s.Album_id = al.Album_id
JOIN ARTIST a ON al.Artist_id = a.Artist_id;

PROMPT
PROMPT ===== Q1 RESULT: SONG_ARTIST_VIEW =====

SELECT *
FROM SONG_ARTIST_VIEW
FETCH FIRST 10 ROWS ONLY;


-- Q2. SUBQUERY
-- Question:
-- Display songs whose duration is greater than the average
-- duration of all songs.
-- ------------------------------------------------------------

PROMPT
PROMPT ===== Q2: SUBQUERY - SONGS LONGER THAN AVERAGE =====

SELECT
    Song_id,
    Title,
    Duration
FROM SONG
WHERE Duration > (
    SELECT AVG(Duration)
    FROM SONG
)
FETCH FIRST 20 ROWS ONLY;


-- Q3. JOIN
-- Question:
-- Display song name, album name and artist name by joining
-- SONG, ALBUM and ARTIST tables.
-- ------------------------------------------------------------

PROMPT
PROMPT ===== Q3: JOIN - SONG, ALBUM AND ARTIST =====

SELECT
    s.Title AS Song_Name,
    al.Title AS Album_Name,
    a.Name AS Artist_Name
FROM SONG s
JOIN ALBUM al ON s.Album_id = al.Album_id
JOIN ARTIST a ON al.Artist_id = a.Artist_id
FETCH FIRST 20 ROWS ONLY;


-- Q4. AGGREGATE FUNCTIONS
-- Question:
-- Calculate the total number of ratings and average rating
-- for each song.
-- ------------------------------------------------------------

PROMPT
PROMPT ===== Q4: AGGREGATE - AVERAGE RATING PER SONG =====

SELECT
    Song_id,
    COUNT(*) AS Total_Ratings,
    ROUND(AVG(Rating), 2) AS Average_Rating
FROM RATING
GROUP BY Song_id
ORDER BY Average_Rating DESC
FETCH FIRST 20 ROWS ONLY;


-- Q5. BUSINESS ANALYTICS
-- Question:
-- Identify users who have listened to more than 100 tracks
-- and display their total number of listening records.
-- ------------------------------------------------------------

PROMPT
PROMPT ===== Q5: BUSINESS ANALYTICS - ACTIVE USERS =====

SELECT
    User_id,
    COUNT(*) AS Total_Listens
FROM LISTENING_HISTORY
GROUP BY User_id
HAVING COUNT(*) > 100
ORDER BY Total_Listens DESC
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- PART B: PL/SQL
-- ============================================================

SET SERVEROUTPUT ON;


-- Q6. ANONYMOUS PL/SQL BLOCK
-- Concept: Variables + SELECT INTO + DBMS_OUTPUT
-- Question:
-- Write an anonymous PL/SQL block to display the total
-- number of users in the system.
-- ------------------------------------------------------------

PROMPT
PROMPT ===== Q6: PL/SQL ANONYMOUS BLOCK =====

DECLARE
    total_users NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO total_users
    FROM USERS;

    DBMS_OUTPUT.PUT_LINE('Total Users: ' || total_users);
END;
/


-- Q7. PROCEDURE
-- Concept: Stored Procedure
-- Question:
-- Create a procedure that accepts a User ID and displays
-- the user's name, email and country.
-- ------------------------------------------------------------

PROMPT
PROMPT ===== Q7: PL/SQL PROCEDURE - GET USER DETAILS =====

CREATE OR REPLACE PROCEDURE GET_USER_DETAILS (
    p_user_id IN NUMBER
)
IS
    v_name    USERS.Name%TYPE;
    v_email   USERS.Email%TYPE;
    v_country USERS.Country%TYPE;
BEGIN
    SELECT Name, Email, Country
    INTO v_name, v_email, v_country
    FROM USERS
    WHERE User_id = p_user_id;

    DBMS_OUTPUT.PUT_LINE('User ID: ' || p_user_id);
    DBMS_OUTPUT.PUT_LINE('Name: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Email: ' || v_email);
    DBMS_OUTPUT.PUT_LINE('Country: ' || v_country);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('User not found.');
END;
/

PROMPT
PROMPT ----- Executing GET_USER_DETAILS for User ID 1 -----

EXEC GET_USER_DETAILS(1);


-- Q8. FUNCTION
-- Concept: User-Defined Function
-- Question:
-- Create a function that returns the average rating of
-- a specified song.
-- ------------------------------------------------------------

PROMPT
PROMPT ===== Q8: PL/SQL FUNCTION - GET AVERAGE RATING =====

CREATE OR REPLACE FUNCTION GET_AVERAGE_RATING (
    p_song_id IN NUMBER
)
RETURN NUMBER
IS
    v_avg_rating NUMBER;
BEGIN
    SELECT NVL(AVG(Rating), 0)
    INTO v_avg_rating
    FROM RATING
    WHERE Song_id = p_song_id;

    RETURN v_avg_rating;
END;
/

PROMPT
PROMPT ----- Executing GET_AVERAGE_RATING for Song ID 1 -----

SELECT GET_AVERAGE_RATING(1) AS Average_Rating
FROM DUAL;


-- Q9. EXPLICIT CURSOR
-- Concept: Cursor
-- Question:
-- Use a cursor to display the top 10 artists according to
-- the number of albums they have.
-- ------------------------------------------------------------

PROMPT
PROMPT ===== Q9: PL/SQL EXPLICIT CURSOR =====

DECLARE
    CURSOR artist_cursor IS
        SELECT
            a.Name AS Artist_Name,
            COUNT(al.Album_id) AS Album_Count
        FROM ARTIST a
        JOIN ALBUM al ON a.Artist_id = al.Artist_id
        GROUP BY a.Name
        ORDER BY Album_Count DESC;

    v_count NUMBER := 0;
BEGIN
    FOR artist_record IN artist_cursor LOOP
        v_count := v_count + 1;

        DBMS_OUTPUT.PUT_LINE(
            v_count || '. ' ||
            artist_record.Artist_Name ||
            ' - Albums: ' ||
            artist_record.Album_Count
        );

        EXIT WHEN v_count = 10;
    END LOOP;
END;
/


-- Q10. TRIGGER
-- Concept: Database Trigger
-- Question:
-- Create a trigger that prevents insertion or update of a
-- song when its duration is zero or negative.
-- ------------------------------------------------------------

PROMPT
PROMPT ===== Q10: PL/SQL TRIGGER - VALIDATE SONG DURATION =====

CREATE OR REPLACE TRIGGER TRG_VALIDATE_SONG_DURATION
BEFORE INSERT OR UPDATE ON SONG
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

PROMPT
PROMPT ----- Trigger Status -----

SELECT
    TRIGGER_NAME,
    STATUS
FROM USER_TRIGGERS
WHERE TRIGGER_NAME = 'TRG_VALIDATE_SONG_DURATION';


-- ============================================================
-- END OF ADVANCED SQL + PL/SQL PROJECT REPORT FILE
-- ============================================================
