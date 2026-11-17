USE CityServiceManager;
GO

INSERT INTO dbo.RequestTypes (Name)
SELECT rt.Name
FROM
(
    VALUES
        ('Pothole Repair'),
        ('Streetlight Repair'),
        ('Traffic Sign Repair'),
        ('Sidewalk Repair'),
        ('Water Leak'),
        ('Sewer Backup'),
        ('Missed Trash Collection'),
        ('Illegal Dumping'),
        ('Park Maintenance'),
        ('Tree Maintenance'),
        ('Property Code Violation'),
        ('Graffiti Removal')
) AS rt(Name)
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.RequestTypes AS existing
    WHERE existing.Name = rt.Name
);
GO