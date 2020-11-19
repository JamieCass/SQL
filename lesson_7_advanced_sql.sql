-------------------- ADVANCED JOINS & PERFROMANCE TUNING --------------------
-- this is something you wont use on a daily basis but its good to know!!
-- can be written as FULL OUTER JOIN or FULL JOIN

-------------------- FULL OUTER JOINS --------------------
-- full outer joins include unmatched rows from both tbales being joined
-- E.G. 
SELECT column_name(s)
FROM table_A
FULL OUTER JOIN table_B ON table_A.column_name = table_B.columns_name;
-- a common application of this is when joining two tables on a timestamp
-- e.g. this is good if you have a product that has sold on one day and a different product sold on another day 
-- but the date dosent exist in the oposing table. in this case you would use a FULL OUTER JOIN because it will give you rsults for both dates and leave either table info blank/NULL
-- you could add this to the query above.. 
WHERE table_A.column_name IS NULL OR table_B.column_name IS NULL
-- this would return any unmatched rows only 


				   ---------- QUIZ TIME ----------
-------------------- QUIZ 1 --------------------
-- write a query with FULL JOIN to see:
-- each account who has a sales rep and each sales rep that has an account (all of the columns in these returned rows will be full)
SELECT *
FROM accounts a
FULL JOIN sales_reps s ON a.sales_rep_id= s.id;

-- also each account that doesnt have a sales rep and each sales rep that does not have an account (some columsn will return empty rows)
SELECT *
FROM accounts a
FULL JOIN sales_reps s ON a.sales_rep_id= s.id
WHERE a.sales_rep_id IS NULL OR s.id IS NULL;
	

-------------------- INEQUALITY JOIN --------------------
-- E.G. to help with question below
SELECT orders.id,
	   orders.occurred_at AS order_date,
	   events.*
