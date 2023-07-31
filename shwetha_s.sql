set serveroutput on;

CREATE VIEW BANKING_VIEW AS
SELECT EXTRACT(YEAR FROM "DATE") AS Bank_Year,
       CAST(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '') AS NUMBER) AS Total_Amount
FROM BANK_TRANSACTION
WHERE WITHDRAWAL_AMT IS NOT NULL;

CREATE VIEW WITHDRAW_A AS
SELECT "DATE", WITHDRAWAL_AMT
FROM BANK_TRANSACTION;

/*CREATE INDEX BANK_INDEX ON 
BANK_TRANSACTION ("DATE", WITHDRAWAL_AMT);*/


-- Query 1: Highest Amount Debited per Year


SELECT Bank_Year,
       Max(Total_Amount) AS High_Amount;
FROM BANKING_VIEW
GROUP BY Bank_Year;


-- Query 2: Lowest Amount Debited per Year


SELECT Bank_Year,
       MIN(Total_Amount) AS Low_Amount;
FROM BANKING_VIEW
GROUP BY Bank_Year;



-- Query 3: Fifth Highest Amount Debited per Year


SELECT Bank_Year, Fifth_High_Amount
FROM (
  SELECT Bank_Year, Total_Amount AS Fifth_High_Amount,
         DENSE_RANK() OVER (PARTITION BY Bank_Year ORDER BY Total_Amount DESC) AS Z
  FROM BANKING_VIEW
)
WHERE Z = 5;



-- Query 4: Count of Withdrawal Transactions between May 5, 2018, and March 7, 2019


SELECT COUNT(CAST(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '') AS NUMBER)) AS Withdraw_Count
FROM WITHDRAW_A
WHERE "DATE" BETWEEN TO_DATE('05-05-2018', 'DD-MM-YYYY') AND TO_DATE('07-03-2019', 'DD-MM-YYYY');



-- Query 5:  Top 5 Largest Withdrawal Amounts for the year 2018


SELECT DISTINCT Bank_Year, Total_Amount AS Large_Withdrawal
FROM BANKING_VIEW
WHERE Bank_Year = 2018
ORDER BY Total_Amount DESC
FETCH FIRST 5 ROWS ONLY;
