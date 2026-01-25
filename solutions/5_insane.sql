-- Identify ghost jobs (high applicants, no interviews)
SELECT
    j.job_id,
    j.job_title,
    COUNT(DISTINCT a.application_id) AS applications
FROM jobs j
JOIN applications a ON j.job_id = a.job_id
LEFT JOIN interviews i ON a.application_id = i.application_id
GROUP BY j.job_id, j.job_title
HAVING
    COUNT(DISTINCT a.application_id) >= 20
    AND COUNT(i.interview_id) = 0;

-- Recruiter scores by gender & experience
SELECT
    c.gender,
    CASE
        WHEN c.years_experience < 3 THEN 'Junior'
        WHEN c.years_experience BETWEEN 3 AND 7 THEN 'Mid'
        ELSE 'Senior'
    END AS experience_band,
    COUNT(*) AS num_applications,
    AVG(a.recruiter_score) AS avg_score
FROM applications a
JOIN candidates c ON a.candidate_id = c.candidate_id
WHERE a.recruiter_score IS NOT NULL
GROUP BY c.gender, experience_band
ORDER BY experience_band, c.gender;
