-- 	Data Cleaning mini-Project


SELECT *
FROM layoffs;

-- 1. REMOVE duplicates if there are any
-- 2. STANDARDIZE THE DATA
-- 3. CHECK FOR NULL AND BLANK VALUES
-- 4. REMOVE ANY COLUMNS AND ROWS WHICH ARE UNNECESSARY (BE VERY CAREFUL)

CREATE TABLE layoffs_staging -- create a new table layoffs_staging
LIKE layoffs; -- which same structure as the table layoffs

SELECT *
FROM layoffs_staging;

-- Fill in the content in the newly created table layoffs_staging
-- recall insert clause:
/* 

RECALL: DIFFERENT WAYS TO USE INSERT CLAUSE IN SQL

-- 1. INSERT with explicit column names and values
INSERT INTO employees (employee_id, name, department)
VALUES (101, 'Alice', 'HR');

-- 2️. INSERT multiple rows in one query
INSERT INTO employees (employee_id, name, department)
VALUES 
(102, 'Bob', 'Finance'),
(103, 'Carol', 'IT');

-- 3️. INSERT using a SELECT query (copying data from another table)
INSERT INTO employees_archive (employee_id, name, department)
SELECT employee_id, name, department
FROM employees
WHERE department = 'IT';

-- 4️. INSERT ALL COLUMNS (when inserting all values in correct order)
-- Make sure the order of values matches the table schema
INSERT INTO employees
VALUES (104, 'David', 'Marketing');

-- 5️. INSERT with DEFAULT values (if table has default constraints)
-- Useful when you want a blank row with defaults applied
-- (Works only if the table allows it and has defaults)
INSERT INTO settings DEFAULT VALUES;

*/
INSERT layoffs_staging -- note: MORE CORRECT WOULD HAVE BEEN INSERT INTO, BUT ITS OK FOR MYSQL FOR NOW
SELECT *
FROM  layoffs;

SELECT *
FROM layoffs_staging;
-- We are going to change the staging database a lot, we still would have the raw data safe

-- 1. Removing duplicates
-- note: in this case, we dont have the unique row ID. 
-- RECALL: What can we use to achieve this: Use Window function ROW_NUMBER
-- SELECT *,
-- ROW_NUMBER() OVER(
-- 	PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date` -- note: since date in itself is a functionality, use backticks
--     ) as row_num
-- FROM layoffs_staging;

-- creating CTE
WITH duplicate_cte AS (
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date` -- note: since date in itself is a functionality, use backticks
    -- we realised later that we need to partiton by all columns 
    , stage, country, funds_raised_millions
    ) as row_num
FROM layoffs_staging -- note: no ";" here
)

SELECT *
FROM duplicate_cte
WHERE row_num >1; -- it will return duplicates

SELECT *
FROM layoffs_staging
WHERE company = "Casper"; 


-- removing the duplicates
WITH duplicate_cte AS (
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date` -- note: since date in itself is a functionality, use backticks
    -- we realised later that we need to partiton by all columns 
    , stage, country, funds_raised_millions
    ) as row_num
FROM layoffs_staging -- note: no ";" here
)
-- THIS CODE WOULD THROW ERROR: the target table duplicate_cte of the DELETE is not updatable
DELETE -- NOTE: DELETE STATEMENT IS LIKE AN UPDATE STATEMENT
FROM duplicate_cte
WHERE row_num >1;
-- reason is:  MySQL does not support updatable CTEs. We need to look for some other way

-- copy to clipboard -> create statement 
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date` -- note: since date in itself is a functionality, use backticks
    -- we realised later that we need to partiton by all columns 
    , stage, country, funds_raised_millions
    ) as row_num
FROM layoffs_staging;

SELECT * -- checking the duplicates in layoffs_staging 2
FROM layoffs_staging2
WHERE row_num > 1;
-- let's delete now
DELETE -- note that this was not working before, i went to preferences -> SQL editor and at the very bottom, I unchecked SAFE UPDATES (toggle it back to 1)
FROM layoffs_staging2
WHERE row_num > 1;

SELECT * -- checking for duplicates in layoffs_staging 2 again: no more duplicates
FROM layoffs_staging2
WHERE row_num > 1;


-- Standardising data
-- on seeing the data, we saw some unnecessary white spaces at the beginning of some company names, let us fix that.alter
SELECT company, TRIM(company)-- first let's print it
FROM layoffs_staging2; 

UPDATE layoffs_staging2
SET company = TRIM(company); -- updating with this

