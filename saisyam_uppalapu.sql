--HIGHEST AMOUNT DEBITED FROM THE BANK IN EACH YEAR

SELECT EXTRACT(YEAR FROM "DATE") AS YEAR,
MAX(CAST(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '') AS NUMBER)) AS HIGHEST_AMOUNT_DEBITED
FROM WITHDRAW_Q
WHERE WITHDRAWAL_AMT IS NOT NULL
GROUP BY EXTRACT(YEAR FROM "DATE");

--LOWEST AMOUNT DEBITED FROM THE BANK IN EACH YEAR

SELECT EXTRACT(YEAR FROM "DATE") AS YEAR,
MIN(CAST(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '') AS NUMBER)) AS LOWEST_AMOUNT_DEBITED
FROM WITHDRAW_Q
WHERE WITHDRAWAL_AMT IS NOT NULL
GROUP BY EXTRACT(YEAR FROM "DATE");

-- 5TH HIGHEST WITHDRAWAL AMOUNT AT EACH YEAR

SELECT YEAR,FIFTH_HIGHEST_WITHDRAWAL_AMOUNT
FROM (
    SELECT EXTRACT(YEAR FROM "DATE") AS YEAR,
    CAST(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '') AS NUMBER) AS FIFTH_HIGHEST_WITHDRAWAL_AMOUNT,
    DENSE_RANK() OVER(PARTITION BY EXTRACT(YEAR FROM "DATE") ORDER BY
    CAST(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '') AS NUMBER) DESC) AS R 
    FROM WITHDRAW_Q
    WHERE CAST(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '') AS NUMBER) IS NOT NULL 
)
WHERE R=5;

--TO COUNT THE WITHDRAWAL TRANSACTIONS BETWEEN MAY 5,2018 AND MARCH 7,2019

SELECT COUNT(CAST(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '') AS NUMBER)) AS WITHDRAWAL_COUNT
FROM WITHDRAW_Q
WHERE "DATE" BETWEEN TO_DATE('05-05-2018', 'DD-MM-YYYY') AND TO_DATE('07-03-2019', 'DD-MM-YYYY');

--THE FIRST FIVE LARGEST WITHDRAWAL TRANSACTIONS ARE OCCURED IN YEAR 18

SELECT DISTINCT EXTRACT(YEAR FROM "DATE") AS YEAR,
CAST(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '') AS NUMBER) AS FIRST_FIVE_LARGEST_WITHDRAWAL_TRANSACTIONS
FROM WITHDRAW_Q
WHERE EXTRACT(YEAR FROM "DATE") = 2018 AND
CAST(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '') AS NUMBER) IS NOT NULL
ORDER BY CAST(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '') AS NUMBER)
DESC FETCH FIRST 5 ROWS ONLY;   























