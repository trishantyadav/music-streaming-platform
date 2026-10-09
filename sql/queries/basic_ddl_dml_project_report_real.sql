-- ============================================================
-- MUSIC STREAMING PLATFORM
-- DA2 PROJECT REPORT - REAL DATABASE DDL + DML
-- ============================================================
-- Uses the ACTUAL project tables in MUSIC_APP.
-- DML demonstrations that change data are rolled back.
-- ============================================================

SET ECHO ON
SET FEEDBACK ON
SET HEADING ON
SET LINESIZE 200
SET PAGESIZE 50
SET WRAP OFF
SET TAB OFF
SET TRIMSPOOL ON
SET SERVEROUTPUT ON

-- ============================================================
-- PART A: ACTUAL PROJECT TABLE / DDL
-- ============================================================

-- Q1. CREATE TABLE - ACTUAL PROJECT TABLE
-- Question:
-- Create the USERS table for the music streaming platform.
--
-- The table already exists in MUSIC_APP, so the actual CREATE
-- statement is displayed as a reference rather than executed.
-- ============================================================

PROMPT
PROMPT ============================================================
PROMPT Q1. CREATE TABLE - USERS (ACTUAL PROJECT TABLE)
PROMPT ============================================================

PROMPT CREATE TABLE USERS (
PROMPT     User_id NUMBER PRIMARY KEY,
PROMPT     Name VARCHAR2(150) NOT NULL,
PROMPT     Email VARCHAR2(150) NOT NULL UNIQUE,
PROMPT     Password VARCHAR2(100) NOT NULL,
PROMPT     Signup_date DATE NOT NULL,
PROMPT     Country VARCHAR2(100)
PROMPT );

PROMPT USERS table already exists in the MUSIC_APP schema.


-- Q2. DESC - ACTUAL PROJECT TABLE
-- Question:
-- Display the structure of the USERS table.
-- ============================================================

PROMPT
PROMPT ============================================================
PROMPT Q2. DESC USERS
PROMPT ============================================================

DESC USERS;


-- Q3. ALTER TABLE - ACTUAL PROJECT TABLE
-- Question:
-- Modify SONG.TITLE to VARCHAR2(300).
-- This was an actual schema modification required by the
-- real project data.
-- ============================================================

PROMPT
PROMPT ============================================================
PROMPT Q3. ALTER TABLE - MODIFY SONG TITLE
PROMPT ============================================================

PROMPT ALTER TABLE SONG MODIFY TITLE VARCHAR2(300);
PROMPT NOTE: This alteration was already performed during project
PROMPT implementation and is not executed again.


-- Q4. SHOW THE ACTUAL PROJECT TABLES
-- Question:
-- Display all tables implemented in the project.
-- ============================================================

PROMPT
PROMPT ============================================================
PROMPT Q4. PROJECT TABLES
PROMPT ============================================================

SELECT TABLE_NAME
FROM USER_TABLES
ORDER BY TABLE_NAME;


-- ============================================================
-- PART B: DML USING ACTUAL PROJECT TABLES
-- ============================================================

-- Q5. INSERT
-- Question:
-- Insert a rating into the actual RATING table.
-- The inserted row is rolled back after demonstration.
-- ============================================================

PROMPT
PROMPT ============================================================
PROMPT Q5. INSERT - ACTUAL RATING TABLE
PROMPT ============================================================

INSERT INTO RATING
    (Rating_id, User_id, Song_id, Rating, Review_text, Rated_at)
SELECT
    (SELECT NVL(MAX(Rating_id), 0) + 1 FROM RATING),
    u.User_id,
    s.Song_id,
    5,
    'Presentation Demo Rating',
    SYSDATE
FROM
    (SELECT User_id FROM USERS WHERE ROWNUM = 1) u,
    (SELECT Song_id FROM SONG WHERE ROWNUM = 1) s
WHERE NOT EXISTS (
    SELECT 1
    FROM RATING r
    WHERE r.User_id = u.User_id
      AND r.Song_id = s.Song_id
);

