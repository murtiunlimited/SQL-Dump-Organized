-- Candidates who applied to more than 5 jobs but received no offers
SELECT 
    c.candidate_id,
    c.first_name,
    c.last_name,
    COUNT(a.application_id) AS total_applications
FROM candidates c
JOIN applications a 
    ON c.candidate_id = a.candidate_id
LEFT JOIN offers o 
    ON a.application_id = o.application_id
GROUP BY c.candidate_id, c.first_name, c.last_name
HAVING COUNT(a.application_id) > 5
   AND COUNT(o.offer_id) = 0;

--  Companies whose average offered salary exceeds market average.
WITH market_avg AS (
    SELECT AVG(offered_salary) AS avg_market_salary
    FROM offers
),
company_avg AS (
    SELECT 
        c.company_id,
        c.company_name,
        AVG(o.offered_salary) AS avg_company_salary
    FROM companies c
    JOIN jobs j 
        ON c.company_id = j.company_id
    JOIN applications a 
        ON j.job_id = a.job_id
    JOIN offers o 
        ON a.application_id = o.application_id
    GROUP BY c.company_id, c.company_name
)
SELECT *
FROM company_avg
WHERE avg_company_salary > (SELECT avg_market_salary FROM market_avg);

-- Jobs where the interview score decreases each round.
SELECT DISTINCT j.job_id, j.job_title
FROM jobs j
JOIN applications a 
    ON j.job_id = a.job_id
JOIN interviews i1 
    ON a.application_id = i1.application_id
JOIN interviews i2 
    ON a.application_id = i2.application_id
   AND i2.interview_round = i1.interview_round + 1
WHERE i2.interview_score < i1.interview_score;

-- Conversion rate: application → interview → offer per company.
SELECT
    c.company_id,
    c.company_name,
    COUNT(DISTINCT a.application_id) AS total_applications,
    COUNT(DISTINCT i.application_id) AS applications_with_interviews,
    COUNT(DISTINCT o.application_id) AS applications_with_offers,
    
    ROUND(
        COUNT(DISTINCT i.application_id) * 1.0 
        / COUNT(DISTINCT a.application_id), 2
    ) AS application_to_interview_rate,
    
    ROUND(
        COUNT(DISTINCT o.application_id) * 1.0 
        / COUNT(DISTINCT i.application_id), 2
    ) AS interview_to_offer_rate
FROM companies c
JOIN jobs j 
    ON c.company_id = j.company_id
JOIN applications a 
    ON j.job_id = a.job_id
LEFT JOIN interviews i 
    ON a.application_id = i.application_id
LEFT JOIN offers o 
    ON a.application_id = o.application_id
GROUP BY c.company_id, c.company_name;

-- Top 10 skills with highest offer acceptance rate.
SELECT
    c.primary_skill,
    COUNT(o.offer_id) AS total_offers,
    SUM(CASE WHEN o.offer_status = 'Accepted' THEN 1 ELSE 0 END) AS accepted_offers,
    ROUND(
        SUM(CASE WHEN o.offer_status = 'Accepted' THEN 1 ELSE 0 END) * 1.0
        / COUNT(o.offer_id), 2
    ) AS acceptance_rate
FROM candidates c
JOIN applications a 
    ON c.candidate_id = a.candidate_id
JOIN offers o 
    ON a.application_id = o.application_id
GROUP BY c.primary_skill
HAVING COUNT(o.offer_id) > 0
ORDER BY acceptance_rate DESC
LIMIT 10;

