-------------------- SUBQUERIES & TEMPORARY TABLES --------------------
-- subqueries and table expression are methods of being able to writes a query that creates a table and then write a query that interacts wihtt his new table
-- sometimes the question we need answering doesnt have an answer when working directly with an existing table
-- its always good to break down subqueires


-- E.G.
SELECT channel,
	   AVG(event_count) AS avg_event_count
FROM (SELECT DATE_TRUNC('day', occurred_at) AS day,
	  	 	 channel,
	     	 COUNT(*) AS event_count
	  FROM web_events
	  GROUP BY 1,2) AS sub 
GROUP BY 1
ORDER BY 2 DESC;


-------------------- QUIZ 1 --------------------
-- find the number of events that occur for each day for each channel
SELECT DATE_TRUNC('day', occurred_at) AS day,
	   channel,
       COUNT(*) AS event_count
FROM web_events
GROUP BY 1,2;


-------------------- QUIZ 2 --------------------
-- now create a subquery that simply provides all the data from the first query
SELECT *
FROM (SELECT DATE_TRUNC('day', occurred_at) AS day,
	   	 	 channel,
       	 	 COUNT(*) AS event_count
	  FROM web_events
      GROUP BY 1,2
      ORDER BY 3 DESC) AS sub;

-------------------- QUIZ 3 --------------------
-- now find the average number of events for each channel, since we broke out by day earleir, this is giving you an average per day
SELECT channel,
	   AVG(event_count) as avg_event_count
FROM (SELECT channel,
	  	 	 DATE_TRUNC('day',occurred_at) AS day,
       		 COUNT(*) AS event_count
	  FROM web_events
	  GROUP BY 1,2) AS sub
GROUP BY 1
ORDER BY 2 DESC;


------ IMPORTANT NOTE ------
-- KEEP YOUR QUERIES WELL FORMATTED!!!!
-- its important to keep your queries well formatted so they are easy to read.
-- the above queires have all been formatted so they are easy to read.
-- the inner queires are matched with indentation, so are the outer queries


-- E.G. of another subquery using a WHERE statement
SELECT * 
  FROM orders 
  WHERE DATE_TRUNC('month', occurred_at) =
  (SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min_month
    FROM orders) 
ORDER BY occurred_at;

-- first query wrote we created a tbale that we could then query again
-- if you are only returning a single value, you might use that value in a logic statments like WHERE, HAVING or SELECT - the value could be nested in a CASE statement
---- TIP ----
-- you should not include a alias when you wirte a subquery in a conditional statement, this is becase a subquery is treated as an individual value rather than as a table
-- also if we returned an entire column in the last query, IN would need to be used to perform logical argument
-- if returning an entire table, ALIAS must be used for the table


-------------------- QUIZ 1 --------------------
-- use DATE_TRUNC to pull month level information about the first order ever placed in the orders table
SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min_month
FROM orders;


-------------------- QUIZ 2 --------------------
-- use the results of previous query to find only the orders that took place in the same month and year as the first order
-- then pull the average for each type of paper qty in this month
SELECT AVG(standard_qty) AS standard_avg,
	   AVG(gloss_qty) AS gloss_avg,
	   AVG(poster_qty) AS poster_avg
FROM orders
WHERE DATE_TRUNC('month',occurred_at) = 
(SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min_month
FROM orders);

----- NEW QUESTIONS -----
-- all queries should have a subquery or subqueries, not by finding the solution and copying the output
-------------------- QUIZ 1 --------------------
-- provide the name of the sales_rep in each region with the largest total_amt_sales
SELECT t3.rep_name, t3.region, t3.total_usd
FROM (
	SELECT region, MAX(total_usd) AS total_usd
	FROM (
		SELECT s.name AS rep_name, r.name AS region, SUM(total_amt_usd) AS total_usd
		FROM orders o 
		JOIN accounts a 
		ON a.id = o.account_id
		JOIN sales_reps s 
		ON s.id = a.sales_rep_id 
		JOIN region r 
		ON r.id = s.region_id
		GROUP BY 1,2) AS t1
	GROUP BY 1) AS t2
JOIN (
	SELECT s.name AS rep_name, r.name AS region, SUM(total_amt_usd) AS total_usd
	FROM orders o 
	JOIN accounts a 
	ON a.id = o.account_id
	JOIN sales_reps s 
	ON s.id = a.sales_rep_id 
	JOIN region r 
	ON r.id = s.region_id
	GROUP BY 1,2
	ORDER BY 3 DESC) AS t3
ON t3.region = t2.region AND t3.total_usd = t2.total_usd;


-------------------- QUIZ 2 --------------------
-- for the reqion with the largest(sum) of sales total_amt_usd, how many total(count) orders were placed?
SELECT r.name region, COUNT(o.total) total_orders
FROM orders o 
JOIN accounts a 
ON a.id = o.account_id
JOIN sales_reps s 
ON s.id = a.sales_rep_id
JOIN region r 
ON r.id = s.region_id
GROUP BY 1 
HAVING SUM(o.total_amt_usd) = (
	SELECT MAX(total_usd)
	FROM (
	SELECT r.name region, SUM(o.total_amt_usd) total_usd
	FROM orders o 
	JOIN accounts a 
	ON a.id = o.account_id
	JOIN sales_reps s 
	ON s.id = a.sales_rep_id
	JOIN region r 
	ON r.id = s.region_id
	GROUP BY 1 
	ORDER BY 2 DESC) AS t1);


-------------------- QUIZ 3 --------------------
-- how many accounts had more total purchases than the account name which has bought the most standard_qty throughout their lifetime?
SELECT COUNT(*)
FROM (
	SELECT a.name
	FROM orders o
	JOIN accounts a
	ON a.id = o.account_id
	GROUP BY 1
	HAVING SUM(o.total) > 
		(SELECT total 
	     FROM (SELECT a.name act_name, SUM(o.standard_qty) tot_std, SUM(o.total) total
	           FROM accounts a
	           JOIN orders o
	           ON o.account_id = a.id
	           GROUP BY 1
	           ORDER BY 2 DESC
	           LIMIT 1) t1)) t2;



SELECT 













































