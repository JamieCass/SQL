-------------------- SQL JOINS --------------------
-- databases are usually split up into different tables with different data.
-- they do this so you dont take up too much memory with just one table.
-- when we join a table, we always have the PK equal to the FK
-- join the two tbales linking the PK and FK (usually in an ON statement)

-- E.G. account data and order data will be stored in different databases.

-------------------- NORMALIZATION --------------------
-- there are usually 3 ideas that are aimes at database normalization:
-- Are the tables storing logical groupings of the data?
-- Can I make changes in a single location, rather than in many tables for the same information?
-- Can I access and manipulate data quickly and efficiently?


-------------------- INNER JOINS --------------------
-- this will pull info from just the orders table
SELECT orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

-- The table name is always before the period.
-- The column you want from that table is always after the period.

-- this will pull just the account name and the dates an account placesd an order
SELECT accounts.name, orders.occurred_at
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

-- this will show all the columns from both the accounts table and the orders table
SELECT *
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

-- try and pull all the data from both accounts table and orders table
SELECT orders.*, accounts.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

--Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.
SELECT orders.standard_qty,
       orders.gloss_qty,
       orders.poster_qty,
       accounts.website,
       accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

-- You can join more than 2 tables together..
SELECT *
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
JOIN orders
ON accounts.id = orders.account_id

-- if you wanted to specify whish columns you wanted to pull, we do it in the SELECT statement
SELECT web_events.channel, accounts.name, orders.total

-------------------- ALIAS --------------------
-- you can give a table a name by just putting a space and then the name you want to rename the table as..
SELECT orders.*,
       accounts.*
FROM orders o -- this is where we rename the table
JOIN accounts a -- this is where we rename the table
ON o.account_id = a.id;

-- you can also use an alias for column names as well, this is how we would do it..
SELECT t1.column1 aliasname, t2.column2 aliasname2
FROM tablename AS t1 -- you can also us the AS statment instead of just having a space to rename the table
JOIN tablename2 AS t2

-------------------- QUIZ 1 --------------------
-- provide table for all web_events associated with name of Walmart
-- there should be 3 columns (primary_poc, time of the event, channel)
-- additionally you might want to add a fourths column to assure only Walmart events were chosen
SELECT a.name, a.primary_poc, w.occurred_at, w.channel
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
WHERE a.name = 'Walmart';

-------------------- QUIZ 2 --------------------
-- provide a table that provides region for each sales_rep along with their associated accounts
-- final table should include 3 columns (region name, sales_rep name, account name)
-- sort the names alphabetically (A-Z) according to account name
SELECT a.name account, s.name rep, r.name region -- added the bits after a.name ect. to name the columns..
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
ORDER BY a.name;

-------------------- QUIZ 3 --------------------
-- provide the name for each region for every order as well as account name and unit price(total_amt_usd/total)
-- final table should have 3 columns (region name, account name and unit price)
-- some accounts have 0 so divide by (total+0.01) to assure not dividing by zero
SELECT r.name region, o.total_amt_usd/(o.total+0.01) unit_price, a.name account
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps
ON a.sales_rep_id = sales_reps.id
JOIN region r
ON sales_reps.region_id = r.id;



-------------------- LEFT & RIGHT JOINS --------------------
-- when you join on from LEFT or RIGHT the results will show everything an INNER join would but also return any results in the left that did not match
-- LEFT and RIGHT joins are the same pretty much
-- if there is not data in some rows of the result, the data type will be NULL
-- some people may write RIGHT/LEFT OUTER JOIN but its the same as just writing LEFT/RIGHT JOIN

-- OUTER JOIN will return the inner join result set, as well as any unmatched rows from either of the tables being used (outer joins are rarely used)


-------------------- QUIZ 1 --------------------
-- provide a table that provides region of each sales_rep and their associated accounts only for the Midwest region
-- final table should include three columns (region name, sales_rep name, account name)
-- sort results alphabetically (A-Z) by account name

SELECT r.name region, s.name rep_name, a.name account_name
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON r.id = s.region_id
WHERE r.name = 'Midwest'
ORDER BY a.name;

-------------------- QUIZ 2 --------------------
-- provide a table athat provides region for each sales_rep and their associated accounts only for sales_reps where name starts with 'S' and in 'Midwest'
-- final table should include three columns (region name, sales_rep name, account name)
-- sort results alphabetically (A-Z) by account name
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON r.id = s.region_id
WHERE r.name = 'Midwest' AND s.name LIKE 'S%'
ORDER BY a.name;

-------------------- QUIZ 3 --------------------
-- provide a table athat provides region for each sales_rep and their associated accounts only for accounts where sales_rep has last name starting with 'K' and in 'Midwest'
-- final table should have three columns (region name, sales_rep name, account name)
-- sort results alphabetically (A-Z) by account name
SELECT r.name region, s.name rep_name, a.name account_name
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON r.id = s.region_id
WHERE r.name = 'Midwest' AND s.name LIKE '% K%'
ORDER BY a.name;

-------------------- QUIZ 4 --------------------
-- provide the name for each region for every order and the account name and unit price (total_amt_usd/(total+0.01))
-- however only provide results if standard order quantity exceeds 100
-- final table should have three columns (region name, account name, unit price)
SELECT r.name region, a.name acc_name, o.total_amt_usd/(total+0.01) unit_price
FROM orders o
JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps
ON a.sales_rep_id = sales_reps.id
JOIN region r
ON sales_reps.region_id = r.id
WHERE o.standard_qty > 100;

-------------------- QUIZ 5 --------------------
-- provide the name for each region for every order and the account name and unit price (total_amt_usd/(total+0.01))
-- however only provide results if standard order quantity exceeds 100 and poster order quantity exceeds 50
-- final table should have three columns (region name, account name, unit price) and sort by smallest unit price
SELECT r.name region, a.name acc_name, o.total_amt_usd/(total+0.01) unit_price
FROM orders o
JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps
ON a.sales_rep_id = sales_reps.id
JOIN region r
ON sales_reps.region_id = r.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price;

-------------------- QUIZ 6 --------------------
-- provide the name for each region for every order and the account name and unit price (total_amt_usd/(total+0.01))
-- however only provide results if standard order quantity exceeds 100 and poster order quantity exceeds 50
-- final table should have three columns (region name, account name, unit price) and sort by largest unit price
SELECT r.name region, a.name acc_name, o.total_amt_usd/(total+0.01) unit_price
FROM orders o
JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps
ON a.sales_rep_id = sales_reps.id
JOIN region r
ON sales_reps.region_id = r.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price DESC;

-------------------- QUIZ 7 --------------------
-- what are the different channels used by account id 1001?
-- final table should have only 2 columns (account name, different channels)
SELECT DISTINCT w.channel channels, a.name acc_name
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE a.id = '1001';

-------------------- QUIZ 8 --------------------
-- find all the orders that occurred in 2015.
-- final table should have 4 columns (occurred_at, account name, order total, order total_amt_usd)
SELECT o.occurred_at occurred_at,
	   o.total order_total,
       o.total_amt_usd order_total_amt_usd,
	   a.name acc_name
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '2015-01-01' AND '2016-01-01';
