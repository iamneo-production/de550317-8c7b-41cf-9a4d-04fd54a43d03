CREATE VIEW BANK_DATABASE_VIEW AS
SELECT EXTRACT(YEAR FROM "DATE") AS YEAR,
CAST(REGEXP_REPLACE(WITHDRAWAL_AMT,'[^0-9.]','') AS NUMBER)
AS BANK_AMOUNT
FROM BANK_TRANSACTION WHERE WITHDRAWAL_AMT IS NOT NULL;

-- CREATING view
CREATE VIEW WITHDRAWAL_VIEW AS SELECT "DATE",WITHDRAWAL_AMT FROM BANK_TRANSACTION;

--CREATING INDEX

/* CREATE INDEX WITHDRAWAL_INDEX.
ON BANK_TRANSACTION ("DATE", WITHDRAWAL_AMT); */

-- HIGHEST AMOUNT DEBITED FROM THE BANK IN EACH YEAR.

SELECT YEAR,MAX(BANK_AMOUNT) AS HIGHEST_AMOUNT_DEBITED
FROM BANK_DATABASE_VIEW
GROUP BY YEAR;

-- LOWEST AMOUNT DEBITED FROM THE BANK IN EACH YEAR. 

SELECT YEAR, MAX(BANK_AMOUNT) AS LOWEST_AMOUNT_DEBITED 
FROM BANK_DATABASE_VIEW
GROUP BY YEAR;

-- 5TH HIGEST WITHDRAWAL AMOUNT AT EACH YEAR

SELECT YEAR,FIFTH_HIGHEST_WITHDRAWAL_AMOUNT FROM 
(SELECT YEAR,BANK_AMOUNT AS FIFTH_HIGHEST_WITHDRAWAL_AMOUNT,
DENSE_RANK() OVER (PARTITION BY YEAR ORDER BY 
BANK_AMOUNT DESC) AS R
FROM BANK_DATABASE_VIEW
)
WHERE R=5;

--TO COUNT THE WITHDRAWAL TRANSACTIONS BETWEEN MAY 5,2018 AND MARCH 7,2019

SELECT COUNT(CAST(REGEXP_REPLACE(WITHDRAWAL_AMT,'[^0-9.]') AS NUMBER))
AS WITHDRAWAL_COUNT FROM WITHDRAW_Q
WHERE "DATE" BETWEEN TO_DATE('05-05-2018','DD-MM-YYYY') 
AND TO_DATE ('07-03-2019','DD-MM-YYYY');


--THE FIRST FIVE LARGEST WITHDRAWAL TRANSACTION ARE OCCURED IN YEAR 18

SELECT DISTINCT YEAR,BANK_AMOUNT AS FIRST_FIVE_LARGEST_WITHDRAWAL_TRANSACTIONS FROM BANK_DATABASE_VIEW
WHERE YEAR=2018 ORDER BY BANK_AMOUNT
DESC FETCH FIRST 5 ROWS ONLY;
