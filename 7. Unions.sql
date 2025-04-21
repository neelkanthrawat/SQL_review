-- UNIONS 
/*
ALLOWS TO COMBINE ROWS TOGETHER (EARLIER WITH JOINS WE COMBINED COLUMNS)
THE ROWS COULD BE FROM DIFFERENT TABLES OR THE SAME TABLE

DONE AS FOLLOWS:
TAKE 1 SELECT STATEMENT, TAKE UNION, COMBINE USING ANOTHER SELECT STATEMENT
*/

-- naive introductory example
SELECT age, gender
FROM employee_demographics
UNION
SELECT first_name, last_name
FROM employee_salary;

-- the example in the previous block of code isnt very good one
SELECT first_name, last_name
FROM employee_demographics
UNION -- by default it is UNION DISTINCT, IT WOULD REMOVE DUPLICATES FROM THE BOTH THE TABLES
-- in this example, a lot of first name and last names overlapped between the two tables.
SELECT first_name, last_name
FROM employee_salary;

-- UNION ALL 
SELECT first_name, last_name
FROM employee_demographics
UNION ALL 
SELECT first_name, last_name
FROM employee_salary;

-- USE CASE EXAMPLE
-- Company wants to investigate old and highly paid employees 
-- both the information is available in different tables (emp_dem and emp_sal)
SELECT first_name, last_name, "old gents" as label
FROM employee_demographics emp_dem
WHERE emp_dem.age > 40 AND emp_dem.gender = "Male"
UNION
SELECT first_name, last_name, "old divas" as label
FROM employee_demographics emp_dem
WHERE emp_dem.age > 40 AND emp_dem.gender = "Female"
UNION
SELECT first_name, last_name, "highly paid" as label
FROM employee_salary emp_sal
WHERE emp_sal.salary > 70000
ORDER BY first_name, last_name;
