-------------------- SQL DATA CLEANING --------------------
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
SELECT LEFT(primary_poc,(STRPOS(primary_poc, ' '))) AS first,
	   RIGHT(primary_poc,LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) AS last
FROM accounts;


-------------------- QUIZ 2 --------------------
-- now see if you can do the same thing for every rep name in the sales_reps table
-- again provide first and last name columns
SELECT LEFT(name, STRPOS(name, ' ') -1) AS first,
	   RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) AS last
FROM sales_reps;













































