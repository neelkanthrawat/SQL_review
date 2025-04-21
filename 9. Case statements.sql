-- CASE STATEMENTS
/*
1. CASE works inside SELECT, WHERE, ORDER BY, GROUP BY, etc.
2. nesting CASE is also possible

*/

-- WHEN STATEMENT
SELECT first_name,
last_name,
age, -- note comma here as well
CASE
	WHEN age <=30 THEN "Young"
    WHEN age BETWEEN 31 and 50 THEN "Adults"
    ELSE "old"
END as label
FROM employee_demographics;

-- EXAMPLE:
/*
PAY INCREASE AND BONUS:
< 50000 = 5% PAY INCREASE
>=50000 = 7% PAY INCREASE
IF FROM THE FINANCE DEPARTMENT, THEN ADDITIONAL 10% BONUS
*/
