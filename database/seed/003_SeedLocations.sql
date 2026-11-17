USE CityServiceManager;
GO

-- Generate 50 address numbers for each of five streets
WITH Numbers AS
(
    SELECT
        tens.n * 10 + ones.n + 1 AS Number
    FROM
        (VALUES (0),(1),(2),(3),(4)) AS tens(n)
    CROSS JOIN
        (VALUES (0),(1),(2),(3),(4),
                (5),(6),(7),(8),(9)) AS ones(n)
),
Streets AS
(
    SELECT
        StreetName,
        PostalCode
    FROM
    (
        VALUES
            ('Civic Test Way', '63101'),
            ('Sample Park Road', '63104'),
            ('Demo River Lane', '63109'),
            ('Model Oak Street', '63116'),
            ('Example Transit Avenue', '63118')
    ) AS s(StreetName, PostalCode)
),
GeneratedLocations AS
(
    SELECT
        CONCAT(1000 + n.Number, ' ', s.StreetName)
            AS StreetAddress,
        'Sampleton' AS City,
        'MO' AS StateCode,
        s.PostalCode
    FROM Numbers AS n
    CROSS JOIN Streets AS s
)
INSERT INTO dbo.Locations
    (StreetAddress, City, StateCode, PostalCode)
SELECT
    g.StreetAddress,
    g.City,
    g.StateCode,
    g.PostalCode
FROM GeneratedLocations AS g
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.Locations AS existing
    WHERE existing.StreetAddress = g.StreetAddress
      AND existing.City = g.City
      AND existing.StateCode = g.StateCode
      AND existing.PostalCode = g.PostalCode
);
GO