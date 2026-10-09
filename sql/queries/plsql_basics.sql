SET SERVEROUTPUT ON
SET LINESIZE 150

PROMPT
PROMPT ========================================
PROMPT Q1. Use IF-ELSE to identify Premium or Free user
PROMPT ========================================

DECLARE
    v_user_id USERS.User_id%TYPE := 1;
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM PREMIUM_USER
    WHERE User_id = v_user_id;

    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('User ' || v_user_id || ' is Premium.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('User ' || v_user_id || ' is Free.');
    END IF;
END;
/


PROMPT
PROMPT ========================================
PROMPT Q2. Use a FOR LOOP to display first 5 users
PROMPT ========================================

BEGIN
    FOR rec IN (
        SELECT User_id, Name
        FROM USERS
        ORDER BY User_id
        FETCH FIRST 5 ROWS ONLY
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            rec.User_id || ' - ' || rec.Name
        );
    END LOOP;
END;
/


PROMPT
PROMPT ========================================
PROMPT Q3. Use CASE to classify ratings
PROMPT ========================================

DECLARE
    v_rating NUMBER := 5;
BEGIN
    CASE
        WHEN v_rating = 5 THEN
            DBMS_OUTPUT.PUT_LINE('Excellent rating');
        WHEN v_rating >= 3 THEN
            DBMS_OUTPUT.PUT_LINE('Good rating');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Low rating');
    END CASE;
END;
/


PROMPT
PROMPT ========================================
PROMPT Q4. Use a WHILE LOOP
PROMPT ========================================

DECLARE
    v_counter NUMBER := 1;
BEGIN
    WHILE v_counter <= 5
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Iteration: ' || v_counter
        );

        v_counter := v_counter + 1;
    END LOOP;
END;
/