# SQL Interview & Analytics Practice

This repository contains a comprehensive set of SQL practice questions designed to simulate **real-world hiring, recruiting, and marketplace analytics scenarios**.  
The problems are organized by difficulty, progressing from foundational queries to insane data analysis challenges.

---

## CREATING TABLES
``` text
CREATE TABLE candidates (
    candidate_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100),
    gender VARCHAR(20),
    education_level VARCHAR(50),
    years_experience INT,
    primary_skill VARCHAR(50),
    country VARCHAR(50),
    created_at DATE
);
```
``` text
CREATE TABLE companies (
    company_id INT PRIMARY KEY,
    company_name VARCHAR(100),
    industry VARCHAR(50),
    company_size VARCHAR(50),
    headquarters_country VARCHAR(50),
    founded_year INT
);
```
``` text
CREATE TABLE jobs (
    job_id INT PRIMARY KEY,
    company_id INT,
    job_title VARCHAR(100),
    job_level VARCHAR(50),
    job_type VARCHAR(50),
    remote_allowed BOOLEAN,
    salary_min INT,
    salary_max INT,
    location_country VARCHAR(50),
    posted_date DATE,
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
);
```
``` text
CREATE TABLE applications (
    application_id INT PRIMARY KEY,
    candidate_id INT,
    job_id INT,
    application_date DATE,
    application_status VARCHAR(50),
    recruiter_score DECIMAL(4,2),
    FOREIGN KEY (candidate_id) REFERENCES candidates(candidate_id),
    FOREIGN KEY (job_id) REFERENCES jobs(job_id)
);
```
``` text
CREATE TABLE interviews (
    interview_id INT PRIMARY KEY,
    application_id INT,
    interview_round INT,
    interview_type VARCHAR(50),
    interview_score DECIMAL(4,2),
    interview_date DATE,
    FOREIGN KEY (application_id) REFERENCES applications(application_id)
);
```
``` text
CREATE TABLE offers (
    offer_id INT PRIMARY KEY,
    application_id INT,
    offered_salary INT,
    equity_offered BOOLEAN,
    offer_status VARCHAR(50),
    offer_date DATE,
    FOREIGN KEY (application_id) REFERENCES applications(application_id)
);
```
## INSERTING ROWS
``` text
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
```
``` text
-- COMPANIES
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
```
``` text
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
```
``` text
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
```
``` text
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
```

## FIXING CANDIDATE NAMES

``` text
-- RUN IN SAME CONNECTION WHERE YOU MADE ALL TABLES AND DATABASE
CREATE TEMP TABLE temp_candidate_names (
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100)
);
\COPY temp_candidate_names(first_name, last_name, email) FROM '/Users/murtazahussain/Downloads/candidate_names.csv' CSV HEADER;

UPDATE candidates c
SET
    first_name = t.first_name,
    last_name = t.last_name,
    email = t.email
FROM (
    SELECT first_name, last_name, email, row_number() OVER () AS rn
    FROM temp_candidate_names
) AS t
WHERE c.candidate_id = t.rn;
```
``` text
## FIXING COMPANY NAMES

CREATE TEMP TABLE temp_company_names (
    company_name TEXT
);

\COPY temp_company_names(company_name) FROM '/Users/murtazahussain/Downloads/company_names.csv' CSV HEADER;

UPDATE companies c
SET company_name = t.company_name
FROM (
    SELECT company_name, row_number() OVER () AS rn
    FROM temp_company_names
) AS t
WHERE c.company_id = t.rn;
```
## 🟢 EASY — Foundational SQL

Basic filtering, grouping, and aggregation.

- List all candidates with more than **5 years of experience**
- Find all **remote jobs** posted in the **last 30 days**
- Count the **number of jobs per country**
- Show **average salary range per job title**
- List all **applications that were rejected**

---

## 🟡 INTERMEDIATE — Joins & Aggregations

Multi-table queries and deeper aggregation logic.

- Find **top 5 companies** with the most job postings
- Calculate **average recruiter score by job title**
- Count **number of applications per candidate** (top 10)
- Compare **salary offered vs salary range** per job
- Calculate **interview count per application**

---

## 🟠 ADVANCED — Subqueries & CTEs

Complex logic, multi-step reasoning, and business insights.

- Candidates who applied to **more than 5 jobs** but received **no offers**
- Companies whose **average offered salary exceeds market average**
- Jobs where the **interview score decreases each round**
- Conversion rate: **application → interview → offer** per company
- Top **10 skills** with the highest **offer acceptance rate**

---

## 🔴 EXPERT — Window Functions ( SOLUTIONS COMING SOON )
 
Ranking, rolling metrics, and advanced analytics.

- Rank candidates **within each country** by experience
- Compute **rolling average offered salary over time**
- Calculate **salary percentiles within each job title**
- Measure **time-to-hire per job** (posting → offer)
- Detect recruiters with **score inflation** (standard deviation analysis)

---

## 🟣 INSANE — GOD LEVEL SQL ( SOLUTIONS COMING SOON )

End-to-end analytics, bias detection, and behavioral insights.

- Funnel **drop-off analysis** by job level
- **Bias analysis**: recruiter scores by gender & experience
- Identify **ghost jobs** (high applicants, no interviews)
- **Cohort analysis**: candidate performance by signup month
- Detect **salary compression** within companies

---

## Goals

- Practice **real-world SQL patterns**
- Master **joins, CTEs, window functions**
- Develop **analytics intuition** used in hiring, HR tech, and marketplaces
- Prepare for **technical interviews** and **data-heavy roles**

---

Happy querying
