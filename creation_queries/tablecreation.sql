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

CREATE TABLE companies (
    company_id INT PRIMARY KEY,
    company_name VARCHAR(100),
    industry VARCHAR(50),
    company_size VARCHAR(50),
    headquarters_country VARCHAR(50),
    founded_year INT
);

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

CREATE TABLE interviews (
    interview_id INT PRIMARY KEY,
    application_id INT,
    interview_round INT,
    interview_type VARCHAR(50),
    interview_score DECIMAL(4,2),
    interview_date DATE,
    FOREIGN KEY (application_id) REFERENCES applications(application_id)
);

CREATE TABLE offers (
    offer_id INT PRIMARY KEY,
    application_id INT,
    offered_salary INT,
    equity_offered BOOLEAN,
    offer_status VARCHAR(50),
    offer_date DATE,
    FOREIGN KEY (application_id) REFERENCES applications(application_id)
);
