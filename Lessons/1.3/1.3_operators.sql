SELECT
  job_id,
  job_title_short,
  job_location,
  job_via,
  salary_year_avg
FROM
  job_postings_fact
WHERE
  job_location = 'Anywhere';



SELECT
  job_id,
  job_title_short,
  job_location,
  job_via,
  salary_year_avg,
  job_title,
  job_work_from_home
FROM
  job_postings_fact
WHERE
  job_work_from_home = TRUE;



SELECT
  job_id,
  job_title_short,
  job_location,
  job_via,
  salary_year_avg,
  job_title,
  job_work_from_home,
  job_schedule_type
FROM
  job_postings_fact
WHERE
  job_schedule_type != 'Contractor';



SELECT
  job_id,
  job_title_short,
  job_location,
  job_via,
  salary_year_avg,
  job_title,
  job_work_from_home,
  job_schedule_type
FROM
  job_postings_fact
WHERE
  job_schedule_type <> 'Contractor';



SELECT
  job_id,
  job_title_short,
  job_location,
  job_via,
  salary_year_avg
FROM
  job_postings_fact
WHERE
  -- salary_year_avg > 100000;
  -- salary_year_avg >= 100000;
  salary_year_avg <= 100000;




SELECT
  job_id,
  job_title_short,
  job_location,
  job_via,
  salary_year_avg,
  job_work_from_home
FROM
  job_postings_fact
WHERE
  job_title_short = 'Data Engineer'
  AND
  job_work_from_home = TRUE;



SELECT
  job_id,
  job_title_short,
  job_location,
  job_via,
  salary_year_avg
FROM
  job_postings_fact
WHERE
  job_location = 'Anywhere'
  AND job_work_from_home = FALSE;




SELECT
  job_id,
  job_title_short,
  job_location,
  job_via,
  salary_year_avg
FROM
  job_postings_fact
WHERE
  job_title_short = 'Data Engineer'
  OR job_title_short = 'Senior Data Engineer';




SELECT
  job_id,
  job_title_short,
  job_location,
  job_via,
  salary_year_avg
FROM
  job_postings_fact
WHERE NOT
  job_work_from_home = True;




SELECT
  job_id,
  job_title_short,
  job_location,
  job_via,
  salary_year_avg
FROM
  job_postings_fact
WHERE NOT
  (job_location = 'Anywhere'
  AND job_work_from_home = FALSE);




SELECT
  job_id,
  job_title_short,
  job_location,
  job_via,
  salary_year_avg
FROM
  job_postings_fact
WHERE
  -- salary_year_avg >= 10_000 AND salary_year_avg <= 20_000;
  salary_year_avg BETWEEN 100000 AND 200000;




SELECT
  job_id,
  job_title_short,
  job_location,
  job_via,
  salary_year_avg
FROM
  job_postings_fact
WHERE
  job_title_short IN ('Data Analyst', 'Data Engineer', 'Senior Data Engineer');



/*
Get job detail for BOTH 'Data Engineer' or 'Data Analyst' positions
  For Data Engineer, I want jobs only $75K - $100k
  For Data Analyst, I only want jobs $100k - $125K
    Sidenote, I want higher salary for this role because I have DE skills
Only include jobs located in Either:
  Bentonville, AR
  San Diego, CA (if I have to move I'm going to a city I love)
  Remote Jobs
*/


SELECT
  job_id,
  job_title_short,
  job_location,
  job_via,
  salary_year_avg
FROM
  job_postings_fact
WHERE
  (
    (job_title_short = 'Data Engineer' AND salary_year_avg BETWEEN 75_000 AND 100_000)
    OR (job_title_short = 'Data Analyst' AND salary_year_avg BETWEEN 100_000 AND 125_000)
  ) 
  AND
  (
    job_location IN ('Bentonville, AR', 'San Diego, CA')
    OR
    job_work_from_home = TRUE
  )
  ORDER BY
    salary_year_avg DESC;