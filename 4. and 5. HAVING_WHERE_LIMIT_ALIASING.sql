-- 1. Having Vs where
-- 2. limit and aliasing

/* 
Key Differences:
Purpose:
WHERE is used to filter rows before grouping and aggregation.
HAVING is used to filter groups after the aggregation.

Use with Aggregate Functions:
WHERE cannot be used with aggregate functions directly.
HAVING can be used with aggregate functions.

When to Use:
Use WHERE when you want to filter individual rows (before grouping).
Use HAVING when you want to filter based on aggregated values (after grouping).

*/
-- THIS WONT WORK
SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
WHERE avg_age > 40 -- goup by hasnt taken place, hence this does not work
GROUP BY gender; 

-- having comes right after group by
SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING avg_age >40;

-- using both in 1 query
SELECT occupation, AVG(salary) AS avg_sal
FROM employee_salary
WHERE occupation LIKE "%manager%"
GROUP BY occupation -- ; try to uncomment this and comment the line below (2 tables)
HAVING avg_sal > 75000;

-- LIMIT AND ALIASING
SELECT *
FROM employee_demographics
LIMIT 3;

-- COMBINE LIMIT WITH ORDER BY
SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 3;

-- COMBINE LIMIT WITH ORDER BY, SKIP THE OLDEST EMPLOYEE
SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 2, 1; -- START AT POSITION 2 AND GO 1 ROW AFTER (TAKING THE ONE NEXT ROW)
