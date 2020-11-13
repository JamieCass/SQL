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


				   ---------- QUIZ TIME ----------


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



				   ---------- QUIZ TIME ----------


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



				   ---------- QUIZ TIME ----------


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
	HAVING SUM(o.total) > (
		SELECT total_all
		FROM (
			SELECT a.name acc_name, SUM(o.standard_qty) standard_qty, SUM(o.total) total_all
			FROM orders o
			JOIN accounts a 
			ON a.id = o.account_id
			GROUP BY 1
			ORDER BY 2 DESC
			LIMIT 1) AS t1)) AS t2;


-------------------- QUIZ 4 --------------------
-- for the customer that spent the most (total over lifetime as customer) total_amt_usd,
-- how many web_events did the have for each channel
SELECT COUNT(*), t2.web_channel
FROM (
	SELECT a.name acc_name, w.occurred_at web, w.channel web_channel
	FROM accounts a 
	JOIN web_events w 
	ON w.account_id = a.id 
	GROUP BY 1,2,3
	HAVING a.name = (
		SELECT acc_name 
		FROM (
			SELECT SUM(o.total_amt_usd) total_usd, a.name acc_name, w.channel web_channel
			FROM orders o
			JOIN accounts a 
			ON a.id = o.account_id
			JOIN web_events w 
			ON w.account_id = a.id 
			GROUP BY 2,3
			ORDER BY 1 DESC
			LIMIT 1) AS t1)) AS t2
GROUP BY 2;

----- OR -----

SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id =  (SELECT id
                     FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
                           FROM orders o
                           JOIN accounts a
                           ON a.id = o.account_id
                           GROUP BY a.id, a.name
                           ORDER BY 3 DESC
                           LIMIT 1) inner_table)
GROUP BY 1, 2
ORDER BY 3 DESC;

-------------------- QUIZ 5 --------------------
-- what is the lifetime avg amount spent (total_amt_usd) for the top 10 spending accounts?
SELECT AVG(total_usd)
FROM (
	SELECT a.name acc_name, SUM(o.total_amt_usd) total_usd
	FROM orders o
	JOIN accounts a 
	ON a.id = o.account_id
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 10) AS t1;


-------------------- QUIZ 6 --------------------
-- what is the lifetime avg amount spent (total_amt_usd), 
--including only the companies that spent on average more per order than the average of all orders

-- avg per order per company
SELECT a.name acc_name, AVG(o.total_amt_usd) avg_company
FROM orders o 
JOIN accounts a 
ON a.id = o.account_id
GROUP BY 1

-- avg for all orders 
SELECT AVG(o.total_amt_usd) avg_all_orders
FROM orders o 


-- select companies that only spend more per order than avg of all orders
SELECT a.name acc_name, AVG(o.total_amt_usd) avg_company
FROM orders o 
JOIN accounts a 
ON a.id = o.account_id
GROUP BY 1
HAVING AVG(o.total_amt_usd) > (
	SELECT AVG(o.total_amt_usd) avg_all_orders
	FROM orders o)

-- select the avg for all the average spent per order for the companies in the table above
SELECT AVG(avg_company) 
FROM (
	SELECT a.name acc_name, AVG(o.total_amt_usd) avg_company
	FROM orders o 
	JOIN accounts a 
	ON a.id = o.account_id
	GROUP BY 1
	HAVING AVG(o.total_amt_usd) > (
		SELECT AVG(o.total_amt_usd) avg_all_orders
		FROM orders o));




-------------------- WITH --------------------
-- WITH statement is ofetn calles a Common TAble Expression CTE
-- they serve the exact same purpose as subqueries
-- they are more common in practice, as they tend to be cleaner for a future reader

----- SUBQUERY E.G. -----
SELECT channel, AVG(events) AS average_events
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
             channel, COUNT(*) as events
      FROM web_events 
      GROUP BY 1,2) sub
GROUP BY channel
ORDER BY 2 DESC;


----- WITH E.G. -----

-- first part
SELECT DATE_TRUNC('day',occurred_at) AS day, 
       channel, COUNT(*) as events
FROM web_events 
GROUP BY 1,2

-- instead of using a subquery we put in the WITH statement (aliasing the table as events)
WITH events AS (
          SELECT DATE_TRUNC('day',occurred_at) AS day, 
                        channel, COUNT(*) as events
          FROM web_events 
          GROUP BY 1,2)


-- now we use the new events table as if it is any other table in our database
WITH events AS (
          SELECT DATE_TRUNC('day',occurred_at) AS day, 
                        channel, COUNT(*) as events
          FROM web_events 
          GROUP BY 1,2)

SELECT channel, AVG(events) AS average_events
FROM events
GROUP BY channel
ORDER BY 2 DESC;



