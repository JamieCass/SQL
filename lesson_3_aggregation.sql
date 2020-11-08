-------------------- SQL AGGREGATION --------------------
-- aggregations are usually to do with mathematic queirues.
-- we use COUNT, SUM, MAX, MIN, AVG
-- aggregations only aggregate vertically - the values of a column



-------------------- NULLs --------------------
-- When identifying NULLs in a WHERE clause, we write IS NULL or IS NOT NULL, we dont use '='.
-- NULL is a cell that has no data at all 
-- NULLs usually occur when performing LEFT or RIGHT joins (when there is data in one of the tables but not the other)
-- can also occur when there is simply missing data in the database
-- it wont work on anything other than rows with numbers



-------------------- COUNT --------------------
-- COUNT will return a count with all the rows that are not NULL 

-- E.G. of how many orders were made in December 2016
SELECT COUNT(*) as order_count
FROM orders
WHERE occurred_at >= '2016-12-01' AND occurred_at < '2017-01-01'




-------------------- SUM --------------------
-- you can only use SUM on numeric columns
-- it will ignore NULL values, it will put them down as zero

--E.G. of how many orders were made for standard, gloss and poster paper
SELECT SUM(standard_qty) AS standard,
	   SUM(gloss_qty) AS gloss,
	   SUM(poster_qty) AS poster
FROM orders;


-------------------- QUIZ 1 --------------------
-- find total amount of poster_qty ordered from orders table
SELECT SUM(poster_qty) AS total_poster
FROM orders;


-------------------- QUIZ 2 --------------------
-- find total amount of standard_qty ordered from orders table
SELECT SUM(standard_qty) AS total_standard
FROM orders;


-------------------- QUIZ 3 --------------------
-- find total_amt_usd from the orders table 
SELECT SUM(total_amt_usd) AS total_usd_sales
FROM orders;


-------------------- QUIZ 4 --------------------
-- find total amount spent on standard_amt_usd and gloss_amt_usd in orders table 
-- result should give a dollar amount for each order in the table
SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
FROM orders;


-------------------- QUIZ 5 --------------------
-- find standard_amt_usd per unit of stadard paper
-- soliution should use both aggregation and mathematical operator 
SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_unit_price
FROM orders;



-------------------- MIN & MAX --------------------
-- you can use MIN and MIX simultaneously
-- again they ignore NULLs
-- they are similar to COUNT that they can be used on non-numerical columns 
-- MIN will return the lowest number, earliest date or non-numerical value as early in the aplthabet as possible
-- MAX will do the opposite

-- E.G. of using MIN and MAX 
SELECT MIN(standard_qty) AS standard_min,
	   MIN(gloss_qty) AS gloss_min,
	   MIN(poster_qty) AS poster_min,
	   MAX(standard_qty) AS standard_max
	   MAX(gloss_qty) AS gloss_max
	   MAX(poster_qty) AS poster_max

-------------------- AVG --------------------
-- similar to other software AVG returns the mean of the data (sum of all values divided by the number of values in the column)
-- it will ignore NULL values in both numerator and denominator
-- if you want to count NULLs as zero you will need to use SUM and COUNT (not a good idea usually)
-- median might be a more appropriate measure for some data, but finding it is pretty difficult using SQL alone
-- in fact finding the median is occasionally asked an an interview question

-- E.G. of using AVG
SELECT AVG(standard_qty) AS standard_avg,
	   AVG(gloss_qty) AS gloss_avg,
	   AVG(poster_qty) AS poster_avg
FROM orders;

-------------------- QUIZ 1 --------------------
-- when was the earliest order ever placed, only return the date
SELECT MIN(occurred_at) as earliest_order
FROM orders;

-------------------- QUIZ 2 --------------------
-- Try performing the same query as in question 1 without using an aggregation function.
SELECT occurred_at as earliest_order
FROM orders
ORDER BY occurred_at
LIMIT 1;


-------------------- QUIZ 3 --------------------
-- when did the most recent (latest) web_event occur
SELECT MAX(occurred_at) as latest_web_event
FROM web_events;


-------------------- QUIZ 4 --------------------
-- Try to perform the result of the previous query without using an aggregation function.
SELECT occurred_at as earliest_web_event
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;


