-- GROUP BY AND ORDER BY

SELECT *
FROM employee_demographics;

SELECT gender
FROM employee_demographics;

SELECT DISTINCT gender
FROM employee_demographics;

-- this wont work
SELECT gender, AVG(age)
FROM employee_demographics;
-- GROUP BY gender;

SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;

SELECT occupation, salary
FROM employee_salary
GROUP BY occupation, salary;

-- ORDER BY
SELECT *
FROM employee_demographics
ORDER BY first_name DESC; -- DEFAULT asc

SELECT *
FROM employee_demographics
ORDER BY gender, age; -- first ordering by the gender, then by the age

SELECT *
FROM employee_demographics
ORDER BY gender, age DESC; -- first ordering by the gender, then by the age


-- one can also use the column number
SELECT * 
FROM employee_demographics
ORDER BY 5, 4 DESC; -- first ordering by the gender, then by the age