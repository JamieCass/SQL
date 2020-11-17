-------------------- WINDOW FUNCTIONS --------------------
-- for a good reference look at the site below
-- https://www.postgresql.org/docs/8.4/functions-window.html 
-- the window functions allows you to compare one row to another without doing any JOINS
-- window function perfoms a calculation across a set of table rows that are somehow related to the current row
-- its a bit like an aggregation, but it does not cause rows to become grouped into a single row output, the rows retain their seperate indentities
-- we use OVER and PARTITION BY to use a window function
-- you might not always use PARTITION BY and you can also use ORDER BY or no statement at all depending on the query
-- you cant use window functions and standard aggregations in the same query
-- more specifically, you cant include windo functions in a GROUP BY clause

-------------------- OVER --------------------
-- E.G. 
SELECT standard_qty,
	   DATE_TRUNC('month', occurred_at) AS month,
	   SUM(standard_qty) OVER (PARTITION BY DATE_TRUNC('month', occurred_at) ORDER BY occurred_at) AS running_total
FROM orders;


				   ---------- QUIZ TIME ----------
-------------------- QUIZ 1 --------------------
-- create a running total of standard_amt_usd over order time with no DATE_TRUNC
-- final table should have two columns (one with the amount being added each row, second with the running total)
SELECT standard_amt_usd,
	   SUM(standard_amt_usd) OVER (ORDER BY occurred_at) AS running_total
FROM orders;


-------------------- QUIZ 2 --------------------
-- modify the query above to include partitions
-- this time have DATE_TRUNC by year and partition by the same year-truncated occurred_at variable
-- final table should have three columns (one with the amount being added each row, second for truncated date final with the running total)
SELECT standard_amt_usd,
	   DATE_TRUNC('year', occurred_at) AS year,
	   SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at) AS running_total
FROM orders;

-------------------- ROW_NUMBER & RANK --------------------
-- RANK will rank by whatever you order by, if the row has the info in the ORDER BY clause, both will be ranked the same number 	e.g.(1,2,2,4,4,6)
-- DENSE_RANK will do the same as rank but it wont skip a number if there are more than 1 with the same rank     	 				e.g.(1,2,2,3,3,4)
-- ROW_NUMBER will give a number to each row depending on what you ORDER BY
-- E.G.
SELECT id,
	   account_id,
	   DATE_TRUNC('month',occurred_at) AS month,
	   RANK() OVER(PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS rank_num
FROM orders;


				   ---------- QUIZ TIME ----------
-------------------- QUIZ 1 --------------------
-- select (id, account_id, total) from orders
-- create a column (total_rank) that ranks the total amount or paper ordered from highest to lowest
-- final table should have these four columns
SELECT id,
	   account_id,
	   total,
	   RANK() OVER(PARTITION BY account_id ORDER BY total DESC) AS total_rank
FROM orders;


-------------------- AGGREGATIONS IN WINDOW FUNCTIONS --------------------
-- E.G.
SELECT id,
	   account_id,
	   standard_qty,
	   DATE_TRUNC('month',occurred_at) AS month,
	   DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
	   SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_standard_qty,
	   COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_standard_qty,
	   AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_standard_qty,
	   MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_standard_qty,
	   MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_standard_qty
FROM orders;

-- if you remove ORDER BY from the query above this will give you an unordered partition
-- each columns value is simply an aggregation (e.g. sum, count, avg, min, max) of all the standard_qty values in its respective account_id
-- leaving the ORDER BY out is equivalent to 'ordering' in a way that all rows in the partition are 'equal' to each other

 
-------------------- ALIASES FOR MULTIPLE WINDOW FUNCTIONS --------------------
-- you can use a WINDOW ALIAS to refer to multiple aggregations like in the example below
-- E.G.
SELECT id,
	   account_id,
	   standard_qty,
	   DATE_TRUNC('month',occurred_at) AS month,
	   DENSE_RANK() OVER main_window AS dense_rank,
	   SUM(standard_qty) OVER main_window AS sum_standard_qty,
	   COUNT(standard_qty) OVER main_window AS count_standard_qty,
	   AVG(standard_qty) OVER main_window AS avg_standard_qty,
	   MIN(standard_qty) OVER main_window AS min_standard_qty,
	   MAX(standard_qty) OVER main_window AS max_standard_qty
FROM orders
WINDOW main_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at));


				   ---------- QUIZ TIME ----------
-------------------- QUIZ 1 --------------------
-- create and use an alias to shorten the following query
-- use alias 'account_year_window'
SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS count_total_amt_usd,
       AVG(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS min_total_amt_usd,
       MAX(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS max_total_amt_usd
FROM orders
-- shortened version
SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER account_year_window AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders
WINDOW account_year_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at));


