-- function track_working_hours
CREATE OR REPLACE FUNCTION track_working_hours(employee_id integer, projectId integer, total_hours numeric(6, 2))
RETURNS VOID
AS 
$$
BEGIN
	IF NOT EXISTS (SELECT * FROM public.employees WHERE id = employee_id) THEN
		RAISE EXCEPTION 'Employee does not exist';
	ELSIF NOT EXISTS (SELECT * FROM public.projects p WHERE id = projectId) THEN
		RAISE EXCEPTION 'Project does not exist';
	ELSE
		IF NOT EXISTS (
			SELECT
				e.id,
				e.first_name,
				p.id,
				p.project_name
			FROM public.employees e
			JOIN public.team_project tp
			ON e.team_id = tp.team_id
			JOIN public.projects P
			ON p.id = tp.project_id
			WHERE
				e.id = employee_id
				AND p.id = projectId
		) THEN RAISE EXCEPTION 'Employee does not work on this project, can not add hours';
		ELSE
			INSERT INTO public.hour_tracking(employee_id, project_id, total_hours)
			VALUES(employee_id, projectId, total_hours);
		END IF;
	END IF;
END;
$$
LANGUAGE plpgsql;

-- testing function
SELECT track_working_hours(20, 7, 40.5);
SELECT track_working_hours(23, 7, 32.25);
SELECT track_working_hours(12, 7, 22.75); --should raise exception

-- function create_project_with_teams
CREATE OR REPLACE FUNCTION create_project_with_teams(projectName VARCHAR(100), clientName VARCHAR(100), startDate date, endDate date, teams integer[])
RETURNS VOID
AS
$$
DECLARE
	num integer;
	projectId integer;
BEGIN
	IF EXISTS (SELECT * FROM public.projects WHERE project_name = projectName) THEN
		RAISE EXCEPTION 'Project already exists';
	ELSE
		INSERT INTO public.projects(project_name, client, start_date, deadline)
		VALUES(projectName, clientName, startDate, endDate);
		SELECT id INTO projectId FROM public.projects WHERE project_name = projectName;
		FOREACH num IN ARRAY teams
			LOOP
				IF NOT EXISTS (SELECT * FROM public.teams WHERE id = num) THEN
						RAISE EXCEPTION 'Team ids do not exist';
				ELSE
					INSERT INTO public.team_project(team_id, project_id)
					VALUES(num, projectId);
				END IF;
			END LOOP;
	END IF;
END;
$$
LANGUAGE plpgsql;

-- testing function
SELECT create_project_with_teams(
    'New Project',
    'Client XYZ',
    '2023-07-01',
    '2023-12-31',
    ARRAY[1, 2, 3]
);

