-- Select statement (for colmumns)
SELECT * -- select everything
-- right now we only specified the table, and not the database. works fine when we highlight the corres
-- FROM employee_demographics; -- semi colon: this is the end of this query
FROM parks_and_recreation.employee_demographics; -- semi colon: this is the end of this query

-- select just a single column
SELECT first_name 
FROM parks_and_recreation.employee_demographics; -- semi colon: this is the end of this query

-- select multiple column
SELECT first_name , last_name, birth_date
FROM parks_and_recreation.employee_demographics; -- semi colon: this is the end of this query


-- calculations using select statement
-- select multiple column
SELECT first_name , last_name, 
age,
(age + 10) * 10 -- follow PEMDAS ( ^ X / + -),
FROM parks_and_recreation.employee_demographics; -- semi colon: this is the end of this query

-- Distinct gender
SELECT DISTINCT gender 
FROM parks_and_recreation.employee_demographics;

-- Distinct gender
SELECT DISTINCT first_name, gender 
FROM parks_and_recreation.employee_demographics;