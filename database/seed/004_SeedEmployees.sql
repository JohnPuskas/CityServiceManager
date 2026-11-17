USE CityServiceManager;
GO

-- Generate 40 synthetic employees from unique first/last name combinations.
-- Use a fixed name set and ordering to keep the generated data reproducible.
;WITH FirstNames AS
(
    SELECT FirstName
    FROM (VALUES
        ('Adrian'),
        ('Ben'),
        ('Caleb'),
        ('Diana'),
        ('Ethan'),
        ('Farah'),
        ('Gavin'),
        ('Hannah')
    ) AS f(FirstName)
),
LastNames AS
(
    SELECT LastName
    FROM (VALUES
        ('Mercer'),
        ('Bennett'),
        ('Rivera'),
        ('Collins'),
        ('Morgan')
    ) AS l(LastName)
),
GeneratedEmployees AS
(
    SELECT
        ROW_NUMBER() OVER (
            ORDER BY f.FirstName, l.LastName
        ) AS EmployeeNumber,
        f.FirstName,
        l.LastName
    FROM FirstNames AS f
    CROSS JOIN LastNames AS l
),
EmployeeDepartments AS
(
    SELECT
        e.FirstName,
        e.LastName,

        -- Assign employees to departments using a planned staffing distribution.
        CASE
            WHEN e.EmployeeNumber <= 8
                THEN 'Public Works'
            WHEN e.EmployeeNumber <= 14
                THEN 'Parks and Recreation'
            WHEN e.EmployeeNumber <= 22
                THEN 'Streets and Transportation'
            WHEN e.EmployeeNumber <= 29
                THEN 'Water Services'
            WHEN e.EmployeeNumber <= 34
                THEN 'Code Enforcement'
            ELSE 'Sanitation'
        END AS DepartmentName
    FROM GeneratedEmployees AS e
)
INSERT INTO dbo.Employees
    (DepartmentID, FirstName, LastName)
SELECT
    d.DepartmentID,
    e.FirstName,
    e.LastName
FROM EmployeeDepartments AS e

-- Resolve department IDs by name rather than relying on identity values.
INNER JOIN dbo.Departments AS d
    ON d.Name = e.DepartmentName

-- Skip employees already present to support repeatable seed execution.
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.Employees AS existing
    WHERE existing.DepartmentID = d.DepartmentID
      AND existing.FirstName = e.FirstName
      AND existing.LastName = e.LastName
);
GO