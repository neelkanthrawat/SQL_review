-- Exploratory Data Analysis project

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
order by total_laid_off DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC; 

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2; -- NOTE: During covid times

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC -- checking for the industries affected the most.
LIMIT 10;-- find top 10 industries which were afffected the most.

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC; -- checking for the countries affected the most.

SELECT YEAR(`date`) as year_laidoff , SUM(total_laid_off)
FROM layoffs_staging2
group by year_laidoff
order by 1 DESC;

SELECT *
FROM layoffs_staging2;

-- Let us look into the progression of layoffs  based on month and year
SELECT SUBSTRING(`date`, 1, 7) AS year_month_, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY year_month_
ORDER BY year_month_;

-- Let us look into the progression of layoffs based on month and year and also add info about rolling total layoffs.
WITH rolling_total_cte AS 
(
SELECT SUBSTRING(`date`, 1, 7) AS year_month_, SUM(total_laid_off) as total_laid_off_in_year_month
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY year_month_
ORDER BY year_month_ ASC
)
SELECT year_month_, total_laid_off_in_year_month as total_laid_off, 
SUM(total_laid_off_in_year_month) OVER(ORDER BY year_month_) AS rolling_total
FROM rolling_total_cte;
-- i really need to look into what this OVER() does coz i think i am still not very good with it
-- there is an awesome visualisation for understanding over(). that would help a lot!

-- MOVING FURTHER
-- last time we did the following:
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC; 

-- now let's do one thing. let's also have a column stating which company laid how many employees they laid off in given year_month_
-- that means we need first column as year_month_ and second column as company, third column as total_laid_off
-- and we want this table to be arranged in the ascending order of year_month_ followed by order of company name (alphabet wise),
SELECT SUBSTRING(`date`, 1, 7) AS year_month_, 
company, 
SUM(total_laid_off) AS total_laid_off_given_time
FROM layoffs_staging2
-- WHERE `date` IS NOT NULL
GROUP BY year_month_, company
ORDER BY year_month_, company;

-- trying something else:
SELECT company, YEAR(`date`) as year_,
SUM(total_laid_off) AS total_laid_off_given_time
FROM layoffs_staging2
-- WHERE `date` IS NOT NULL
GROUP BY company, year_
ORDER BY 3 DESC;

WITH company_year_cte AS (
SELECT company, YEAR(`date`) as year_, SUM(total_laid_off) AS total_laid_off_given_time
FROM layoffs_staging2
GROUP BY company, year_
)
SELECT *, DENSE_RANK() OVER (PARTITION BY year_ ORDER BY total_laid_off_given_time DESC) as ranking
FROM company_year_cte
WHERE year_ IS NOT NULL
ORDER BY ranking ASC;


WITH company_year_cte AS (
SELECT company, YEAR(`date`) as year_, SUM(total_laid_off) AS total_laid_off_given_time
FROM layoffs_staging2
GROUP BY company, year_
), company_year_rank_cte AS (
SELECT *, DENSE_RANK() OVER (PARTITION BY year_ ORDER BY total_laid_off_given_time DESC) as ranking
FROM company_year_cte
WHERE year_ IS NOT NULL)
SELECT *
FROM company_year_rank_cte
WHERE ranking <=5;



