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
