-- ============================================================
-- MUSIC STREAMING PLATFORM
-- DA2 PROJECT REPORT - BASIC DDL AND DML
-- ============================================================
-- This file contains:
--   1. Table creation (CREATE TABLE)
--   2. ALTER TABLE
--   3. DESC
--   4. INSERT
--   5. UPDATE
--   6. DELETE
--   7. COMMIT
--   8. ROLLBACK
--
-- NOTE:
-- The project database is already populated. Therefore, the
-- executable DML examples below use a separate DEMO table so
-- that presentation does not modify the actual project data.
-- ============================================================


-- ============================================================
-- PART A: TABLE CREATION / DDL
-- ============================================================

-- Q1. CREATE TABLE
-- Question:
-- Create a table to store demonstration user information.
-- Concept: DDL - CREATE TABLE
-- ------------------------------------------------------------

PROMPT
PROMPT ===== Q1: CREATE TABLE - DDL =====

CREATE TABLE DDL_DML_DEMO (
    Demo_id      NUMBER PRIMARY KEY,
    Demo_name    VARCHAR2(100) NOT NULL,
    Demo_email   VARCHAR2(150) UNIQUE,
    Demo_country VARCHAR2(100)
);


-- Q2. DESCRIBE TABLE
-- Question:
-- Display the structure of the newly created table.
-- Concept: DESCRIBE / DESC
-- ------------------------------------------------------------

PROMPT
PROMPT ===== Q2: DESCRIBE TABLE =====

DESC DDL_DML_DEMO;


-- Q3. ALTER TABLE - ADD COLUMN
-- Question:
-- Add a new column to the demonstration table.
-- Concept: DDL - ALTER TABLE
-- ------------------------------------------------------------

PROMPT
PROMPT ===== Q3: ALTER TABLE - ADD COLUMN =====

ALTER TABLE DDL_DML_DEMO
ADD Demo_status VARCHAR2(20);


-- Q4. ALTER TABLE - MODIFY COLUMN
-- Question:
-- Modify the size of the Demo_status column.
-- Concept: DDL - ALTER TABLE MODIFY
-- ------------------------------------------------------------

PROMPT
PROMPT ===== Q4: ALTER TABLE - MODIFY COLUMN =====

ALTER TABLE DDL_DML_DEMO
MODIFY Demo_status VARCHAR2(30);


-- ============================================================
-- PART B: DML
-- ============================================================

-- Q5. INSERT
-- Question:
-- Insert sample records into the table.
-- Concept: DML - INSERT
-- ------------------------------------------------------------

PROMPT
PROMPT ===== Q5: INSERT - DML =====

INSERT INTO DDL_DML_DEMO
    (Demo_id, Demo_name, Demo_email, Demo_country, Demo_status)
VALUES
    (1, 'Demo User 1', 'demo1@example.com', 'India', 'Active');

INSERT INTO DDL_DML_DEMO
    (Demo_id, Demo_name, Demo_email, Demo_country, Demo_status)
VALUES
    (2, 'Demo User 2', 'demo2@example.com', 'India', 'Active');

SELECT *
FROM DDL_DML_DEMO;


-- Q6. UPDATE
-- Question:
-- Update the status of a demonstration user.
-- Concept: DML - UPDATE
-- ------------------------------------------------------------

PROMPT
PROMPT ===== Q6: UPDATE - DML =====

UPDATE DDL_DML_DEMO
SET Demo_status = 'Premium'
WHERE Demo_id = 1;

SELECT *
FROM DDL_DML_DEMO
WHERE Demo_id = 1;


-- Q7. DELETE
-- Question:
-- Delete a demonstration record.
-- Concept: DML - DELETE
-- ------------------------------------------------------------

PROMPT
PROMPT ===== Q7: DELETE - DML =====

DELETE FROM DDL_DML_DEMO
WHERE Demo_id = 2;

SELECT *
FROM DDL_DML_DEMO;


-- Q8. ROLLBACK
-- Question:
-- Undo the previous DML operations.
-- Concept: TCL - ROLLBACK
--
-- The INSERT, UPDATE and DELETE operations above are undone
-- so the actual database is not left with demonstration data.
-- ------------------------------------------------------------

PROMPT
PROMPT ===== Q8: ROLLBACK - TCL =====

ROLLBACK;

SELECT *
FROM DDL_DML_DEMO;


-- Q9. INSERT + COMMIT
-- Question:
-- Demonstrate how a DML operation can be permanently saved
-- using COMMIT.
--
-- This inserts a final demonstration row and commits it.
-- ------------------------------------------------------------

PROMPT
PROMPT ===== Q9: COMMIT - TCL =====

INSERT INTO DDL_DML_DEMO
    (Demo_id, Demo_name, Demo_email, Demo_country, Demo_status)
VALUES
    (3, 'Committed Demo', 'committed@example.com', 'India', 'Saved');

COMMIT;

SELECT *
FROM DDL_DML_DEMO;


-- Q10. DROP TABLE
-- Question:
-- Remove the demonstration table from the database.
-- Concept: DDL - DROP TABLE
--
-- This is intentionally performed only on the DEMO table.
-- ------------------------------------------------------------

PROMPT
PROMPT ===== Q10: DROP TABLE - DDL =====

DROP TABLE DDL_DML_DEMO;


-- ============================================================
-- PART C: PROJECT TABLE CREATION REFERENCE
-- ============================================================
-- The actual project database contains these 16 tables.
-- Their complete CREATE TABLE definitions are maintained in
-- sql/create_tables.sql.
--
-- 01. USERS
-- 02. PREMIUM_USER
-- 03. FREE_USER
-- 04. ARTIST
-- 05. SINGLE
-- 06. ARTIST_GROUP
-- 07. ALBUM
-- 08. SONG
-- 09. GENRE
-- 10. SONG_GENRE
-- 11. PLAYLIST
-- 12. PLAYLIST_SONG
-- 13. SUBSCRIPTION
-- 14. PAYMENT
-- 15. RATING
-- 16. LISTENING_HISTORY
--
-- The project schema uses:
--   PRIMARY KEY
--   FOREIGN KEY
--   UNIQUE
--   NOT NULL
--   CHECK constraints
-- ============================================================

PROMPT
PROMPT ===== PROJECT DATABASE TABLES =====

SELECT TABLE_NAME
FROM USER_TABLES
ORDER BY TABLE_NAME;


-- ============================================================
-- END OF BASIC DDL AND DML FILE
-- ============================================================
