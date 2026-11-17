USE CityServiceManager;
GO

INSERT INTO dbo.Departments (Name)
SELECT d.Name
FROM
(
    VALUES
        ('Public Works'),
        ('Parks and Recreation'),
        ('Streets and Transportation'),
        ('Water Services'),
        ('Code Enforcement'),
        ('Sanitation')
) AS d(Name)
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.Departments AS existing
    WHERE existing.Name = d.Name
);
GO