-------------------- COMPARING A ROW TO A PREVIOUS ROW --------------------
-- LAG function returns the value from the previous row in the table
-- LEAD function returns from the row following the current row in the table
-- https://classroom.udacity.com/nanodegrees/nd027/parts/60bb91f0-1184-4a31-b6f3-81f3a845c906/modules/b99d4f09-5d51-4e87-b267-7dada5fbbe8f/lessons/1f912c22-e086-4936-8a44-1e84c89b00ec/concepts/d164195e-6cca-401c-ae28-2c89063b1fd7
-- this will help to explain a little bit more..
-- you can use LEAD and LA  whenever you are trying to compare values in adjacent rows that are offset by a certain number
-- E.G. 
SELECT account_id,
	   standard_sum,
	   LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag, -- this will give us the LAG number (number in previous row in same column)
	   LEAD(standard_sum) OVER (ORDER BY standard_sum) AS lead -- this will give us the LEAD number (number in the next row in the same column)
	   standard_sum - LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag_difference -- this will give us the difference between the previous and the current row in the lag column
	   LEAD(standard_sum) OVER (ORDER BY standard_sum) - standard_sum AS lead_difference -- this will give us the difference between the current and the next row in the lead row
FROM (
	SELECT account_id,
		   SUM(standard_qty) AS standard_sum
	FROM orders
	GROUP BY 1
	) AS sub


				   ---------- QUIZ TIME ----------
-------------------- QUIZ 1 --------------------
-- determine how the current orders total revenue compares to the nect orders total revenue
-- modify the query above to pefrom this analysis...
-- use occurred_at and total_amt_usd along with LEAD 
-- final result should return four columns (occurred_at, total_amt_usd, lead, lead_difference)
SELECT occurred_at,
	   total_amt_usd,
	   LEAD(total_usd_sum) OVER (ORDER BY occurred_at) AS lead,
	   LEAD(total_usd_sum) OVER (ORDER BY occurred_at) - total_usd_sum AS lead_difference
FROM (
	SELECT occurred_at,
		   SUM(total_amt_usd) AS total_usd_sum,
	FROM orders
	GROUP BY 1
	) AS sub


-------------------- PERCENTILES --------------------
-- you can use window funtions to indetify what percetile (or quartile, or any other subdivision) a given row falls into
-- the syntax is NTILE(*# of buckets*)
-- when you use a NTILE function but the number of rows in the partition is less than the NTILE, NTILE will divide the rows into as many..
-- ..as there are members (rows) in the set but then stop short of the requested number of groups
-- E.G.
SELECT id,
	   account_id,
	   occurred_at,
	   NTILE(4) OVER (ORDER BY standard_qty) AS quartile, -- this will show where the results fall in terms of being split into 4
	   NTILE(5) OVER (ORDER BY standard_qty) AS quintile, -- this will show where the results fall in terms of being split into 5
	   NTILE(100) OVER (ORDER BY standard_qty) AS percetile -- this will show where the results fall in terms percentage
FROM orders 
ORDER BY standard_qty DESC;


				   ---------- QUIZ TIME ----------
-- determine the largest orders (quantity) a specific customer has made to encourge them to order more similarly sized orders
-- only consider NTILE for that customers account_id 
-------------------- QUIZ 1 --------------------
-- use NTILE to divide the accounts into 4 levels in terms of the amount of standard_qty for their orders
-- final table should have (account_id, occurred_at total of standard_qty purchased, one of 4 levels in a standard_quartile column)
SELECT account_id,
	   occurred_at,
	   standard_qty,
	   NTILE(4) OVER (PARTITION BY account_id ORDER BY standard_qty) AS standard_quartile
FROM orders
ORDER BY account_id DESC;


-------------------- QUIZ 2 --------------------
-- use NTILE to divide the accounts into 2 levels in terms of the amount of gloss_qty for their orders
-- final table should have (account_id, occurred_at total of standard_qty purchased, one of 2 levels in a gloss_half column)
SELECT account_id,
	   occurred_at,
	   gloss_qty,
	   NTILE(2) OVER (PARTITION BY account_id ORDER BY gloss_qty) AS gloss_half
FROM orders
ORDER BY account_id DESC;

-------------------- QUIZ 3 --------------------
-- use NTILE to divide the accounts into 100 levels in terms of the amount of total_amt_usd for their orders
-- final table should have (account_id, occurred_at total of standard_qty purchased, one of 100 levels in a gloss_half column)
SELECT account_id,
	   occurred_at,
	   total_amt_usd,
	   NTILE(100) OVER (PARTITION BY account_id ORDER BY total_amt_usd) AS total_percentile
FROM orders
ORDER BY account_id DESC;




















