set timing on;

CREATE VIEW WITHDRAW_R AS
SELECT "DATE", WITHDRAWAL_AMT
FROM BANK_TRANSACTION;



-- 1) HIGHEST DEBITED AMOUNT IN EACH YEAR--

SELECT EXTRACT(YEAR FROM "DATE") AS Year, MAX(CAST(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '') AS NUMBER)) AS HighestDebitedAmount
FROM WITHDRAW_R
WHERE WITHDRAWAL_AMT IS NOT NULL
GROUP BY EXTRACT(YEAR FROM "DATE");



-- 2) LOWEST DEBITED AMOUNT IN EACH YEAR--

SELECT EXTRACT(YEAR FROM "DATE") AS Year, MIN(CAST(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '') AS NUMBER)) AS LowestDebitedAmount
FROM WITHDRAW_R
WHERE WITHDRAWAL_AMT IS NOT NULL
GROUP BY EXTRACT(YEAR FROM "DATE");



-- 3) 5TH HIGHEST DEBITED AMOUNT IN EACH YEAR

SELECT Year, FifthHighestAmount 
    FROM (
SELECT 
     EXTRACT(YEAR FROM "DATE") AS Year, 
    CAST(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '') AS NUMBER) AS FifthHighestAmount,
    DENSE_RANK() OVER (PARTITION BY EXTRACT(YEAR FROM "DATE") ORDER BY CAST(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '') AS NUMBER) DESC ) AS R
FROM WITHDRAW_R
WHERE CAST(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '') AS NUMBER) IS NOT NULL
)
WHERE R = 5;



-- 4) COUNT OF WITHDRAWAL TRANSACTIONS BETWEEN MAY 5 2018 AND MARCH 7 2019--

SELECT COUNT(CAST(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '') AS NUMBER)) AS WithdrawalCount
FROM WITHDRAW_R
WHERE "DATE" BETWEEN TO_DATE('05-05-2018', 'DD-MM-YYYY') AND TO_DATE('07-03-2019', 'DD-MM-YYYY');



-- 5) FIRST 5 LARGEST WITHDRAWAL TRANSACTION IN YEAR 2018--

SELECT DISTINCT EXTRACT(YEAR FROM "DATE") AS Year, CAST(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '') AS NUMBER) AS Amount
FROM WITHDRAW_R
WHERE EXTRACT(YEAR FROM "DATE") = 2018  AND CAST(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '') AS NUMBER) IS NOT NULL
ORDER BY CAST(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '') AS NUMBER) DESC FETCH FIRST 5 ROWS ONLY;