SELECT Rating_id, User_id, Song_id, Rating, Review_text
FROM RATING
WHERE Review_text = 'Presentation Demo Rating';

ROLLBACK;

PROMPT INSERT demonstration rolled back. Original data preserved.


-- Q6. UPDATE
-- Question:
-- Update an existing user's country in the actual USERS table.
-- The original value is restored with ROLLBACK.
-- ============================================================

PROMPT
PROMPT ============================================================
PROMPT Q6. UPDATE - ACTUAL USERS TABLE
PROMPT ============================================================

SELECT User_id, Name, Country
FROM USERS
WHERE User_id = 1;

UPDATE USERS
SET Country = 'Presentation Demo'
WHERE User_id = 1;

SELECT User_id, Name, Country
FROM USERS
WHERE User_id = 1;

ROLLBACK;

PROMPT UPDATE demonstration rolled back. Original data preserved.


-- Q7. DELETE
-- Question:
-- Delete an existing rating from the actual RATING table.
-- The deletion is rolled back so the original row is restored.
-- ============================================================

PROMPT
PROMPT ============================================================
PROMPT Q7. DELETE - ACTUAL RATING TABLE
PROMPT ============================================================

SELECT Rating_id, User_id, Song_id, Rating
FROM RATING
WHERE Rating_id = 1;

DELETE FROM RATING
WHERE Rating_id = 1;

SELECT Rating_id, User_id, Song_id, Rating
FROM RATING
WHERE Rating_id = 1;

ROLLBACK;

PROMPT DELETE demonstration rolled back. Original rating restored.


-- Q8. COMMIT
-- Question:
-- Demonstrate COMMIT using an actual project table.
-- The UPDATE sets a value to itself, so no project value changes.
-- ============================================================

PROMPT
PROMPT ============================================================
PROMPT Q8. COMMIT - ACTUAL PROJECT TABLE
PROMPT ============================================================

UPDATE USERS
SET Name = Name
WHERE User_id = 1;

COMMIT;

SELECT User_id, Name
FROM USERS
WHERE User_id = 1;


-- Q9. ROLLBACK
-- Question:
-- Demonstrate ROLLBACK on an actual project table.
-- ============================================================

PROMPT
PROMPT ============================================================
PROMPT Q9. ROLLBACK - ACTUAL PROJECT TABLE
PROMPT ============================================================

UPDATE USERS
SET Country = 'Temporary Country'
WHERE User_id = 1;

SELECT User_id, Name, Country
FROM USERS
WHERE User_id = 1;

ROLLBACK;

SELECT User_id, Name, Country
FROM USERS
WHERE User_id = 1;


-- Q10. ACTUAL PROJECT DATA
-- Question:
-- Display representative records from the actual project tables.
-- ============================================================

PROMPT
PROMPT ============================================================
PROMPT Q10. ACTUAL PROJECT DATA
PROMPT ============================================================

PROMPT ----- USERS -----

SELECT User_id, Name, Email, Country
FROM USERS
FETCH FIRST 10 ROWS ONLY;

PROMPT ----- SONGS -----

SELECT Song_id, Title, Duration
FROM SONG
FETCH FIRST 10 ROWS ONLY;

PROMPT ----- RATINGS -----

SELECT Rating_id, User_id, Song_id, Rating, Review_text
FROM RATING
FETCH FIRST 10 ROWS ONLY;


-- ============================================================
-- ACTUAL PROJECT TABLES
-- ============================================================
-- USERS
-- PREMIUM_USER
-- FREE_USER
-- ARTIST
-- SINGLE
-- ARTIST_GROUP
-- ALBUM
-- SONG
-- GENRE
-- SONG_GENRE
-- PLAYLIST
-- PLAYLIST_SONG
-- SUBSCRIPTION
-- PAYMENT
-- RATING
-- LISTENING_HISTORY
-- ============================================================
-- END OF REAL DATABASE DDL + DML PRESENTATION FILE
-- ============================================================
