-- WHERE CLAUSE (ROW MANIPULATION)
-- logical operators
-- LIKE statement

SELECT *
FROM parks_and_recreation.employee_salary
WHERE first_name = "Leslie"
;


SELECT *
FROM parks_and_recreation.employee_salary
WHERE salary > 50000 -- >=
;

SELECT *
FROM parks_and_recreation.employee_demographics
WHERE gender != "Female"
;

-- logical operators: AND, OR, NOT
SELECT *
FROM parks_and_recreation.employee_demographics
WHERE birth_date > "1985-01-01"
OR NOT gender = "male"
;

SELECT *
FROM parks_and_recreation.employee_demographics
WHERE (first_name = "Leslie") OR age > 44
;

-- LIKE STATEMENT (helps to look for patterns)
-- % anythng after or before
SELECT *
FROM parks_and_recreation.employee_demographics
WHERE first_name LIKE "a%" -- %a
;

-- underscore: "_" 
SELECT *
FROM parks_and_recreation. employee_demographics
WHERE first_name LIKE "a__" -- %a
;

-- Combining: "_ and %" 
SELECT *
FROM parks_and_recreation. employee_demographics
WHERE first_name LIKE "a___%" -- %a
;


