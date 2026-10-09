SET LINESIZE 150
SET PAGESIZE 100
SET WRAP OFF

PROMPT
PROMPT ========================================
PROMPT Q1. Convert artist names to uppercase
PROMPT ========================================

SELECT Name, UPPER(Name) AS UPPER_NAME
FROM ARTIST
FETCH FIRST 10 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q2. Convert artist names to lowercase
PROMPT ========================================

SELECT Name, LOWER(Name) AS LOWER_NAME
FROM ARTIST
FETCH FIRST 10 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q3. Convert song titles to proper case
PROMPT ========================================

SELECT Title, INITCAP(Title) AS FORMATTED_TITLE
FROM SONG
FETCH FIRST 10 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q4. Find the length of song titles
PROMPT ========================================

SELECT Title, LENGTH(Title) AS TITLE_LENGTH
FROM SONG
FETCH FIRST 10 ROWS ONLY;


PROMPT
PROMPT ==================================================
PROMPT Q5. Extract the first 10 characters of song titles
PROMPT ==================================================

SELECT Title, SUBSTR(Title, 1, 10) AS FIRST_10_CHARACTERS
FROM SONG
FETCH FIRST 10 ROWS ONLY;


PROMPT
PROMPT =================================================
PROMPT Q6. Find the position of letter A in artist names
PROMPT =================================================

SELECT Name, INSTR(UPPER(Name), 'A') AS POSITION_OF_A
FROM ARTIST
FETCH FIRST 10 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q7. Concatenate artist name and country
PROMPT ========================================

SELECT
    Name,
    Country,
    CONCAT(Name, ' - ' || Country) AS ARTIST_LOCATION
FROM ARTIST
FETCH FIRST 10 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q8. Round song duration in seconds
PROMPT ========================================

SELECT
    Title,
    ROUND(Duration / 1000) AS DURATION_SECONDS
FROM SONG
FETCH FIRST 10 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q9. Truncate song duration to seconds
PROMPT ========================================

SELECT
    Title,
    TRUNC(Duration / 1000) AS DURATION_SECONDS
FROM SONG
FETCH FIRST 10 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q10. Find remainder using MOD()
PROMPT ========================================

SELECT
    Song_id,
    MOD(Song_id, 2) AS ID_REMAINDER
FROM SONG
FETCH FIRST 10 ROWS ONLY;


PROMPT
PROMPT ============================================
PROMPT Q11. Replace NULL country values using NVL()
PROMPT ============================================

SELECT
    Name,
    NVL(Country, 'Unknown') AS COUNTRY
FROM ARTIST
FETCH FIRST 10 ROWS ONLY;


PROMPT
PROMPT =============================================
PROMPT Q12. Use NVL2() to check country availability
PROMPT =============================================

SELECT
    Name,
    NVL2(Country, 'Country Available', 'Country Missing') AS COUNTRY_STATUS
FROM ARTIST
FETCH FIRST 10 ROWS ONLY;


PROMPT
PROMPT ===============================================
PROMPT Q13. Display signup dates in DD-MON-YYYY format
PROMPT ===============================================

SELECT
    Name,
    TO_CHAR(Signup_date, 'DD-MON-YYYY') AS SIGNUP_DATE
FROM USERS
FETCH FIRST 10 ROWS ONLY;


PROMPT
PROMPT =====================================================
PROMPT Q14. Display payment amounts with currency formatting
PROMPT =====================================================

SELECT
    Payment_id,
    TO_CHAR(Amount, '999,999.00') AS FORMATTED_AMOUNT
FROM PAYMENT
FETCH FIRST 10 ROWS ONLY;


PROMPT
PROMPT ========================================
PROMPT Q15. Convert a string into a date
PROMPT ========================================

SELECT
    TO_DATE('13-SEP-2026', 'DD-MON-YYYY') AS CONVERTED_DATE
FROM DUAL;


PROMPT
PROMPT =============================================
PROMPT Q16. Add 3 months to subscription start dates
PROMPT =============================================

SELECT
    Subscription_id,
    Start_date,
    ADD_MONTHS(Start_date, 3) AS DATE_AFTER_3_MONTHS
FROM SUBSCRIPTION
FETCH FIRST 10 ROWS ONLY;


PROMPT
PROMPT ===========================================
PROMPT Q17. Find months between subscription dates
PROMPT ===========================================

SELECT
    Subscription_id,
    ROUND(MONTHS_BETWEEN(End_date, Start_date), 2)
        AS SUBSCRIPTION_MONTHS
FROM SUBSCRIPTION
FETCH FIRST 10 ROWS ONLY;


PROMPT
PROMPT ======================================================
PROMPT Q18. Find the last day of the subscription start month
PROMPT ======================================================

SELECT
    Subscription_id,
    Start_date,
    LAST_DAY(Start_date) AS LAST_DAY_OF_MONTH
FROM SUBSCRIPTION
FETCH FIRST 10 ROWS ONLY;


PROMPT
PROMPT ===============================================
PROMPT Q19. Display the current database date and time
PROMPT ===============================================

SELECT SYSDATE AS CURRENT_DATABASE_DATE
FROM DUAL;


PROMPT
PROMPT =======================================================
PROMPT Q20. Convert song duration from milliseconds to minutes
PROMPT =======================================================

SELECT
    Title,
    ROUND(Duration / 60000, 2) AS DURATION_MINUTES
FROM SONG
FETCH FIRST 10 ROWS ONLY;