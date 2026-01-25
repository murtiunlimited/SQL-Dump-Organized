-- Detect recruiters with score inflation (standard deviation analysis)
SELECT
    candidate_id,
    first_name,
    last_name,
    country,
    years_experience,
    RANK() OVER (
        PARTITION BY country
        ORDER BY years_experience DESC
    ) AS experience_rank
FROM candidates;


-- Compute rolling average offered salary over time
SELECT
    offer_date,
    offered_salary,
    AVG(offered_salary) OVER (
        ORDER BY offer_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS rolling_7_offer_avg
FROM offers
WHERE offer_status = 'Accepted'
ORDER BY offer_date;



-- Calculate salary percentiles within each job title
SELECT
    j.job_title,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY o.offered_salary) AS p25_salary,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY o.offered_salary) AS median_salary,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY o.offered_salary) AS p75_salary
FROM offers o
JOIN applications a ON o.application_id = a.application_id
JOIN jobs j ON a.job_id = j.job_id
WHERE o.offer_status = 'Accepted'
GROUP BY j.job_title;


-- Rank candidates within each country by experience
SELECT
    j.job_id,
    j.job_title,
    AVG(o.offer_date - j.posted_date) AS avg_time_to_hire_days
FROM jobs j
JOIN applications a ON j.job_id = a.job_id
JOIN offers o ON a.application_id = o.application_id
WHERE o.offer_status = 'Accepted'
GROUP BY j.job_id, j.job_title;


-- Measure time-to-hire per job (posting → offer) (WE DONT HAVE RECUITER ID SO THIS QUERY IS NOT ACCURATE)
SELECT
    j.job_id,
    j.job_title,
    COUNT(a.application_id) AS num_reviews,
    AVG(a.recruiter_score) AS avg_score,
    STDDEV(a.recruiter_score) AS score_stddev
FROM applications a
JOIN jobs j ON a.job_id = j.job_id
WHERE a.recruiter_score IS NOT NULL
GROUP BY j.job_id, j.job_title
HAVING
    AVG(a.recruiter_score) > 4.5
    AND STDDEV(a.recruiter_score) < 0.3;
