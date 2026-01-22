-- List all candidates with more than 5 years of experience.
SELECT *
FROM candidates where years_experience > 6

-- Find all remote jobs posted in the last 30 days.
SELECT company_id, job_title, job_type, job_level
FROM jobs
WHERE remote_allowed = TRUE AND posted_date >= CURRENT_DATE - INTERVAL '30 days';

-- Count the number of jobs per country.
SELECT location_country, COUNT(*) AS job_count
FROM jobs
GROUP BY location_country

-- Show average salary range per job title.
SELECT job_title,
       ROUND(AVG(salary_min)::numeric, 2) AS avg_salary_min,
       ROUND(AVG(salary_max)::numeric, 2) AS avg_salary_max
FROM jobs
GROUP BY job_title
ORDER BY job_title;

-- List applications that were rejected.
SELECT *
FROM applications
WHERE application_status = 'Rejected';