-------------------- QUIZ 5 --------------------
-- find the mean(AVERAGE) amount spent per order on each paper type as well as the mean amount of paper type purchased per order
-- final answer should have 6 values - one for each paper typer for avg num of sales as well as average amount
SELECT AVG(standard_amt_usd) AS standard_avg_usd,
	   AVG(gloss_amt_usd) AS gloss_avg_usd,
       AVG(poster_amt_usd) AS poster_avg_usd,
       AVG(standard_qty) AS standard_avg,
       AVG(gloss_qty) AS gloss_avg,
       AVG(poster_qty) AS poster_avg
FROM orders; 


-------------------- QUIZ 6 --------------------
-- what is the MEDIAN total_usd spent on all orders 
-- may need david to explain a little bit about this...
SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

SELECT ROUND(SUM(total_amt_usd) / 2, 2) AS median 
FROM (SELECT o.*, 
      ROW_NUMBER() OVER(ORDER BY total_amt_usd) AS rank
FROM orders o) AS table1
WHERE rank BETWEEN (SELECT COUNT (*) / 2 
FROM orders) AND (SELECT COUNT (*) / 2 
FROM orders) + 1;


-------------------- GROUP BY --------------------
-- GROUP BY can be used to aggregate data within subsets of the data. e.g. grouping different account, regions or sales reps
-- any column in the SELECT statement not within the aggregator must be in the GROUP BY clause
-- GROUP BY always goes between WHERE and ORDER BY
-- ORDER BY works like sort in spreadsheet software

-- E.G.
SELECT account_id
	   SUM(standard_qty) AS standard_sum
	   SUM(gloss_qty) AS gloss_sum
	   SUM(poster_qty) AS poster_sum
FROM orders
GROUP BY account_id
ORDER BY account_id

-- SQL evaluates the aggregations before the LIMIT clause. 

-------------------- QUIZ 1 --------------------
-- which account (by name) placed the earliest order? solution should have account name and date of order
SELECT a.name, o.occurred_at order_date
FROM orders o
JOIN accounts a
ON a.id = o.account_id
ORDER BY occurred_at
LIMIT 1;


