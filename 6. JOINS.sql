-- joins.

/* 
COMBINE 2 TABLES OR MORE IF THEY HAVE A COMMON COLUMN
BY COMMON COLUMN, WE MEAN THAT THE DATA WITHIN THE COLUMN IS SIMILAR,
NOT NECESSARILY THE COLUMN NAME IS THE SAME


TYPES OF JOINS:
1.INNER
2.OUTER : LEFT AND RIGHT
3.SELF
*/
--
SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

-- INNER JOIN
SELECT *
FROM employee_demographics AS dem
-- BY DEFUALT JOIN REPRESENTS INNER JOIN (EVEN IF I DONT WRITE INNER IN THE LINE BELOW
INNER JOIN employee_salary AS sal
	-- ON employee_id = employee_id -- this will throw error.
	ON dem.employee_id = sal.employee_id 
;
-- note it only inner joins the rows which have same values we wanna tie on. eg. Ron Swansom would be missing in this cASe

-- SELECT employee_id, age, occupation -- this will throw ambiguity error
SELECT dem.employee_id, age, occupation -- we need to specify aliAS.table_column name if it is shared by the tables we wanna join
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id 
;

-- OUTER JOINS : (A) LEFT OUTER JOIN (B) RIGHT OUTER JOIN
-- (A) TAKE EVERYTHING FROM THE LEFT TABLE, AND ONLY JOIN THOSE WHICH ARE ON THE RIGHT
SELECT * -- we need to specify aliAS.table_column name if it is shared by the tables we wanna join
FROM employee_demographics AS dem
LEFT OUTER JOIN employee_salary AS sal -- ONE CAN ALSO RIGHT SIMPLY LEFT JOIN, NO NEED TO WRITE OUTER EXPLICITLY
	ON dem.employee_id = sal.employee_id 
;

SELECT * -- we need to specify alias.table_column name if it is shared by the tables we wanna join
FROM employee_demographics AS dem
RIGHT OUTER JOIN employee_salary AS sal -- ONE CAN ALSO RIGHT SIMPLY LEFT JOIN, NO NEED TO WRITE OUTER EXPLICITLY
	ON dem.employee_id = sal.employee_id 
;

-- SELF JOIN
-- e.g secret santa cASe
SELECT emp1.employee_id AS santa,
emp1.first_name AS santa_first_name,
emp1.last_name AS santa_last_name,
emp2.employee_id AS reciever,
emp2.first_name AS reciever_first_name,
emp2.last_name AS reciever_last_name
FROM employee_salary emp1-- we need to be able to distinguish between tehse 2 tables
JOIN employee_salary emp2 -- note this is an example of aliASing for the table names, we dont use AS here
	ON emp1.employee_id +1 = emp2.employee_id -- next person is the secret santa
;
-- joining multiple tables together
SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal -- SALARY TABLE ACTING LIKE A MIDDLE-MAN/TABLE HERE
	ON dem.employee_id = sal.employee_id 
INNER JOIN parks_departments as pd
	ON sal.dept_id = pd.department_id -- in this way we joined "dem" with "pd" via "sal"
ORDER BY sal.dept_id -- we can also do this.
;

SELECT *
FROM parks_departments -- reference table: this wont change that often (employee table will change very often
;
