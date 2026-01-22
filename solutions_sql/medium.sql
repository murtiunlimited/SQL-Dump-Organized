-- Find top 5 companies with the most job postings.
SELECT 
    CC.company_id,
    CC.company_name,
    COUNT(JJ.job_id) AS job_count
FROM companies AS CC
JOIN jobs AS JJ
  ON CC.company_id = JJ.company_id
GROUP BY CC.company_id, CC.company_name
LIMIT 5;

-- Average recruiter score by job title.
SELECT
    JJ.job_title,
    AVG(AAA.recruiter_score) AS avg_recruiter_score
FROM jobs JJ
JOIN applications AAA
  ON JJ.job_id = AAA.job_id
GROUP BY JJ.job_title;

-- Number of applications per candidate (top 10).
SELECT
c.candidate_id,
c.first_name,
c.last_name,
COUNT(a.application_id) AS application_count

FROM candidates c JOIN applications a ON c.candidate_id = a.candidate_id
GROUP BY c.candidate_id, c.first_name, c.last_name

-- Number of applications per candidate (top 2).
SELECT
    c.candidate_id,
    c.first_name,
    c.last_name,
    COUNT(a.application_id) AS application_count
FROM candidates c
JOIN applications a
  ON c.candidate_id = a.candidate_id
GROUP BY c.candidate_id, c.first_name, c.last_name
LIMIT 2;

-- Salary offered vs salary range difference per job.
SELECT
    j.job_title,
    j.salary_min,
    j.salary_max,
    o.offered_salary,
    o.offered_salary - j.salary_min AS above_min_by,
    j.salary_max - o.offered_salary AS below_max_by
FROM jobs j
JOIN applications a
  ON j.job_id = a.job_id
JOIN offers o
  ON a.application_id = o.application_id;

-- Interview count per application.
SELECT
    a.application_id,
    COUNT(i.interview_id) AS interview_count
FROM applications a
LEFT JOIN interviews i
  ON a.application_id = i.application_id
GROUP BY a.application_id
ORDER BY interview_count DESC;