SELECT DISTINCT industry-- first let's print it
FROM layoffs_staging2
ORDER BY 1; -- note crypto, crypto currency and crypto currency. they needs to be named the same

SELECT *-- first let's print it
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%'; -- note crypto, crypto currency and crypto currency. they need to be named the same

UPDATE layoffs_staging2
SET industry = 'Crypto' -- updating with this
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry-- first let's print it
FROM layoffs_staging2
ORDER BY industry; -- note: now just a single crypto! 

SELECT DISTINCT location-- first let's print it
FROM layoffs_staging2
ORDER BY 1; -- potential issues you will find: Da1/4 sseldorf, FlorianA^3polis, MalmASomeweirdSign, Non-U.S.

SELECT DISTINCT country-- first let's print it
FROM layoffs_staging2
ORDER BY 1; -- issue: United States. (with a fullstop in the end)

-- NEW STUFF: TRIM(TRAILING "." FROM country)
-- I think we could have also used like
SELECT DISTINCT country, TRIM(TRAILING "." FROM country)
FROM layoffs_staging2
ORDER BY 1; -- it worked! so let's update the table now

UPDATE layoffs_staging2
SET country = TRIM(TRAILING "." FROM country)
WHERE country LIKE "United States%"; -- updating with this

SELECT DISTINCT country-- Let us check it again
FROM layoffs_staging2
ORDER BY 1; -- issue fixed: just United States now (no fullstop in the end anymore)

-- Proceeding further
-- Let us say we want to do time-series analysis where, then we dont want date in "text" format as it is rn, it should be in date format
SELECT `date`-- Let us check it again
FROM layoffs_staging2;

-- we will use STR_TO_DATE()
SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y')-- look out for date format in MYSQL, it is pretty interesting
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date`-- LET US PRINT IT AGAIN
FROM layoffs_staging2;

-- NOTE THAT: IF YOU GO TO LEFT PANEL AND CHECK DATE, IT STILL SHOWS THE FORMAT TO BE text
-- let's cahnge to date column. CAUTION: always do this on staging table, not the raw data. we are completely changing the dtype of the column
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE; -- now if you check, you will find that the column's dtype is changed to date

SELECT *
FROM layoffs_staging2;

-- step 3. DEALING WITH NULL AND BLANK VALUES. Should i make them all blanks, all null or should they be populated
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE (total_laid_off IS NULL) AND (percentage_laid_off IS NULL);

-- DISCUSS SUCH WEIRD DATA WITH THE TEAM ON WHETHER YOU WANT TO KEEP THESE VALUES OR WANNA REMOVE THEM

SELECT DISTINCT industry
FROM layoffs_staging2; -- some missing values and some NULL

SELECT *
FROM layoffs_staging2 -- some missing values and some NULL
WHERE (industry IS NULL) OR (industry = ''); -- output was: Airbnb, Bally's Interactive, Carvana, Juul

SELECT *
FROM layoffs_staging2 -- some missing values and some NULL
WHERE company = "Airbnb"; -- one row had Travel, another one is blank. Let us fix this
-- we need to fix this issue, let's do it
-- good practice, CONVERT Blanks to NULL

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = "";-- good. it worked

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2	
	ON t1.company = t2.company
WHERE (t1.industry IS NULL) AND (t2.industry IS NOT NULL); -- good it worked in the end

-- 
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL) AND (t2.industry IS NOT NULL); -- it worked. 

SELECT * -- let us check things again
FROM layoffs_staging2 -- some missing values and some NULL
WHERE company = "Airbnb"; -- now the first row in the output also have an entry in the industry! cool

SELECT *
FROM layoffs_staging2 -- some missing values and some NULL
WHERE (industry IS NULL) OR (industry = ''); -- output earlier was: Airbnb, Bally's Interactive, Carvana, Juul
-- bally is still isnt fixed let us delve deeper into it

SELECT *
FROM layoffs_staging2
WHERE company LIKE "Bally%"; -- okay so there was only just one entry for Bally, that is why it did not work out

-- investigating the data further
SELECT *
FROM layoffs_staging2; -- if we had total number of employee as another column, we could have calculated total laid off using the percentage laif off and vice versa
-- and filled those NULL values, but ALAS! , we dont have that.

-- REMOVING ROWS/COLUMNS WHICH YOU ARE 100% SURE NEEDS TO BE REMOVED FROM THE DATABASE
SELECT *
from layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
-- DELETING SUCH ROWS 
DELETE
from layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2; -- we still have the row_nums. let us get rid of it

-- drop a column row_num from the layoff_staging2
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- our final table
SELECT *
FROM layoffs_staging2; -- 

