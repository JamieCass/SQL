-------------------- SQL TIPS --------------------
/*
SQL (Structured Query Language)

--- ERD (Entity Relationship Diagram) ---
This is a common way to view data in a database.
Looking at an ERD you will notice some columns in the table had PK and FK next to the name

PK - Primary Key -- exists in every table and is a column that has unique value for every row
The primary key is a single column that must exist in each table of a database

FK - Foreign Key -- is a columns in one table that is a primary key in a different table
Foregin keys are always linked to a primary key in a different table

Advantages to using SQL:
- SQL is easy to understand
- Traditional databases allow us to access data directly
- Traditional databases allow us to audit and replicate our data
- SQL is a great tool for analysing multiple tables at once.
- SQL allows you to analyse more complex questions than dashboard tools like Google Analytics.



Why businesses like databases:
- Data integrity in ensured - only the data you want entered is entered, and only certain users are able to enter data into the database.
- Data cane be accessed quickly - SQL allows you to obtain results very quickly from the data stored in a database. Code can be optimized to quickly pull results.
- Data is easily shared - multiple individuals can access data stored in a database, and the data is the same for all users allowing for consistent results for anyone with access to your database.


Types of the most popular databases include:
MySQL
Access
Oracle
Microsoft SQL Server
Postgres

For differences that exist, you should check the documentation. Most SQL environments have great documentation online that you can easily access with a quick Google search.



-------------------- KEY STATEMENTS --------------------
- CREATE TABLE - a statement that creates a new table in a database.
- DROP TABLE - a statement that removes a table in a database.
- SELECT - allows you to read data and display it. This is called a query.

SELECT indicates which column(s) you want to be given the data for.

FROM specifies from which table(s) you want to select the columns. Notice the columns need to exist in this table.




-------------------- Formatting Queries --------------------
It is common and best practice to capitalise all SQL commands, like SELECT and FROM, and keep everything else in your query lower case.

Avoid Spaces in Table and Variable Names
Use semicolons at the end of a query
*/


-- Use white space in queries:
SELECT account_id FROM orders;

-- This is better than the line above:
SELECT account_id
FROM orders;


-------------------- LIMIT --------------------
-- Its good practice to put a limit on your queries, otherwise you can select everything from a table with billions of rows!!
SELECT *
FROM orders
LIMIT 10;

-- example of selecting multiple columns with a limit of 15 rows
SELECT occured_at, account_id, channel
FROM web_events
LIMIT 15;


-------------------- ORDER BY --------------------
ORDER BY -- allows us to sort results using data from any column.
-- It is only temporary though
-- always comes after SELECT and FROM but before the LIMIT.. LIMIT is always the last statement
-- you can add DESC after the columsn in ORDER BY to sort in decending order, default is ascending order.

-- example of using ORDER BY
SELECT *
FROM orders
ORDER BY total
LIMIT 15;

-- query to return 10 earliest orders (include id, occured_at, total_amt_usd)
SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;

-- query to return the top 5 orders in terms of largest total_amt_usd (include id, account_id, total_amt_usd)
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC -- used DESC beacause we wanted to largest orders so it needed to be descending
LIMIT 5;

-- query to return lowest 20 orders in terms of total_amt_usd (include id, account_id, total_amt_usd)
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd
LIMIT 20;


-------------------- ORDER BY PART 2 --------------------
-- you can use ORDER BY for more than 1 column at a time, the sorting occurs using the leftmost column in your list first
-- we still have the ability to flip the way we order with the DESC

-- query with order_id, account_id and total_amt_usd sorted by account_id(ascending) then total_amt_usd(descending)
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;

-- query with order_id, account_id and total_amt_usd sorted by total_amt_usd(descending) then account_id(ascending)
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id;

-- the second query comes up with the most amount for total_amt_usd first, then acc_id is sorted second (only if there are 2 of the same for total_amt_usd)

-------------------- WHERE --------------------
/*
can think of WHERE command as filtering the data (subsets of tables based on conditions that must be met)
common symbols for WHERE statements:
> (greater than)
< (less than)
>= (greater than or equal to)
<= (less than or equal to)
= (equal to)
!= (not equal to)
*/

-- query to pull first 5 rows and all columns for orders where glodd_amt_usd is greater than or equal to 1000
SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

-- query to pull first 10 rows and all columns for orders that have total_amt_usd less than 500
SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;


--Commonly when we are using WHERE with non-numeric data fields, we use the LIKE, NOT, or IN operators

-- filter the accounts table to include tha company name, website and primary point of contact just for Exxon Mobil company
SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';


-------------------- ARITHMETIC OPERATORS --------------------
/*
Derived columns
Creating a new column with a combination of existing columns.
Usually you want to give a name/alias to the new columns, using the AS keyword. */

-- Example of This:
SELECT id, (standard_amt_usd/total_amt_usd)*100 AS std_percent, total_amt_usd
FROM orders
LIMIT 10;

-- REMEMBER BODMAS
-- The following two statements have very different end results:
-- standard_qty / standard_qty + gloss_qty + poster_qty
-- standard_qty / (standard_qty + gloss_qty + poster_qty)


