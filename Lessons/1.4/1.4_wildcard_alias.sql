SELECT
  job_id,
  job_title,
  job_title_short,
  job_location,
  job_via
FROM
  job_postings_fact
WHERE 
  -- job_location = 'Columbus, OH';
  job_location LIKE 'Columbus, OH';




SELECT
  job_id,
  job_title,
  job_title_short,
  job_location,
  job_via
FROM
  job_postings_fact
WHERE
  job_location LIKE 'Columbus, __';
  



SELECT
  job_id,
  job_title,
  job_title_short,
  job_location,
  job_via
FROM
  job_postings_fact
WHERE
  job_title LIKE '%Data Analyst%';



SELECT
  job_id,
  job_title AS job_title_original,
  job_title_short AS job_category,
  job_location,
  job_via AS job_posting_site
FROM
  job_postings_fact 
WHERE
  job_title LIKE '%Data Analyst%';




SELECT
  jpf.job_id AS id,
  job_title AS job_title_original,
  job_title_short AS job_category,
  job_location,
  job_via AS job_posting_site
FROM
  job_postings_fact AS jpf
WHERE
  job_title LIKE '%Data Analyst%';




SELECT
  job_id id,
  job_title job_title_original,
  job_title_short job_category,
  job_location,
  job_via job_posting_site
FROM
  job_postings_fact
WHERE
  job_title LIKE '%Data Analyst%';




/*
Look for non-senior data engineer and non-senior software engineer roles
  Only get job titles that include either 'Data' or 'Software'
  Also include those with 'Engineer'  in any part of the title
  Don't include any job titles with 'Senior' or 'Sr' followed by any character
Get the job_id, job_title, location, and job platform
  rename the columns appropriately
*/

SELECT
  job_id AS id,
  job_title,
  job_location AS location,
  job_via AS platform
FROM
  job_postings_fact
WHERE
  (job_title LIKE '%Data%' OR job_title LIKE '%Software%')
  AND job_title LIKE '%Engineer%'
  AND NOT (job_title LIKE '%Senior%' OR job_title LIKE '%Sr%');