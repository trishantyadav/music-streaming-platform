-- ============================================================
-- MUSIC STREAMING PLATFORM
-- DA2 - PL/SQL BASICS AND CONTROL STRUCTURES
-- ============================================================

SET SERVEROUTPUT ON
SET LINESIZE 180


-- ============================================================
-- 1. BASIC PL/SQL BLOCK
-- Display total number of users
-- ============================================================

DECLARE
    v_user_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_user_count
    FROM USERS;

    DBMS_OUTPUT.PUT_LINE(
        'Total Users: ' || v_user_count
    );
END;
/
/


-- ============================================================
-- 2. VARIABLES
-- Calculate average song duration
-- ============================================================

DECLARE
    v_avg_duration NUMBER;
BEGIN
    SELECT AVG(Duration)
    INTO v_avg_duration
    FROM SONG;

    DBMS_OUTPUT.PUT_LINE(
        'Average Song Duration: ' ||
        ROUND(v_avg_duration / 60000, 2) ||
        ' minutes'
    );
END;
/
/


-- ============================================================
-- 3. IF CONDITION
-- Check whether a user is Premium
-- ============================================================

DECLARE
    v_user_id NUMBER := 1;
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM PREMIUM_USER
    WHERE User_id = v_user_id;

    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE(
            'User ' || v_user_id || ' is a Premium User.'
        );
    ELSE
        DBMS_OUTPUT.PUT_LINE(
            'User ' || v_user_id || ' is a Free User.'
        );
    END IF;
END;
/
/


-- ============================================================
-- 4. IF / ELSIF / ELSE
-- Categorize a song based on duration
-- ============================================================

DECLARE
    v_duration NUMBER;
    v_song_id NUMBER := 1;
BEGIN
    SELECT Duration
    INTO v_duration
    FROM SONG
    WHERE Song_id = v_song_id;

    IF v_duration < 120000 THEN
        DBMS_OUTPUT.PUT_LINE('Short Song');
    ELSIF v_duration <= 300000 THEN
        DBMS_OUTPUT.PUT_LINE('Medium Length Song');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Long Song');
    END IF;
END;
/
/


-- ============================================================
-- 5. CASE STATEMENT
-- Categorize subscription plans
-- ============================================================

DECLARE
    v_plan SUBSCRIPTION.Plan_type%TYPE;
BEGIN
    SELECT Plan_type
    INTO v_plan
    FROM SUBSCRIPTION
    WHERE Subscription_id = 1;

    CASE v_plan
        WHEN 'Monthly' THEN
            DBMS_OUTPUT.PUT_LINE('Monthly Subscription');
        WHEN 'Quarterly' THEN
            DBMS_OUTPUT.PUT_LINE('Quarterly Subscription');
        WHEN 'Annual' THEN
            DBMS_OUTPUT.PUT_LINE('Annual Subscription');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Unknown Subscription');
    END CASE;
END;
/
/


-- ============================================================
-- 6. SIMPLE LOOP
-- Display numbers from 1 to 5
-- ============================================================

DECLARE
    v_counter NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Counter: ' || v_counter
        );

        v_counter := v_counter + 1;

        EXIT WHEN v_counter > 5;
    END LOOP;
END;
/
/


-- ============================================================
-- 7. WHILE LOOP
-- Display numbers from 1 to 5
-- ============================================================

DECLARE
    v_counter NUMBER := 1;
BEGIN
    WHILE v_counter <= 5
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Counter: ' || v_counter
        );

        v_counter := v_counter + 1;
    END LOOP;
END;
/
/


-- ============================================================
-- 8. FOR LOOP
-- Display numbers from 1 to 5
-- ============================================================

BEGIN
    FOR i IN 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Number: ' || i
        );
    END LOOP;
END;
/
/


-- ============================================================
-- 9. FOR LOOP WITH DATABASE DATA
-- Display first 10 artists
-- ============================================================