-- create column that devides standard_amt_usd by standard_qty to find unit price for standard paper. include id and account_id (first 10)
SELECT id, (standard_amt_usd/standard_qty) AS std_unit_price, account_id
FROM orders
LIMIT 10;

-- write query to find percentage of revenue that comes from poster paper for eacch order. diplay the id and account_id
SELECT id, account_id, poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd) AS poster_revenue
FROM orders
LIMIT 10;
-- OR
SELECT id, account_id,
(poster_amt_usd/total_amt_usd) AS post_per
FROM orders
LIMIT 10;



-------------------- LOGICAL OPERATORS --------------------
/*
LIKE - This allows you to perform operations similar to using WHERE and =, but for cases when you might not know exactly what you are looking for.

IN - This allows you to perform operations similar to using WHERE and =, but for more than one condition.

NOT - This is used with IN and LIKE to select all of the rows NOT LIKE or NOT IN a certain condition.

AND & BETWEEN - These allow you to combine operations where all combined conditions must be true.

OR - This allow you to combine operations where at least one of the combined conditions must be true.
*/

-- EXAMPLES OF LIKE
SELECT *
FROM web_events_full
WHERE referrer_url LIKE '%google%' -- the % means that the referrer_url can have anything before and after 'google'

-- all companies whose name starts with 'C'
SELECT name
FROM accounts
WHERE name LIKE 'C%';

-- all companies whose names contain the string 'one' somewhere in the name
SELECT name
FROM accounts
WHERE name LIKE '%one%';

-- all companies whose names end with 's'
SELECT name
FROM accounts
WHERE name LIKE '%s';


-- EXAMPLES OF IN
SELECT *
FROM orders
WHERE accound_id IN (1001, 1021)

-- use accounts table to find acc name, primary_poc and sales_rep_id for Walmart, Target and Nordstrom
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

-- use web_events table to find all info regarding individuals who were contacted via channel of organic or adwords
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');


-- EXAMPLES OF NOT
SELECT *
FROM web_events_full
WHERE referrer_url NOT LIKE '%google%' -- show all sites that dont have google in

-- use accounts table to find acc name, primary_poc and sales_rep_id for all stores except Walmart, Target and Nordstrom
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

-- use web_events table to find all info regarding individuals who were contacted via any method except organic or adwords
SELECT *
FROM web_events
WHERE channel NOT IN ('organic', 'adwords');

-- all companies whose names dont start with 'C'
SELECT name
FROM accounts
WHERE name NOT LIKE 'C%';

-- all companies whose names do not contain the string 'one' in the name
SELECT name
FROM accounts
WHERE name NOT LIKE '%one%';

-- all companies whose names dont end with 's'
SELECT name
FROM accounts
WHERE name NOT LIKE '%s';


-- EXAMPLES OF AND & BETWEEN
-- insead of writing:
WHERE column >= 6 AND column <= 10
-- we can write it like this instead:
WHERE column BETWEEN 6 AND 10

-------------------- QUIZ 1 --------------------
-- write a query that returns all orders where the standard_qty is over 1000, the poster_qty is 0 and gloss_qty is 0
SELECT *
FROM orders
WHERE standard_qty > 1000
AND poster_qty = 0 AND gloss_qty = 0;

-------------------- QUIZ 2 --------------------
-- use accounts table to find all companies whose name dont start with 'C' but still end with 's'
SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s';

-------------------- QUIZ 3 --------------------
-- When you use the BETWEEN operator in SQL, do the results include the values of your endpoints, or not?
-- Figure out the answer to this important question by writing a query that displays the order date and gloss_qty data for all orders where gloss_qty is between 24 and 29.
-- Then look at your output to see if the BETWEEN operator included the begin and end values or not.
SELECT occurred_at, gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29;

-------------------- QUIZ 4 --------------------
-- use web_events table to find all info regarding individuals who were contacted via organic or adwords channeks and started their account in 2016(sort from newest to oldest)
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords')
AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;


-- EXAMPLES OF OR
SELECT account_id,
       occured_at,
       standard_qty,
       gloss_qty,
       poster_qty
FROM orders
WHERE (standard_qty = 0 OR gloss_qty = 0 OR poster_qty = 0)
AND occured_at >= '2016-01-01' -- when combining multiple operations, we might use parentheses to assure the logic is executed correctly.

-------------------- QUIZ 1 --------------------
-- find a list of orders where gloss_qty or poster_qty is greater than 4000, only include the id field in results
SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;

-------------------- QUIZ 2 --------------------
-- write a query that returns a list of orders where standard_qty is 0 and either gloss_qty or poster_qty is over 1000
SELECT *
FROM orders
WHERE standard_qty = 0
AND(gloss_qty > 1000 OR poster_qty > 1000);

-------------------- QUIZ 3 --------------------
-- find all company names that start with 'C' or 'W' and the primary contact contains 'ana' or 'Ana' but not 'eana'
SELECT name
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%')
      AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE 'Ana%')
      AND primary_poc NOT LIKE '%eana%');
