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
	