-------------------- QUIZ 2 --------------------
-- find total sales in usd for each account. 
-- should include two columns (total sales for each company's orders, company name)
SELECT a.name,
	   SUM(o.total_amt_usd) AS total_sales_usd
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name;

-------------------- QUIZ 3 --------------------
-- via what channel did the most recent (latest) web_event, which account was associated with it?
-- should return three columns (date, channel, account)
SELECT w.occurred_at,
	   w.channel,
	   a.name AS account_name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY w.occurred_at DESC
LIMIT 1;


-------------------- QUIZ 4 --------------------
-- find the total number of times each channel from web_events was used
-- should have two columns (channel, number of times channel was used)
SELECT channel,
	   COUNT (channel) AS total_uses
FROM web_events
GROUP BY channel;

-- or --

SELECT w.channel, COUNT(*)
FROM web_events w
GROUP BY w.channel


-------------------- QUIZ 5 --------------------
-- who was the primary conatact associated with the earliest web_event
SELECT primary_poc primary_contact
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
ORDER BY w.occurred_at 
LIMIT 1;


-------------------- QUIZ 6 --------------------
-- what was the smallest order placed by each account in total_usd
-- provide only two columns (account name, total_usd) orders from smallest to largest
SELECT a.name,
	   MIN(o.total_amt_usd) min_order
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY name
ORDER BY min_order;


-------------------- QUIZ 7 --------------------
-- find the number of sales reps in each region
-- final table should have two columns (the region, number of sales reps) from fewest reps to most reps
SELECT r.name,
	   COUNT(s.name) reps_amt -- or COUNT(*) 
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
GROUP BY r.name
ORDER BY reps_amt;



-------------------- GROUP BY PART II --------------------
-- you can GROUP BY multiple columns at once, this is useful to aggregate across a number of different segments
-- the order of column names in the ORDER BY clause does make a different. youre ordering from left to right
-- the order of column names in the GROUP BY doesnt matter.
-- reminder.. any column that isnt within the aggregation must be in the GROUP BY (youll probably get an error if not, or wrong results)

-------------------- QUIZ 1 --------------------
-- for each account, determine the average of each type of paper they purchased across their orders
-- final table should have four columns (account name, average quantity for each paper)
SELECT a.name account_name,
	   AVG(o.standard_qty) avg_standard,
       AVG(o.gloss_qty) gloss_avg,
       AVG(o.poster_qty) poster_qty
FROM orders o 
JOIN accounts a 
ON a.id = o.account_id
GROUP BY a.name;


-------------------- QUIZ 2 --------------------
-- for each account determine the average amount spent per order on each type
-- finale table should have four columns (account name, average spent for each paper)
SELECT a.name account_name,
	   AVG(o.standard_amt_usd) avg_standard_spent,
       AVG(o.gloss_amt_usd) gloss_avg_spent,
       AVG(o.poster_amt_usd) poster_qty_spent
FROM orders o 
JOIN accounts a 
ON a.id = o.account_id
GROUP BY a.name;


-------------------- QUIZ 3 --------------------
-- determine the number of times a particular channel was used in web_events for each sales_rep
-- final table should have three columns (name of sales_rep, channel, number of occurancies)
-- order the table with highest number of occurencies first
SELECT w.channel channel, 
	   COUNT(w.*) total_occur,
	   s.name rep_name
FROM web_events w
JOIN accounts a 
ON w.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY rep_name, channel
ORDER BY total_occur DESC;


-------------------- QUIZ 4 --------------------
-- determine the number of times a particular channel was used in web_events for each region
-- final table should have three columns (region, channel, number of occurencies)
-- order the table with highest number of occurencies first
SELECT w.channel channel, 
	   COUNT(w.*) total_occur,
	   r.name region
FROM web_events w
JOIN accounts a 
ON w.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
GROUP BY region, channel
ORDER BY total_occur DESC;



-------------------- DISTINCT --------------------
-- always used in the SELECT statment and provides unique rows for all columns written in the SELECT statment
-- only use it once in any particular SELECT statement 

-- E.G. (the right way)
SELECT DISTINCT column1, column2, column3
FROM table1;

-- E.G. (the wrong way)
SELECT DISTINCT column1, DISTINCT column2, DISTINCT column3
FROM table1;

-- using DISTINCT, particularly in aggregations, can slow the queries down by quite a bit!!!

-------------------- QUIZ 1 --------------------
-- use DISTINCT to test if there are any accounts associated with more than one region
SELECT a.id as "account id", r.id as "region id", 
a.name as "account name", r.name as "region name"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;

-- OR -- 

SELECT DISTINCT id, name
FROM accounts


-------------------- QUIZ 2 --------------------
-- have any sales reps worked on more than one account?
SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY num_accounts;

-- OR -- 

SELECT DISTINCT id, name 
FROM sales_reps



-------------------- HAVING --------------------
-- HAVING is the clean way to filter a query that has been aggregated, this is also done using a subquery
-- any time you want to use a WHERE on a query that has been created by an aggregate, use HAVING instead

--E.G (WONT WORK)
SELECT account_id
	   SUM(total_amt_usd) AS sum_total_amt_usd
FROM orders
WHERE SUM(total_amt_usd) >= 250000
GROUP BY 1
ORDER BY 2;

--E.G. (WILL WORK)
SELECT account_id
	   SUM(total_amt_usd) AS sum_total_amt_usd
FROM orders 
GROUP BY 1 
HAVING SUM(total_amt_usd) >= 250000 


-------------------- QUIZ 1 --------------------
-- how many sales_reps manage more than 5 accounts
SELECT s.id, 
	   s.name,
       COUNT(*) total_accounts
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY s.id, s.name
HAVING COUNT(*) > 5;

-- OR -- (using a subquery..) 

SELECT COUNT(*) num_reps_above5
FROM(SELECT s.id, s.name, COUNT(*) num_accounts
     FROM accounts a
     JOIN sales_reps s
     ON s.id = a.sales_rep_id
     GROUP BY s.id, s.name
     HAVING COUNT(*) > 5
     ORDER BY num_accounts) AS Table1;


-------------------- QUIZ 2 --------------------
-- how many accounts have more than 20 orders?
SELECT a.name,
       COUNT(*) total
FROM orders
JOIN accounts a
ON a.id = orders.account_id
GROUP BY a.name
HAVING COUNT(*) > 20;


-------------------- QUIZ 3 --------------------
-- which account has the most orders?
SELECT a.name,
       COUNT(*) total
FROM orders
JOIN accounts a
ON a.id = orders.account_id
GROUP BY a.name
HAVING COUNT(*) > 20
ORDER BY total DESC
LIMIT 1;


-------------------- QUIZ 4 --------------------
-- which accounts spent more than 30,000 usd total across all orders?
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_spent;


-------------------- QUIZ 5 --------------------
-- which accounts spent less than 1,000 usd total across all orders?
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_spent;


-------------------- QUIZ 6 --------------------
-- which account spent the most with us?
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent DESC
LIMIT 1;


-------------------- QUIZ 7 --------------------
-- which account spent the least with us?
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent
LIMIT 1;


-------------------- QUIZ 8 --------------------
-- whoch accounts used facebook as a channel to contact customers more than 6 times?
SELECT a.name account,
	   COUNT(*) total,
       w.channel channel
FROM web_events w
JOIN accounts a
ON a.id = w.account_id 
GROUP BY a.name, w.channel
HAVING w.channel = 'facebook' AND COUNT(*) > 6
ORDER BY channel;


-------------------- QUIZ 9 --------------------
-- which account used facebook the most as a channel?
SELECT a.name account,
	   COUNT(*) total,
       w.channel channel
FROM web_events w
JOIN accounts a
ON a.id = w.account_id 
GROUP BY a.name, w.channel
HAVING w.channel = 'facebook' AND COUNT(*) > 6
ORDER BY channel DESC 
LIMIT 1;


-------------------- QUIZ 10 --------------------
-- which channel was most frequently used by most accounts?
SELECT a.name account,
	   COUNT(*) total,
       w.channel channel
FROM web_events w
JOIN accounts a
ON a.id = w.account_id 
GROUP BY a.name, w.channel
ORDER BY total DESC
LIMIT 10;



-------------------- DATE FUNCTIONS --------------------
-- GROUPing BY a date isnt very useful in SQL, they tend to have data down to the second!
-- having the date info down to the second is a blessing and a curse! blessing - very precise info.. curse - difficult to group together

----- DATE_TRUNC -----
-- allows you to truncate the date to a particular part of the date-time column
-- common trunctions are day, month and year
-- E.G. 
SELECT DATE_TRUNC('day', occurred_at) AS day,
	   SUM(standard_qty) AS standard_qty_sum
from orders
GROUP BY occurred_at
ORDER BY occurred_at;

----- DATE_PART-----
-- can be useful for pulling a specific poertion of a date like month or 'dow' (day of week)
-- pulling the month or dow will no linger keep the year in order (we group by certain components regardless of which year they belong to)
-- E.G.
SELECT DATE_PART('dow', occurred_at) AS day_of_week,
	   SUM(total) AS total_qty
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

-------------------- QUIZ 1 --------------------
-- find the sales in terms of total dollars for all orders in each year - ordered from greatest to least
SELECT DATE_PART('year', occurred_at) AS year,
	   SUM(total_amt_usd) AS total_usd
FROM orders
GROUP BY 1
ORDER BY 2 DESC;


-------------------- QUIZ 2 --------------------
-- which months did Parch & Posey have the greatest sales in terms of total dollars?
-- are all months evenly represented by the dataset?
SELECT DATE_PART('month', occurred_at) AS month,
	   SUM(total_amt_usd) AS total_usd
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;


-------------------- QUIZ 3 --------------------
-- which year did Parch & Posey have the greatest sales in terms of total number of orders?
-- are all years evenly represented by the dataset?
SELECT DATE_PART('year', occurred_at) AS year,
	   COUNT(total) AS total_orders
FROM orders
GROUP BY 1
ORDER BY 2 DESC;


-------------------- QUIZ 4 --------------------
-- which month did Parch & Posey have the greatest sales in terms of total number of orders?
-- are all years evenly represented by the dataset?
SELECT DATE_PART('month', occurred_at) AS month,
	   COUNT(total) AS total_orders
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;


-------------------- QUIZ 5 --------------------
-- in which monnt of which year did Walmart spend the most on gloss paper in terms of dollars?
SELECT DATE_TRUNC('month', occurred_at) AS order_date,
	   SUM(gloss_amt_usd) AS gloss_total_usd
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;



-------------------- CASE --------------------
-- CASE statement is always after SELECT clause
-- must include WHEN, THEN and END. ELSE is an optional component (a bit like elif in python)
-- you can make conditional statements like WHERE, between the WHEN and THEN 
-- you can use multiple WHEN statements as well as an ELSE statements again to deal with unaddressed conditions

-- E.G.
SELECT account_id,
	   occurred_at,
	   total
	   CASE WHEN total > 500 THEN 'Over 500'
	   		WHEN total > 300 AND total <= 500 THEN '301 - 500'
	   		WHEN total > 100 AND total <= 300 THEN '101 - 300'
	   		ELSE '100 or under' END AS total_group
FROM orders;

-- E.G. 
SELECT CASE WHEN total > 500 THEN 'Over 500'
	   ELSE '500 or under' END AS total_group
FROM orders 
GROUP BY 1;

-------------------- QUIZ 1 --------------------
-- write a query to display for each order the account id, total amount of order and level of order 
--(large or small) depending on if the order is $3000 or more or smaller than $3000
SELECT account_id,
	   total_amt_usd,
       CASE WHEN total_amt_usd > 3000 THEN 'Large' 
       ELSE 'Small' END AS total_order
FROM orders;


-------------------- QUIZ 2 --------------------
-- write a query to display number of orders in each of the three categories, based on the total number of items in each order
-- three categories are 'At least 2000', 'Between 1000 and 2000' and 'Less than 1000'
SELECT CASE WHEN total >= 2000 THEN 'At least 2000'
       WHEN total >= 1000 AND total < 2000 THEN 'Between 1000 and 2000'
       ELSE 'Less than 1000' END AS order_level,
COUNT (*) order_total
FROM orders
GROUP BY 1;


-------------------- QUIZ 3 --------------------
-- 3 different levels of customers based on the amount associated with their purchases
-- top level includes anyone with a Lifetime Value (total sales of orders) greater than 200,000 usd
-- second level is between 200,000 and 100,000 usd 
-- lowest is anyone under 100,000
-- should provide (account name, total sales of all orders, level) 
-- order with top spending customer first
SELECT a.name account_name,
	   SUM(total_amt_usd) total_spent,
       CASE WHEN SUM(total_amt_usd) > 200000 THEN 'Top Level'
       WHEN SUM(total_amt_usd) > 100000 THEN 'Mid Level'
       ELSE 'Bottom Level' END AS account_level
FROM orders o
JOIN accounts a 
ON o.account_id = a.id
GROUP BY account_name
ORDER BY 2 DESC;


-------------------- QUIZ 4 --------------------
-- perform similar calculation to the first, but obtain the total amount spent by customers only in 2016 and 2017
-- keep the same levels as the previous question 
-- order with top spending customer first
SELECT a.name account_name,
	   SUM(total_amt_usd) total_spent,
       CASE WHEN SUM(total_amt_usd) > 200000 THEN 'Top Level'
       WHEN SUM(total_amt_usd) > 100000 THEN 'Mid Level'
       ELSE 'Bottom Level' END AS account_level
FROM orders o
JOIN accounts a 
ON o.account_id = a.id
WHERE o.occurred_at > '2015-12-31'
GROUP BY account_name
ORDER BY 2 DESC;


-------------------- QUIZ 5 --------------------
-- identify top performing sales reps which are associated with more than 200 orders
-- create a table with the sales rep name, total number of orders and a column with top or not depending on if they have more than 200 orders
-- place top reps first in final table
SELECT s.name rep_name,
	   COUNT(*) total_orders,
       CASE WHEN COUNT(*) > 200 THEN 'top'
       ELSE 'not' END AS conclusion
FROM orders o
JOIN accounts a 
ON o.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY rep_name
ORDER BY 2 DESC;


-------------------- QUIZ 6 --------------------
-- same as above but want to account for the middle and dollar amount associated with sales
-- identify reps with more than 200 orders or 75000 in total sales
-- middle group has any rep with more than 150 orders or 50000 in sales
-- table must have (sales rep name, total number of orders, total sales across all orders, column with (top, middle, low))
-- sort by top sales people based on dollar amount of sales
SELECT s.name rep_name,
	   SUM(o.total_amt_usd) total_spent,
	   COUNT(*) total_orders,
       CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
       WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'middle'
       ELSE 'low' END AS conclusion
FROM orders o
JOIN accounts a 
ON o.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY rep_name
ORDER BY 2 DESC;


