SELECT * 
FROM job_postings_fact;


SELECT * 
FROM job_postings_fact
LIMIT 10;


SELECT
  job_id,
  company_id
FROM
  job_postings_fact
LIMIT 10;


SELECT
  data_jobs.main.job_postings_fact.job_id,
  data_jobs.main.job_postings_fact.job_location
FROM
  data_jobs.main.job_postings_fact
LIMIT 10;



SELECT DISTINCT
  job_title_short
FROM
  job_postings_fact;


SELECT
  job_title_short,
  job_title
FROM
  job_postings_fact;



/*
What this query does
**Selects fiels: ** job title(short + long) + avg salary
**Filter out missing:** only rows where salary_year_avg has a value
**Shows clean results:** no NULL salaries in the output
*/

SELECT
  job_title_short,
  job_title,
  salary_year_avg
FROM
  job_postings_fact
WHERE
  job_title_short = 'Data Engineer';
  -- salary_year_avg IS NULL;
  -- salary_year_avg IS NOT NULL;



SELECT
  job_title_short,
  job_title,
  job_location,
  job_via,
  salary_hour_avg
FROM
  job_postings_fact 
ORDER BY
  -- salary_hour_avg;
  salary_hour_avg DESC;



SELECT
  job_title_short,
  job_title,
  job_location,
  job_via,
  salary_year_avg
FROM
  job_postings_fact
WHERE
    job_title_short = 'Data Engineer'
ORDER BY 
  salary_year_avg DESC
LIMIT 10;