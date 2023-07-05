-- create employees table
CREATE TABLE IF NOT EXISTS public.employees
(
    id serial PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    hire_date date NOT NULL,
    hourly_salary numeric(5, 2) NOT NULL,
    title_id integer NOT NULL,
    manager_id integer,
    team_id integer
);
--  import data
COPY public.employees
(
    first_name,
    last_name,
    hire_date,
    hourly_salary,
    title_id,
    manager_id,
    team_id
)
FROM '/Users/khanhngguyen/Desktop/KHANH/Integrify/fs15_16_company-database/data/employees.csv'
DELIMITER ','
CSV HEADER QUOTE '\"' 
NULL 'NULL';

-- create titles table
CREATE TABLE IF NOT EXISTS public.titles
(
    id serial PRIMARY KEY,
    title VARCHAR(50) NOT NULL
);

-- import data
COPY public.titles
(
    name
)
FROM '/Users/khanhngguyen/Desktop/KHANH/Integrify/fs15_16_company-database/data/titles.csv'
DELIMITER ',' 
CSV HEADER QUOTE '\"' 
NULL 'NULL';

-- create teams table
CREATE TABLE IF NOT EXISTS public.teams
(
    id serial PRIMARY KEY,
    team_name VARCHAR(50) NOT NULL,
    location VARCHAR(50) NOT NULL
)

-- import data
COPY public.teams 
(
    team_name, location
) 
FROM '/Users/khanhngguyen/Desktop/KHANH/Integrify/fs15_16_company-database/data/teams.csv' 
DELIMITER ',' 
CSV HEADER QUOTE '\"' 
NULL 'NULL';

-- create projects table
CREATE TABLE public.projects
(
    id serial PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    client VARCHAR(100) NOT NULL,
    start_date date NOT NULL,
    deadline date NOT NULL
);

-- import data
COPY public.projects 
(
    project_name, client, start_date, deadline
) 
FROM '/Users/khanhngguyen/Desktop/KHANH/Integrify/fs15_16_company-database/data/projects.csv' 
DELIMITER ',' 
CSV HEADER QUOTE '\"' 
NULL 'NULL';

-- create team_project table
CREATE TABLE public.team_project
(
    id serial PRIMARY KEY,
    team_id integer 
        REFERENCES public.teams (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
    project_id integer
        REFERENCES public.projects (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- import data
COPY public.team_project 
(
    team_id, project_id
) 
FROM '/Users/khanhngguyen/Desktop/KHANH/Integrify/fs15_16_company-database/data/team_project.csv' 
DELIMITER ',' 
CSV HEADER QUOTE '\"' 
NULL 'NULL';