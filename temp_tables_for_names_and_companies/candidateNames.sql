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