FROM orders
LEFT JOIN web_events AS events 
ON events.account_id = orders.account_id
AND events.occurred_at < orders.occurred_at,
WHERE DATE_TRUNC('month', orders.occurred_at) = 
	(SELECT DATE_TRUNC('month',MIN(orders.occurred_at)) FROM orders
ORDER BY orders.account_id, orders.occurred_at;

				   ---------- QUIZ TIME ----------
-------------------- QUIZ 1 --------------------
-- write a query the left joins the accounts table and the sales_reps table on each reps ID number
-- and joins it using < comparison orperator on accounts.primary_poc and sales_reps.name
-- query should be a table with three columns (account name, primary_poc, sales_rep_name)
SELECT a.name AS account_name,
	   a.primary_poc AS primary_contact_name,
	   s.name AS sales_rep_name
FROM accounts a 
LEFT JOIN sales_reps s 
ON s.id = a.sales_rep_id
AND a.primary_poc < s.name;



-------------------- SELF JOINS --------------------
-- self joins are basically joing the same table to itself
-- E.G.
SELECT o1.id AS o1_id,
	   o1.account_id AS o1_account_id,
	   o1.occurred_at AS o1_occurred_at,
	   o2.id AS o2_id,
	   o2.account_id AS o2_account_id,
	   o2.occurred_at AS o2_occurred_at
FROM orders AS o1 -- make sure you give the tables an alias
LEFT JOIN orders AS o2 -- first table is 'o1' and this one is 'o2'
ON o1.account_id = o2.account_id -- make sure the account_id's are the same
AND o2.occurred_at > o1.occurred_at -- orders in table 2 ordered after table 1's
AND o2.occurred_at <= o1.occurred_at + INTERVAL '28 days' -- orders orders after table 1's but not by more than 28 days!
ORDER BY o1.account_id, o1.occurred_at;
-- self JOIN is optimal when you wnat to show both parent and child relationships within a family tree
-- more info on INTERVAL (https://www.postgresql.org/docs/8.2/functions-datetime.html)

				   ---------- QUIZ TIME ----------
-------------------- QUIZ 1 --------------------
-- modify the query above to perfrom the same analysis except for the web_events table
-- AND change the interval to 1 day to find those web events that occurred after but not more than 1 day after another web event
SELECT w1.id AS w1_id,
	   w1.account_id AS w1_account_id,
	   w1.occurred_at AS w1_occurred_at,
	   w2.id AS w2_id,
	   w2.account_id AS w2_account_id,
	   w2.occurred_at AS w2_occurred_at
FROM web_events AS w1
LEFT JOIN web_events AS w2 
ON w1.account_id = w2.account_id
AND w1.occurred_at > w2.occurred_at 
AND w1.occurred_at <= w2.occurred_at + INTERVAL '1 day'
ORDER BY w1.account_id, w2.occurred_at;

-- add a column for the channel variable in both instances of the table in the query
SELECT w1.id AS w1_id,
	   w1.account_id AS w1_account_id,
	   w1.occurred_at AS w1_occurred_at,
	   w1.channel AS w1_channel,
	   w2.id AS w2_id,
	   w2.account_id AS w2_account_id,
	   w2.occurred_at AS w2_occurred_at,
	   w2.channel AS w2_channel
FROM web_events AS w1
LEFT JOIN web_events AS w2 
ON w1.account_id = w2.account_id
AND w1.occurred_at > w2.occurred_at 
AND w1.occurred_at <= w2.occurred_at + INTERVAL '1 day'
ORDER BY w1.account_id, w2.occurred_at;


-------------------- UNION --------------------
-- UNION use case
-- UNION is used to combine the results of 2 or more SELECT statements, it removes duplicate rows between the SELECT statements
-- each SELECT statement within UNION must have the same number of fields in the result set with similar data types
-- typically used when a user wnats to pull together distinct values in specified comlumns that are spread across multiple tables
-- e.g. a chef wants to pull together the ingredient and respective aisle across three seperate meals that are maintained in different tables 

-- details of UNION
-- there must be the same number of expressions in both SELECT statements
-- corresponding expressions must have the same data type in the SELECT statments
-- e.g. expression 1 must be the same data type in both the first and second SELECT statement

-- expert tip
-- UNION removes duplicate rows
-- UNION ALL does not remove duplicates

-- strict rules for appending data
-- both tables must have the same number of columns
-- thpse columns must have the same data types in the same order as the first table


-- E.G. appending data via UNION 
SELECT *
FROM web_events

UNION

SELECT * 
FROM web_events_2;


-- E.G pretreating tables before doing a UNION
SELECT * 
FROM web_events
WHERE channel = 'facebook'

UNION ALL 

SELECT * 
FROM web_events_2;


-- E.G performing operations on a combined dataset
WITH web_events AS (
	SELECT *
	FROM web_events 

	UNION ALL 

	SELECT * 
	FROM web_events_2
)

SELECT channel,
	   COUNT(*) AS sessions 
FROM web_events 
GROUP BY 1
ORDER BY 2 DESC;


				   ---------- QUIZ TIME ----------
-------------------- QUIZ 1 --------------------
-- write a query that uses UNION ALL on two instances (and selecting columns) of the accounts table 
SELECT * 
FROM accounts

UNION ALL 

SELECT * 
FROM accounts;

-------------------- QUIZ 2 --------------------
-- add a WHERE clause to each of the tables, filtering the first table where name equals Walmart 
-- and filtering the second table where the name equals Disney 
SELECT * 
FROM accounts
WHERE name = 'Walmart'

UNION ALL 

SELECT * 
FROM accounts
WHERE name = 'Disney';


-------------------- QUIZ 3 --------------------
-- perform the union in the first query in a common tbale expression and name it double_accounts
-- then do a COUNT the number of times a name appears in the double_accounts table 
WITH double_accounts AS (
	SELECT * 
	FROM accounts

	UNION ALL 

	SELECT * 
	FROM accounts
)

SELECT name,
	   COUNT(*) AS name_count
FROM double_accounts
GROUP BY 1
ORDER BY 2 DESC;


-------------------- PERFORMANCE TUNING --------------------
-- one way to make a query run faster is to redice the number of calculations that need to be performed
-- some of the high-level things that will affect the number of calculations a query will make are:
-- table size 
-- joins 
-- aggregations

-- its always good to run the query on a small dataset, then work your way up and make sure eveything is working before working on the entire data set
-- REMEMBER LIMIT comes after an aggregation so it wont help speed up a query with an aggregation in it
-- putting the LIMIT in a subquery will help here!!!

-- query runtime is also dependent on things you cant control like:
-- other users running queries concurrently on the database
-- database software and optimiztion (Postgres is optimized in reading and writing rows quickly, Redshift is optimized to perform aggregations quickly)
 
-- E.G. filtering a query to only show results we need
SELECT account_id,
	   SUM(poster_qty) A sum_poster_qty
 FROM (SELECT * FROM orders LIMIT 100) sub -- to speed the aggregation up we put the limit in a subquery
WHERE occurred_at >= '2016-01-01'
 AND occurred_at < '2016-07-01'
GROUO BY 1 


-- when joining tables together, its better to reduce the size of the tables before joing them, this will again help speed up query time
-- ALWAYS concentrate on accurace of the work rather than runtime
--E.G. of joining a subquery table
SELECT a.name,
	   sub.web_events 
 FROM (
	SELECT account_id,
		   COUNT(*) AS web_events
	 FROM web_events events 
	GROUP BY 1
	) sub  
JOIN accounts a 
ON a.id = sub.account_id
ORDER BY 2 DESC;


-- you can add EXPLAIN and this will tell you roughly how long a query will take (it will tell you what order everything will run)
-- E.G.
EXPLAIN 
SELECT * 
FROM web_events
WHERE occurred_at >= '2016-01-01'
AND occurred_at < '2016-07-01'
LIMIT 100;
-- the higher the number in the explained result will be the one that takes the longest to run, so its better to refine the highest number if possible


