-- E.G. 
--the above example didnt need more than 1 table, imagine we needed to create a second tabe to pull from
-- we can create an additional table the following way
WITH table1 AS (
          SELECT *
          FROM web_events),

     table2 AS (
          SELECT *
          FROM accounts)

SELECT *
FROM table1
JOIN table2
ON table1.account_id = table2.id;

-- you can add more and more tables using the WITH statement in the same way



				   ---------- QUIZ TIME ----------


-- same as the 6 questions above but using a WITH statement instead of using a subquery
-------------------- QUIZ 1 --------------------
-- provide the name of the sales_rep in each region with the largest total_amt_sales
WITH t1 AS (
		SELECT s.name AS rep_name, 
			   r.name AS region, 
			   SUM(o.total_amt_usd) AS total_usd
		FROM orders o
		JOIN accounts a 
		ON a.id = o.account_id
		JOIN sales_reps s 
		ON s.id = a.sales_rep_id
		JOIN region r 
		ON r.id = s.region_id
		GROUP BY 1,2
		ORDER BY 3 DESC),
	 t2 AS (
		SELECT region, MAX(total_usd) AS total_usd
		FROM t1 
		GROUP BY 1)
SELECT t1.rep_name, t1.region, t1.total_usd
FROM t1 
JOIN t2 
ON t1.region = t2.region AND t1.total_usd = t2.total_usd;


-------------------- QUIZ 2 --------------------
-- for the region with the largest(sum) of sales total_amt_usd, how many total(count) orders were placed?
WITH t1 AS (
		SELECT r.name AS region, SUM(o.total_amt_usd) AS total_usd
		FROM orders o 
		JOIN accounts a 
		ON a.id = o.account_id
		JOIN sales_reps s 
		ON s.id = a.sales_rep_id 
		JOIN region r 
		ON r.id = s.region_id
		GROUP BY 1
		ORDER BY 2 DESC),
	t2 AS (
		SELECT r.name AS region, COUNT(o.total) AS total_orders
		FROM orders o 
		JOIN accounts a 
		ON a.id = o.account_id
		JOIN sales_reps s 
		ON s.id = a.sales_rep_id 
		JOIN region r 
		ON r.id = s.region_id
		GROUP BY 1
		ORDER BY 2 DESC)
SELECT t1.region AS region, t2.total_orders, MAX(t1.total_usd) AS total_usd
FROM t1 
JOIN t2 
ON t1.region = t2.region 
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1;


-------------------- QUIZ 3 --------------------
-- how many accounts had more total purchases than the account name which has bought the most standard_qty throughout their lifetime?
WITH t1 AS (
		SELECT a.name AS name, SUM(o.standard_qty) AS top_standard_orders, SUM(o.total) AS total_orders
		FROM orders o 
		JOIN accounts a 
		ON a.id = o.account_id 
		GROUP BY 1 
		ORDER BY 2 DESC 
		LIMIT 1),

	t2 AS ( 
		SELECT a.name 
		FROM orders o
		JOIN accounts a 
		ON a.id = o.account_id
		GROUP BY 1
		HAVING SUM(o.total) > (SELECT total_orders FROM t1))
SELECT COUNT(*)
FROM t2;


-------------------- QUIZ 4 --------------------
-- for the customer that spent the most (total over lifetime as customer) total_amt_usd,
-- how many web_events did they have for each channel
WITH t1 AS (
		SELECT a.id AS id, a.name AS acc_name, SUM(o.total_amt_usd) AS total_usd
		FROM orders o 
		JOIN accounts a 
		ON a.id = o.account_id
		GROUP BY 1, 2
		ORDER BY 3 DESC 
		LIMIT 1)
SELECT a.name, w.channel,COUNT(*)
FROM accounts a 
JOIN web_events w
ON a.id = w.account_id AND a.name = (SELECT acc_name FROM t1)
GROUP BY 1, 2 
ORDER BY 3 DESC;


-------------------- QUIZ 5 --------------------
-- what is the lifetime avg amount spent (total_amt_usd) for the top 10 spending accounts?
WITH t1 AS (
		SELECT a.name, SUM(o.total_amt_usd) AS total_spent
		FROM orders o 
		JOIN accounts a 
		ON a.id = o.account_id 
		GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 10)
SELECT AVG(total_spent) AS avg_spent
FROM t1;


-------------------- QUIZ 6 --------------------
-- what is the lifetime avg amount spent (total_amt_usd), 
-- including only the companies that spent on average more per order than the average of all orders
WITH t1 AS (
   SELECT AVG(o.total_amt_usd) avg_all
   FROM orders o
   JOIN accounts a
   ON a.id = o.account_id),
t2 AS (
   SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
   FROM orders o
   GROUP BY 1
   HAVING AVG(o.total_amt_usd) > (SELECT * FROM t1))
SELECT AVG(avg_amt)
FROM t2;