BEGIN
    FOR artist_rec IN (
        SELECT Artist_id, Name
        FROM ARTIST
        ORDER BY Artist_id
        FETCH FIRST 10 ROWS ONLY
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            artist_rec.Artist_id || ' - ' ||
            artist_rec.Name
        );
    END LOOP;
END;
/
/


-- ============================================================
-- 10. SELECT INTO
-- Retrieve a specific user's information
-- ============================================================

DECLARE
    v_name USERS.Name%TYPE;
    v_country USERS.Country%TYPE;
BEGIN
    SELECT Name, Country
    INTO v_name, v_country
    FROM USERS
    WHERE User_id = 1;

    DBMS_OUTPUT.PUT_LINE(
        'Name: ' || v_name
    );

    DBMS_OUTPUT.PUT_LINE(
        'Country: ' || v_country
    );
END;
/
/


-- ============================================================
-- 11. %TYPE ATTRIBUTE
-- Use column datatype automatically
-- ============================================================

DECLARE
    v_song_title SONG.Title%TYPE;
    v_duration SONG.Duration%TYPE;
BEGIN
    SELECT Title, Duration
    INTO v_song_title, v_duration
    FROM SONG
    WHERE Song_id = 1;

    DBMS_OUTPUT.PUT_LINE(
        'Song: ' || v_song_title
    );

    DBMS_OUTPUT.PUT_LINE(
        'Duration: ' ||
        ROUND(v_duration / 60000, 2) ||
        ' minutes'
    );
END;
/
/


-- ============================================================
-- 12. RECORD
-- Store multiple song attributes
-- ============================================================

DECLARE
    v_song SONG%ROWTYPE;
BEGIN
    SELECT *
    INTO v_song
    FROM SONG
    WHERE Song_id = 1;

    DBMS_OUTPUT.PUT_LINE(
        'Song ID: ' || v_song.Song_id
    );

    DBMS_OUTPUT.PUT_LINE(
        'Title: ' || v_song.Title
    );

    DBMS_OUTPUT.PUT_LINE(
        'Duration: ' ||
        ROUND(v_song.Duration / 60000, 2) ||
        ' minutes'
    );
END;
/
/


-- ============================================================
-- 13. EXCEPTION HANDLING
-- Handle invalid User ID
-- ============================================================

DECLARE
    v_name USERS.Name%TYPE;
BEGIN
    SELECT Name
    INTO v_name
    FROM USERS
    WHERE User_id = -9999;

    DBMS_OUTPUT.PUT_LINE(
        'User: ' || v_name
    );

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(
            'No user found with the given ID.'
        );

    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE(
            'Multiple users found.'
        );
END;
/
/


-- ============================================================
-- 14. AGGREGATE FUNCTION IN PL/SQL
-- Calculate total revenue from successful payments
-- ============================================================

DECLARE
    v_revenue NUMBER;
BEGIN
    SELECT NVL(SUM(Amount), 0)
    INTO v_revenue
    FROM PAYMENT
    WHERE Status = 'Success';

    DBMS_OUTPUT.PUT_LINE(
        'Total Successful Revenue: Rs. ' ||
        ROUND(v_revenue, 2)
    );
END;
/
/


-- ============================================================
-- 15. CONDITIONAL ANALYSIS
-- Determine whether listening activity is high
-- ============================================================

DECLARE
    v_total_plays NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_total_plays
    FROM LISTENING_HISTORY;

    IF v_total_plays > 100000 THEN
        DBMS_OUTPUT.PUT_LINE(
            'Platform has HIGH listening activity.'
        );
    ELSIF v_total_plays > 50000 THEN
        DBMS_OUTPUT.PUT_LINE(
            'Platform has MODERATE listening activity.'
        );
    ELSE
        DBMS_OUTPUT.PUT_LINE(
            'Platform has LOW listening activity.'
        );
    END IF;
END;
/