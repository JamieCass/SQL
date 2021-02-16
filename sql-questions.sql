EASY QUESTIONS

1. https://www.hackerrank.com/challenges/weather-observation-station-5/problem

SELECT city, LENGTH(CITY) 
FROM station
ORDER BY LENGTH(CITY) DESC, CITY
LIMIT 1;
SELECT city, LENGTH(CITY) 
FROM station
ORDER BY LENGTH(CITY), CITY
limit 1;


2. https://www.hackerrank.com/challenges/weather-observation-station-6/problem

SELECT DISTINCT CITY
FROM STATION
WHERE SUBSTRING(CITY,1,1) IN ('A','E','I','O','U');


3. https://www.hackerrank.com/challenges/more-than-75-marks/problem?h_r=next-challenge&h_v=zen&h_r=next-challenge&h_v=zen&h_r=next-challenge&h_v=zen&h_r=next-challenge&h_v=zen&h_r=next-challenge&h_v=zen&h_r=next-challenge&h_v=zen&h_r=next-challenge&h_v=zen

SELECT NAME
FROM STUDENTS
WHERE MARKS > '75'
ORDER BY SUBSTRING(NAME,-3), ID;


4. https://www.hackerrank.com/challenges/salary-of-employees/problem

SELECT name
FROM Employee
WHERE months < 10 AND salary > 2000
ORDER BY employee_id;


MEDIUM QUESTIONS

1. https://www.hackerrank.com/challenges/the-report/problem

SELECT CASE WHEN g.Grade < 8 THEN s.Name = NULL 
       ELSE s.NAME END AS NULL_NOT, 
       g.Grade, 
       s.Marks
FROM Students s
JOIN Grades g ON s.Marks BETWEEN g.MIN_MARK AND g.MAX_MARK
ORDER BY g.Grade DESC, s.Name;


2. https://www.hackerrank.com/challenges/full-score/problem?h_r=next-challenge&h_v=zen

SELECT T2.id, T2.name
FROM (
    SELECT SUM(T1.tally) AS tally_sum, T1.hacker_id AS id, T1.name AS name
    FROM (
        SELECT h.hacker_id AS hacker_id , h.name AS name,
        CASE WHEN s.score = d.score THEN 1 ELSE 0 END AS tally
        FROM hackers h 
        JOIN submissions s ON h.hacker_id = s.hacker_id
        JOIN challenges c ON c.challenge_id = s.challenge_id
        JOIN difficulty d ON d.difficulty_level = c.difficulty_level)  AS T1
    GROUP BY 2, 3
    HAVING SUM(T1.tally) > 1) AS T2
ORDER BY T2.tally_sum DESC, 1;


3. https://www.hackerrank.com/challenges/harry-potter-and-wands/problem

SELECT w.id, t1.age, t1.min_coins, t1.power
FROM (
    SELECT wp.age, MIN(w.coins_needed) AS min_coins, w.power, w.code
    FROM wands w
    JOIN wands_property wp ON wp.code = w.code
    WHERE wp.is_evil = 0 
    GROUP BY 1,3,4) AS t1
JOIN wands w ON w.code = t1.code AND w.coins_needed = t1.min_coins AND w.power = t1.power
ORDER BY t1.power DESC, t1.age DESC, t1.min_coins; 


4. 



