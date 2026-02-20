SELECT
  job_id,
  job_title_short,
  salary_year_avg,
  salary_hour_avg
FROM job_postings_fact
WHERE
  salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL;




SELECT
  job_id,
  job_title_short,
  salary_hour_avg - 5 AS salary_hour_min,
  salary_hour_avg,
  salary_hour_avg + 5 AS salary_hour_max 
FROM job_postings_fact
WHERE
  salary_hour_avg IS NOT NULL;



SELECT
  job_id,
  job_title_short,
  salary_hour_avg * .80 AS salary_hour_min,
  salary_hour_avg,
  salary_hour_avg * 1.2 AS salary_hour_max 
FROM job_postings_fact
WHERE
  salary_hour_avg IS NOT NULL;





SELECT
  job_id,
  job_title_short,
  salary_year_avg / (52 * 40) AS hourly_year_salary,
  salary_hour_avg
FROM job_postings_fact
WHERE
  salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL;




SELECT
  job_id,
  job_title_short,
  salary_year_avg,
  salary_year_avg % 1000
FROM job_postings_fact
WHERE
  salary_year_avg IS NOT NULL
  AND salary_year_avg % 1000 = 0;


