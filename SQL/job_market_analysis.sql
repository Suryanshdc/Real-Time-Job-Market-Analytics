/*=========================================================
        REAL-TIME JOB MARKET ANALYTICS PLATFORM
                    SQL ANALYSIS
Author : Suryansh Srivastava
Description:
This SQL file contains business analysis queries performed
on the Data Science Job Salaries dataset. The queries are
used to generate insights for the Power BI dashboard and
project report.
=========================================================*/
-- Create and Select database
CREATE DATABASE job_market;
USE job_market;

/*---------------------------------------------------------
SECTION 1 : BASIC SQL
---------------------------------------------------------*/
-- Query 1: Display First 5 Records from Dataset
SELECT *
FROM jobs
LIMIT 5;

-- Query 2: Display Job Title and Salary
SELECT
    job_title,
    salary_in_usd
FROM jobs
LIMIT 10;

-- Query 3: Filter Data Analyst Jobs
SELECT
    job_title,
    salary_in_usd
FROM jobs
WHERE job_title = 'Data Analyst';
/*---------------------------------------------------------
SECTION 2 : BUSINESS ANALYSIS
---------------------------------------------------------*/
-- Query 4: Top 10 Highest Paying Job Titles
SELECT
    job_title,
    ROUND(AVG(salary_in_usd), 2) AS avg_salary
FROM jobs
GROUP BY job_title
ORDER BY avg_salary DESC
LIMIT 10;

-- Query 5: Identify Top 10 Most Common Job Titles
SELECT
    job_title,
    COUNT(*) AS total_jobs
FROM jobs
GROUP BY job_title
ORDER BY total_jobs DESC
LIMIT 10;

-- Query 6: Average Salary by Experience Level
SELECT
    experience_level,
    ROUND(AVG(salary_in_usd), 2) AS avg_salary
FROM jobs
GROUP BY experience_level
ORDER BY avg_salary DESC;
-- Query 7: Average Salary by Company Size
SELECT
    company_size,
    ROUND(AVG(salary_in_usd), 2) AS avg_salary
FROM jobs
GROUP BY company_size
ORDER BY avg_salary DESC;
-- Query 8: Average Salary by Work Mode
SELECT
    CASE
        WHEN remote_ratio = 100 THEN 'Remote'
        WHEN remote_ratio = 50 THEN 'Hybrid'
        ELSE 'On-site'
    END AS work_mode,
    ROUND(AVG(salary_in_usd), 2) AS avg_salary
FROM jobs
GROUP BY
    CASE
        WHEN remote_ratio = 100 THEN 'Remote'
        WHEN remote_ratio = 50 THEN 'Hybrid'
        ELSE 'On-site'
    END
ORDER BY avg_salary DESC;
-- Query 9: Top 10 Countries by Average Salary
SELECT
    company_location,
    ROUND(AVG(salary_in_usd), 2) AS avg_salary
FROM jobs
GROUP BY company_location
ORDER BY avg_salary DESC
LIMIT 10;
-- Query 10: Top 10 Employee Residence Countries
SELECT
    employee_residence,
    COUNT(*) AS total_employees
FROM jobs
GROUP BY employee_residence
ORDER BY total_employees DESC
LIMIT 10;
-- Query 11: Average Salary by Employment Type
SELECT
    employment_type,
    ROUND(AVG(salary_in_usd), 2) AS avg_salary
FROM jobs
GROUP BY employment_type
ORDER BY avg_salary DESC;
-- Query 12: Average Salary by Job Title and Experience Level
SELECT
    job_title,
    experience_level,
    ROUND(AVG(salary_in_usd), 2) AS avg_salary
FROM jobs
GROUP BY
    job_title,
    experience_level
ORDER BY
    job_title,
    avg_salary DESC;
    -- Query 13: Top 10 Highest Paying Remote Job Titles
SELECT
    job_title,
    ROUND(AVG(salary_in_usd), 2) AS avg_salary
FROM jobs
WHERE remote_ratio = 100
GROUP BY job_title
ORDER BY avg_salary DESC
LIMIT 10;
-- Query 14: Number of Jobs by Experience Level
SELECT
    experience_level,
    COUNT(*) AS total_jobs
FROM jobs
GROUP BY experience_level
ORDER BY total_jobs DESC;
-- Query 15: Average Salary by Company Size and Experience Level
SELECT
    company_size,
    experience_level,
    ROUND(AVG(salary_in_usd), 2) AS avg_salary
FROM jobs
GROUP BY
    company_size,
    experience_level
ORDER BY
    company_size,
    experience_level;
    /*---------------------------------------------------------
SECTION 3 : ADVANCED SQL
---------------------------------------------------------*/
-- Query 16: Highest Paying Job Title in Each Experience Level (Using CTE)

WITH SalaryRank AS (
    SELECT
        experience_level,
        job_title,
        ROUND(AVG(salary_in_usd), 2) AS avg_salary,
        RANK() OVER (
            PARTITION BY experience_level
            ORDER BY AVG(salary_in_usd) DESC
        ) AS salary_rank
    FROM jobs
    GROUP BY experience_level, job_title
)

SELECT
    experience_level,
    job_title,
    avg_salary
FROM SalaryRank
WHERE salary_rank = 1
ORDER BY experience_level;
-- Query 17: Rank Job Titles by Average Salary

SELECT
    job_title,
    ROUND(AVG(salary_in_usd), 2) AS avg_salary,
    DENSE_RANK() OVER (
        ORDER BY AVG(salary_in_usd) DESC
    ) AS salary_rank
FROM jobs
GROUP BY job_title
ORDER BY salary_rank;
-- Query 18: Top 3 Highest Paying Job Titles in Each Country

WITH JobSalary AS (
    SELECT
        company_location,
        job_title,
        ROUND(AVG(salary_in_usd), 2) AS avg_salary,
        DENSE_RANK() OVER (
            PARTITION BY company_location
            ORDER BY AVG(salary_in_usd) DESC
        ) AS salary_rank
    FROM jobs
    GROUP BY company_location, job_title
)

SELECT
    company_location,
    job_title,
    avg_salary,
    salary_rank
FROM JobSalary
WHERE salary_rank <= 3
ORDER BY company_location, salary_rank;