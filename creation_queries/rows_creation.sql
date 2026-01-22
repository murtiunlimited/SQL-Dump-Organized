-- CANDIDATES
-- NOTE: NAMES WILL NOT BE GIVEN
INSERT INTO candidates
SELECT
    gs AS candidate_id,
    'FirstName_' || gs AS first_name,
    'LastName_' || gs AS last_name,
    'candidate' || gs || '@email.com' AS email,
    (ARRAY['Male','Female','Other'])[1 + floor(random()*3)::int] AS gender,
    (ARRAY['High School','Bachelor','Master','PhD'])[1 + floor(random()*4)::int] AS education_level,
    floor(random()*15)::int AS years_experience,
    (ARRAY['Python','Java','SQL','JavaScript','Data Science','DevOps'])[1 + floor(random()*6)::int] AS primary_skill,
    (ARRAY['USA','Canada','UK','Germany','India','Australia'])[1 + floor(random()*6)::int] AS country,
    CURRENT_DATE - (floor(random()*1500)::int) AS created_at
FROM generate_series(1,5000) gs;

-- CANDIDATES
-- NOTE: COMANY NAMES WILL BE PUT AS PLACEHOLDERS e.g Company_1, Company_2, etc
INSERT INTO companies
SELECT
    gs AS company_id,
    'Company_' || gs AS company_name,
    (ARRAY['Technology','Finance','Healthcare','Retail','Manufacturing'])[1 + floor(random()*5)::int] AS industry,
    (ARRAY['Small','Medium','Large','Enterprise'])[1 + floor(random()*4)::int] AS company_size,
    (ARRAY['USA','Canada','UK','Germany','India'])[1 + floor(random()*5)::int] AS headquarters_country,
    1980 + floor(random()*40)::int AS founded_year
FROM generate_series(1,150) gs;

-- JOBS
INSERT INTO jobs
SELECT
    gs AS job_id,
    1 + floor(random()*150)::int AS company_id,   -- valid companies
    (ARRAY[
        'Software Engineer',
        'Data Analyst',
        'Product Manager',
        'DevOps Engineer',
        'QA Engineer'
    ])[1 + floor(random()*5)::int] AS job_title,
    (ARRAY['Junior','Mid','Senior','Lead'])[1 + floor(random()*4)::int] AS job_level,
    (ARRAY['Full-time','Contract','Internship'])[1 + floor(random()*3)::int] AS job_type,
    random() > 0.5 AS remote_allowed,
    40000 + floor(random()*40000)::int AS salary_min,
    90000 + floor(random()*60000)::int AS salary_max,
    (ARRAY['USA','Canada','UK','Germany','India','Remote'])[1 + floor(random()*6)::int] AS location_country,
    CURRENT_DATE - (floor(random()*365)::int) AS posted_date
FROM generate_series(1,2500) gs;

-- APPLICATIONS
INSERT INTO applications
SELECT
    gs AS application_id,
    1 + floor(random()*5000)::int AS candidate_id,  -- VALID candidate
    1 + floor(random()*2500)::int AS job_id,        -- VALID job
    CURRENT_DATE - (floor(random()*365)::int) AS application_date,
    (ARRAY['Applied','Screening','Interviewing','Rejected','Hired'])[1 + floor(random()*5)::int] AS application_status,
    round((random()*4 + 1)::numeric, 2) AS recruiter_score
FROM generate_series(1,12000) gs;
INSERT INTO interviews
SELECT
    gs AS interview_id,
    1 + floor(random()*12000)::int AS application_id,  -- VALID APP
    1 + floor(random()*4)::int AS interview_round,     -- 5 ROUNDS
    (ARRAY['Phone','Technical','HR','Managerial'])[1 + floor(random()*4)::int] AS interview_type,
    round((random()*4 + 1)::numeric, 2) AS interview_score,  -- 1 to 5
    CURRENT_DATE - (floor(random()*300)::int) AS interview_date
FROM generate_series(1,20000) gs;

-- OFFERS
INSERT INTO offers
SELECT
    gs AS offer_id,
    1 + floor(random()*12000)::int AS application_id,
    70000 + floor(random()*80000)::int AS offered_salary,  -- 70k–150k
    random() > 0.6 AS equity_offered,                      -- ABOUT 40% true
    (ARRAY['Extended','Accepted','Rejected'])[1 + floor(random()*3)::int] AS offer_status,
    CURRENT_DATE - (floor(random()*180)::int) AS offer_date
FROM generate_series(1,4000) gs;

