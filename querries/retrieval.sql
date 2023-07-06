-- 1. Retrieve the team names and their corresponding project count.
SELECT
    team_name,
    COUNT(tp.team_id) as project_count
FROM public.teams t
JOIN public.team_project tp
ON t.id = tp.team_id
GROUP BY team_name
ORDER BY team_name

-- 2. Retrieve the projects managed by the managers whose first name starts with "J" or "D".
WITH managers AS (
	SELECT 
        DISTINCT m.id AS manager_id,
        m.first_name AS manager_first_name,
        m.last_name AS manager_last_name
    FROM employees e
    JOIN employees m
    ON e.manager_id = m.id
    ORDER BY manager_id
),
teams_and_managers AS (
	SELECT
        DISTINCT t.id,
        t.team_name,
        m.manager_first_name,
        m.manager_last_name
    FROM teams t
    JOIN employees e
    ON t.id = e.team_id
    JOIN managers m
    ON e.manager_id = m.manager_id
    ORDER BY t.id
)

SELECT
	DISTINCT tp.project_id,
	p.project_name,
	tm.manager_first_name,
	tm.manager_last_name
    FROM team_project tp
    JOIN projects p
    ON tp.project_id = p.id
    JOIN teams_and_managers tm
    ON tp.team_id = tm.id
    WHERE
        tm.manager_first_name LIKE 'J%'
        OR tm.manager_first_name LIKE 'D%'
    ORDER BY
        tm.manager_first_name,
        tp.project_id, 

-- 3. Retrieve all the employees (both directly and indirectly) working under Andrew Martin
WITH e_m AS (
SELECT
	m.id AS manager_id,
	concat(m.first_name, ' ', m.last_name) AS manager,
	e.id AS employee_id,
	concat(e.first_name, ' ', e.last_name) AS employee
FROM public.employees e
LEFT JOIN public.employees m
ON e.manager_id = m.id
)

SELECT
	em1.manager_id,
	em1.manager,
	em1.employee_id AS direct_e_id,
	em1.employee AS direct_employee,
	em2.employee_id AS indirect_e_id,
	em2.employee AS indirect_employee
FROM e_m em1
LEFT JOIN e_m em2
ON em1.employee_id = em2.manager_id
WHERE
	em1.manager_id IS NOT NULL
	AND em1.manager = 'Andrew Martin'
ORDER BY
	em1.manager_id

-- 4. Retrieve all the employees (both directly and indirectly) working under Robert Brown
WITH e_m AS (
SELECT
	m.id AS manager_id,
	concat(m.first_name, ' ', m.last_name) AS manager,
	e.id AS employee_id,
	concat(e.first_name, ' ', e.last_name) AS employee
FROM public.employees e
LEFT JOIN public.employees m
ON e.manager_id = m.id
)

SELECT
	em1.manager_id,
	em1.manager,
	em1.employee_id AS direct_e_id,
	em1.employee AS direct_employee,
	em2.employee_id AS indirect_e_id,
	em2.employee AS indirect_employee
FROM e_m em1
LEFT JOIN e_m em2
ON em1.employee_id = em2.manager_id
WHERE
	em1.manager_id IS NOT NULL
	AND em1.manager = 'Robert Brown'
ORDER BY
	em1.manager_id

-- 5. Retrieve the average hourly salary for each title.
WITH title_salary AS (
	SELECT
		e.title_id,
		t.title,
		e.hourly_salary
	FROM public.employees e
	JOIN public.titles t
	ON e.title_id = t.id
	ORDER BY e.title_id
)

SELECT 
	title_id,
	title,
	AVG(hourly_salary) AS avg_hourly_salary
FROM title_salary
GROUP BY
	title_id,
	title
ORDER BY title_id

-- 6. Retrieve the employees who have a higher hourly salary than their respective team's average hourly salary.
WITH team_avg_salary AS (
    SELECT
        t.id,
        t.team_name,
    -- 	e.first_name,
        AVG(e.hourly_salary) as team_avg_hourly_salary
    -- 	e.hourly_salary
    FROM public.teams t
    JOIN public.employees e
    ON t.id = e.team_id
    GROUP BY
        t.id
    ORDER BY 
        t.id
)

SELECT
	t.id AS team_id,
	t.team_name,
	e.id AS employee_id,
	e.first_name AS employee_fName,
	e.hourly_salary AS employee_hourly_salary,
	t.team_avg_hourly_salary
FROM public.employees e
JOIN team_avg_salary t
ON e.team_id = t.id
GROUP BY
	e.id,
	t.team_avg_hourly_salary,
	t.id,
	t.team_name
HAVING e.hourly_salary > t.team_avg_hourly_salary
ORDER BY
	t.id,
	e.id

-- 7. Retrieve the projects that have more than 3 teams assigned to them.
SELECT
	p.id AS project_id,
	p.project_name,
	COUNT(*) AS no_of_teams
FROM public.projects p
JOIN public.team_project tp
ON p.id = tp.project_id
JOIN public.teams t
ON tp.team_id = t.id
GROUP BY
	p.id
HAVING 
	COUNT(*) > 3
ORDER BY
	COUNT(*) DESC

-- 8. Retrieve the total hourly salary expense for each team.
SELECT
	t.id,
	t.team_name,
	SUM(e.hourly_salary) AS hourly_salary_expense
FROM public.teams t
JOIN public.employees e
ON t.id = e.team_id
GROUP BY
	t.id
ORDER BY t.id

