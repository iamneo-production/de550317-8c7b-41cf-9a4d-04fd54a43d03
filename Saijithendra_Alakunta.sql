set timing on;

CREATE VIEW BANK_SYSTEM_VIEW AS
SELECT EXTRACT(YEAR FROM "DATE") AS Year,
       CAST(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '') AS NUMBER) AS WithdrawalAmtCleaned
FROM BANK_TRANSACTION
WHERE WITHDRAWAL_AMT IS NOT NULL;

CREATE VIEW WITHDRAW_R AS
SELECT "DATE", WITHDRAWAL_AMT
FROM BANK_TRANSACTION;

/*CREATE INDEX WITHDRAW_INDEX ON 
BANK_TRANSACTION ("DATE", WITHDRAWAL_AMT);*/

-- Query 1: Highest Amount Debited per Year

SELECT Year,
       MAX(WithdrawalAmtCleaned) AS HighestAmountDebited
FROM BANK_SYSTEM_VIEW
GROUP BY Year;


-- Query 2: Lowest Amount Debited per Year

SELECT Year,
       MIN(WithdrawalAmtCleaned) AS LowestAmountDebited
FROM BANK_SYSTEM_VIEW
GROUP BY Year;


-- Query 3: Fifth Highest Amount Debited per Year

SELECT Year, FifthHighestAmount
FROM (
  SELECT Year, WithdrawalAmtCleaned AS FifthHighestAmount,
         DENSE_RANK() OVER (PARTITION BY Year ORDER BY WithdrawalAmtCleaned DESC) AS R
  FROM BANK_SYSTEM_VIEW
)
WHERE R = 5;


-- Query 4: Count of Withdrawal Transactions between May 5, 2018, and March 7, 2019

SELECT COUNT(CAST(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '') AS NUMBER)) AS WithdrawalCount
FROM WITHDRAW_R
WHERE "DATE" BETWEEN TO_DATE('05-05-2018', 'DD-MM-YYYY') AND TO_DATE('07-03-2019', 'DD-MM-YYYY');

-- Query 5: Top 5 Largest Withdrawal Amounts for the year 2018

SELECT DISTINCT Year, WithdrawalAmtCleaned AS LargestWithdrawal
FROM BANK_SYSTEM_VIEW
WHERE Year = 2018
ORDER BY WithdrawalAmtCleaned DESC
FETCH FIRST 5 ROWS ONLY;