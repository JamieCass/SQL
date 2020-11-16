-------------------- SQL DATA CLEANING --------------------
-- HELPFUL SITE (https://mode.com/sql-tutorial/sql-string-functions-for-cleaning/)
-- Clean and re-structure messy data
-- Convert columns to different data types
-- Tricks for manipulating NULLS 


-------------------- LEFT & RIGHT --------------------
-- LEFT pulls a specific number of characters for each row in a specific column starting at the beginning (from the left)
-- to pull the first 3 digits of a phone number you would do:
LEFT(phone_number, 3)

-- RIGHT is the same principle as above but it pulls characters from the right.
-- to pull the last 8 digits of a phone number you would do:
RIGHT(phone_number, 8)

-- LENGTH provides a number of characters for each row of a specific comlumn 
-- you could use it to get the length of each phone number
LENGHT(phone_number)


				   ---------- QUIZ TIME ----------
-------------------- QUIZ 1 --------------------
-- in the accounts table, there is a column holding the website for each company
-- the last 3 digits specify what type of web address they are using
-- pull these extensions and provide how many of each website type exitsts in the accounts table
SELECT RIGHT(UPPER(website), 3) AS extension, COUNT(*) 
FROM accounts
GROUP BY 1;


-------------------- QUIZ 2 --------------------
-- there is much debate how much the name (or even the first letter or a company name) makes
-- use the accounts tbale to pull the first letter of each company name to see the distribution of company names beginning with each letter (or number)
SELECT LEFT(UPPER(name), 1) AS start, COUNT(*)
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;


-------------------- QUIZ 3 --------------------
-- use the accounts table and a CASE statement to create two groups:
-- one group of company names that start with a number
-- second group of company names that start with a letter
-- what proportion starts with a letter 
SELECT SUM(num) AS num, SUM(letter) AS letter
FROM(
	SELECT CASE WHEN LEFT(UPPER(name),1) BETWEEN 'A' AND 'Z' THEN 0 ELSE 1 END AS num,
		   CASE WHEN LEFT(UPPER(name),1) BETWEEN 'A' AND 'Z' THEN 1 ELSE 0 END AS letter
	FROM accounts) AS t1;


-------------------- QUIZ 4 --------------------
-- consider vowels as (a,e,i,o,u)
-- what proportion of company names start with a vowel and what percentage start with anything else
SELECT SUM(vowel) AS vowel, SUM(non_vowel) AS non_vowel
FROM (
	SELECT CASE WHEN LEFT(UPPER(name),1) IN ('A','E','I','O','U') THEN 1 ELSE 0 END AS vowel,
		   CASE WHEN LEFT(UPPER(name),1) IN ('A','E','I','O','U') THEN 0 ELSE 1 END AS non_vowel
		   FROM accounts) AS t1;



-- POSITION - taks a character and a column and provides the index of where the character is for each row
-- E.G.
POSITION(',' IN city_state)

-- STRPOS - same as above but the syntax is different
-- E.G.
STRPOS(city_state, ',')

-- Note... they are both case sensitive so looking for 'A' is different than looking for 'a'

-- LOWER and UPPER do exactly what you think, they make all the characters UPPER or LOWER



				   ---------- QUIZ TIME ----------
-------------------- QUIZ 1 --------------------
-- use the accounts table to create the first and last name columns that hold the first and last names for the primary_poc
SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ')) AS first,
	   RIGHT(primary_poc,LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) AS last
FROM accounts;


-------------------- QUIZ 2 --------------------
-- now see if you can do the same thing for every rep name in the sales_reps table
-- again provide first and last name columns
SELECT LEFT(name, STRPOS(name, ' ') -1) AS first,
	   RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) AS last
FROM sales_reps;





SELECT LEFT(primary_poc, (STRPOS(primary_poc, ' ') -1)) AS first,
	   RIGHT(primary_poc, LENGTH(primary_poc) - (STRPOS(primary_poc, ' '))) AS last
FROM accounts;



-------------------- CONCAT --------------------
-- CONCAT is a way of adding two columns together
-- you can either use CONCAT or || to do this

-- E.G.
SELECT first_name,
	   last_name,
	   CONCAT(first_name, ' ', last_name) AS full_name,
	   first_name || ' ' || last_name AS full_name_alt
FROM customer_data

-- each of these will allow you to combine columsn together across rows

CONCAT(first_name, ' ', last_name)
----- OR -----
first_name || ' ' || last_name


				   ---------- QUIZ TIME ----------
-------------------- QUIZ 1 --------------------
-- each company in accounts wants to create an email address for each primary_poc
-- the email address should be (first_name .last_name @ company_name . com)
SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1)||'.'||
	   RIGHT(primary_poc, LENGTH(primary_poc) - (STRPOS(primary_poc, ' ')))
	   ||'@'||name||'.com' AS company_email
FROM accounts;


-------------------- QUIZ 2 --------------------
-- some of the company names in the email addresses include spaces
-- try and create email addresses by removing all the spaces from the company name
SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1)||'.'||
	   RIGHT(primary_poc, LENGTH(primary_poc) - (STRPOS(primary_poc, ' ')))
	   ||'@'||REPLACE(name,' ', '')||'.com' AS company_email
FROM accounts;


