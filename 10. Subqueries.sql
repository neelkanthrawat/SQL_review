-- Subqueries
/*

*/

-- subquery in the where statement
SELECT *
FROM employee_demographics dem
WHERE dem.employee_id IN 
				(SELECT employee_id
                FROM employee_salary 
                WHERE dept_id =1 -- those employee ids who work in dept_id=1
				)
;

-- subquery in the select statement 
-- if you try the following, it won't work
SELECT first_name, salary, AVG(salary)
FROM employee_salary;
-- try this next:
SELECT first_name, salary, 
(SELECT AVG(salary)
FROM employee_salary)
FROM employee_salary;

-- subquery in from statement
SELECT gender, AVG(age) as avg_age,  MAX(age) as max_age, MIN(age) AS min_age, Count(age) as total_number_of_people
FROM employee_demographics
GROUP BY gender;

-- BETTER METHOD TO DO THE FOLLOWING IS CTE AND TEMP TABLES
SELECT AVG(max_age)
FROM 
(SELECT gender, AVG(age) as avg_age,  MAX(age) as max_age, MIN(age) AS min_age, Count(age) as total_number_of_people
FROM employee_demographics
GROUP BY gender) AS agg_table;


-- an example I thought of:
SELECT gender, max_age, min_age, max_age-min_age as difference_in_age_range
FROM 
(SELECT gender, AVG(age) as avg_age,  MAX(age) as max_age, MIN(age) AS min_age, Count(age) as total_number_of_people
FROM employee_demographics
GROUP BY gender) AS agg_table
GROUP BY gender;
-- there are 2 more clean way to solve this task: 1. creating CTE for the subquery, 2. creating temp_table for the subquery

