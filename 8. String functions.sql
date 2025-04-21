-- STRING FUNCTIONS
/*
1. LENGTH
2. UPPER
3. LOWER
4. trim:  removed leading and trailing white spaces
	left trim (LTRIM) and right trim (RTRIM)
5. LEFT(,3)
6. RIGHT(,4)
7. SUBSTRING
8. REPLACE(first_name, "a","haha")
9.  LOCATE()
10. Concat()
*/
SELECT LENGTH("skyfalls");
SELECT UPPER("skyfalls");
SELECT LOWER("SKYfalls");
-- 
SELECT first_name, LENGTH(first_name) as len
FROM employee_demographics
ORDER BY len;

-- sanitization and standardization issue: sometimes anme could be Tom or tom . 
SELECT first_name, UPPER(first_name) 
FROM employee_demographics;

-- TRIM
SELECT TRIM("      sky      ") 
FROM employee_demographic;

-- left, right
SELECT first_name, LEFT(first_name, 4), RIGHT(first_name, 4) -- far 4 left and right
FROM employee_demographics;

-- SUBSTRING
SELECT first_name, SUBSTRING(first_name, 3,2) -- start at 3rd position and get 2 letters towards right (the third pos alphabet is included)
FROM employee_demographics;

-- USE CASE: birthday month
SELECT first_name,birth_date, SUBSTRING(birth_date, 6,2) AS birthday_month -- 
FROM employee_demographics;

-- REPLACE
SELECT first_name, REPLACE(first_name, "a","HAHAHAH") -- start at 3rd position and get 2 letters towards right (the third pos alphabet is included)
FROM employee_demographics;

-- locate
SELECT LOCATE("X", "ALEXANDXERx");

SELECT first_name, LOCATE("AN",first_name) -- start at 3rd position and get 2 letters towards right (the third pos alphabet is included)
FROM employee_demographics;

-- CONCAT
SELECT first_name, last_name,  CONCAT(first_name, " " ,last_name) as Full_name -- start at 3rd position and get 2 letters towards right (the third pos alphabet is included)
FROM employee_demographics;

