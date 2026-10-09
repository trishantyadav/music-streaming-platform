SET SERVEROUTPUT ON
SET LINESIZE 150

PROMPT
PROMPT ========================================
PROMPT Q1. Create a procedure to display user details
PROMPT ========================================

CREATE OR REPLACE PROCEDURE SHOW_USER_DETAILS (
    p_user_id IN USERS.User_id%TYPE
)
IS
    v_name USERS.Name%TYPE;
    v_country USERS.Country%TYPE;
BEGIN

    SELECT Name, Country
    INTO v_name, v_country
    FROM USERS
    WHERE User_id = p_user_id;

    DBMS_OUTPUT.PUT_LINE(
        'User: ' || v_name
    );

    DBMS_OUTPUT.PUT_LINE(
        'Country: ' || NVL(v_country, 'Unknown')
    );

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(
            'User not found.'
        );
END;
/


PROMPT
PROMPT ========================================
PROMPT Q2. Execute the user details procedure
PROMPT ========================================

EXEC SHOW_USER_DETAILS(1);


PROMPT
PROMPT ========================================
PROMPT Q3. Create a function to calculate total plays
PROMPT ========================================

CREATE OR REPLACE FUNCTION GET_TOTAL_PLAYS (
    p_user_id IN NUMBER
)
RETURN NUMBER
IS
    v_total NUMBER;
BEGIN

    SELECT COUNT(*)
    INTO v_total
    FROM LISTENING_HISTORY
    WHERE User_id = p_user_id;

    RETURN v_total;

END;
/


PROMPT
PROMPT ========================================
PROMPT Q4. Execute the total plays function
PROMPT ========================================

SELECT
    GET_TOTAL_PLAYS(1) AS TOTAL_PLAYS
FROM DUAL;


PROMPT
PROMPT ========================================
PROMPT Q5. Use an explicit cursor to display user ratings
PROMPT ========================================

DECLARE

    CURSOR rating_cursor IS
        SELECT
            s.Title,
            r.Rating
        FROM RATING r
        JOIN SONG s
            ON r.Song_id = s.Song_id
        WHERE r.User_id = 1
        FETCH FIRST 10 ROWS ONLY;

BEGIN

    FOR rec IN rating_cursor
    LOOP

        DBMS_OUTPUT.PUT_LINE(
            rec.Title || ' -> ' || rec.Rating || '/5'
        );

    END LOOP;

END;
/


PROMPT
PROMPT ========================================
PROMPT Q6. Create an audit table for rating changes
PROMPT ========================================

BEGIN

    EXECUTE IMMEDIATE '
        CREATE TABLE RATING_AUDIT (
            Audit_id NUMBER PRIMARY KEY,
            Rating_id NUMBER,
            Old_Rating NUMBER,
            New_Rating NUMBER,
            Changed_at DATE
        )';

EXCEPTION
    WHEN OTHERS THEN

        IF SQLCODE = -955 THEN
            NULL;
        ELSE
            RAISE;
        END IF;

END;
/


PROMPT
PROMPT ========================================
PROMPT Q7. Create trigger to record rating updates
PROMPT ========================================

CREATE OR REPLACE TRIGGER TRG_RATING_AUDIT
AFTER UPDATE OF Rating ON RATING
FOR EACH ROW

BEGIN

    INSERT INTO RATING_AUDIT (
        Audit_id,
        Rating_id,
        Old_Rating,
        New_Rating,
        Changed_at
    )
    VALUES (
        (
            SELECT NVL(MAX(Audit_id), 0) + 1
            FROM RATING_AUDIT
        ),
        :OLD.Rating_id,
        :OLD.Rating,
        :NEW.Rating,
        SYSDATE
    );

END;
/


PROMPT
PROMPT ========================================
PROMPT Q8. Display rating audit records
PROMPT ========================================

SELECT *
FROM RATING_AUDIT
ORDER BY Audit_id DESC
FETCH FIRST 10 ROWS ONLY;