/*
-------------------- QUIZ 3 --------------------
--- we would also like to create a passsword for each user, which they will change after the first log in
--- first password will be .... 
- first letter of primary_poc first name (lowercase) 
- last letter of their first name (lowercase) 
- first letter of their last name (lowercase)
- last letter of their last name (lowercase)
- the number of letters in their first name
- the number of letters in the last name
- then the name of their company they are working with, all capitalized with no spaces
*/
WITH t1 AS (
	SELECT LEFT(primary_poc, (STRPOS(primary_poc, ' ') -1)) AS first,
	   	   RIGHT(primary_poc, LENGTH(primary_poc) - (STRPOS(primary_poc, ' '))) AS last,
	   	   name,
	   	   primary_poc
	FROM accounts
	)
SELECT t1.first AS first_name,
	   t1.last AS last_name,
	   LEFT(primary_poc, STRPOS(primary_poc, ' ') -1)||'.'||
	   RIGHT(primary_poc, LENGTH(primary_poc) - (STRPOS(primary_poc, ' ')))
	   ||'@'||REPLACE(name,' ', '')||'.com' AS company_email,
	   LOWER(LEFT(t1.first, 1))|| 
	   LOWER(RIGHT(t1.first, 1))||
	   LOWER(LEFT(t1.last, 1))||
	   LOWER(RIGHT(t1.last, 1))||
	   LENGTH(t1.first)||
	   LENGTH(t1.last)||
	   UPPER(REPLACE(name,' ', '')) AS password
FROM t1;



-------------------- CAST --------------------
-- both 'CAST' and '::' allow for the converting of one data type to another
--E.G.
SELECT *, 
	   DATE_PART('month', TO_DATE(month, 'month')) AS clean_month, -- change from 'January' to '1'
	   year || '-' || DATE_PART('month', TO_DATE(month, 'month')) || '-' || day AS concatinated_date,
	   CAST(year || '-' || DATE_PART('month', TO_DATE(month, 'month')) || '-' || day AS date) AS formatted_date, -- 'CAST' way to convert
	   (year || '-' || DATE_PART('month', TO_DATE(month, 'month')) || '-' || day):: date AS formatted_date_alt -- '::' way to convert
FROM ad_clicks;
-- DATE_PART('month', TO_DATE(month'month')) here changed a month name into a number associated with that particular month
-- then you change a sting to a date using CAST or :: 
-- LEFT, RIGHT, TRIM are all used to select only certain elements of string, but using them to select elements of a number or date will treat them as strings for the purpose of the function
-- TRIM can be used to remove characters from the beginning and end of a string, often used to remove white space from beginning or end of a row


				   ---------- QUIZ TIME ----------
-------------------- QUIZ 1 --------------------
-- write a query to look at the top 10 rows to understand the columns and the raw data in the dataset (sf_crime_data)
SELECT * 
FROM sf_crime_data
LIMIT 10;


-------------------- QUIZ 2 --------------------
-- whats the correct format of dates in SQL?
-- yyyy-mm-dd


-------------------- QUIZ 3 --------------------
-- look at the date column, the date is not in the correct format 
-- dd-mm-yyyy


-------------------- QUIZ 4 --------------------
-- write a query to change the date into the right SQL date format
SELECT date AS original_date,
	   SUBSTR(date, 7, 4)||'-'||LEFT(date, 2)||'-'||SUBSTR(date, 4, 2) AS new_date
FROM sf_crime_data
LIMIT 10;


-------------------- QUIZ 5 --------------------
-- once you have created column in the correct format, use either CAST or :: to conver to a date.
SELECT date AS original_date,
	   (SUBSTR(date, 7, 4)||'-'||LEFT(date, 2)||'-'||SUBSTR(date, 4, 2)):: DATE AS new_date
FROM sf_crime_data
LIMIT 10;



-------------------- COALESCE --------------------
-- COALESCE will return the first non-NULL value passed for each row
-- it allows you to change the values from NULL to something of your choice
-- E.G.
SELECT * ,
	   COALESCE(primary_poc, 'no POC') AS primary_poc_modified
FROM accounts
WHERE primary_poc IS NULL;


				   ---------- QUIZ TIME ----------
-------------------- QUIZ 1 --------------------
-- use COALESCE to fill in the accounts.id column with the accounts.id for the NULL value
SELECT COALESCE(a.id, a.id),
	   a.name,
	   a.website,
	   a.lat,
	   a.long,
	   a.primary_poc,
	   a.sales_rep_id,
	   o.*
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;


-------------------- QUIZ 2 --------------------
-- use COALESCE to fill in the orders.account_id column with the account.id for the NULL value
SELECT COALESCE(a.id, a.id) AS new_id, a.name, a.website,
	   a.lat, a.long, a.primary_poc, a.sales_rep_id,
	   COALESCE(o.account_id, a.id) AS new_account_id, o.occurred_at, o.standard_qty,
	   o.gloss_qty, o.poster_qty, o.total,
	   o.standard_amt_usd, o.gloss_amt_usd, o.poster_amt_usd, o.total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;


-------------------- QUIZ 3 --------------------
-- use COALESCE to fill in each of the qty and usd columns with 0
SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, 
	   a.lat, a.long, a.primary_poc, a.sales_rep_id, 
	   COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, 
	   COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, 
	   COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, 
	   COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;


-------------------- QUIZ 4 --------------------
-- run the query with the WHERE removed and COUNT the number of ids
SELECT COUNT(*)
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;


-------------------- QUIZ 5 --------------------
-- run the query in 4 but with the COALESCE function used in 1-3
SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, 
	   a.lat, a.long, a.primary_poc, a.sales_rep_id, 
	   COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, 
	   COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, 
	   COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, 
	   COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;








