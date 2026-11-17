USE CityServiceManager;
GO

-- Verify that the required supporting data exists.
IF (SELECT COUNT(*) FROM dbo.RequestTypes) <> 12
    THROW 50010, 'Expected 12 request types.', 1;

IF (SELECT COUNT(*) FROM dbo.Locations) <> 250
    THROW 50011, 'Expected 250 locations.', 1;
GO

-- Generate 2,000 reproducible synthetic service requests.
;WITH Numbers AS
(
    SELECT
        thousands.n * 1000
        + hundreds.n * 100
        + tens.n * 10
        + ones.n + 1 AS RequestNumber
    FROM (VALUES (0),(1)) AS thousands(n)
    CROSS JOIN (VALUES (0),(1),(2),(3),(4),
                       (5),(6),(7),(8),(9)) AS hundreds(n)
    CROSS JOIN (VALUES (0),(1),(2),(3),(4),
                       (5),(6),(7),(8),(9)) AS tens(n)
    CROSS JOIN (VALUES (0),(1),(2),(3),(4),
                       (5),(6),(7),(8),(9)) AS ones(n)
),
RequestTypeLookup AS
(
    SELECT
        RequestTypeID,
        Name,
        ROW_NUMBER() OVER (
            ORDER BY Name
        ) AS TypeNumber
    FROM dbo.RequestTypes
),
LocationLookup AS
(
    SELECT
        LocationID,
        ROW_NUMBER() OVER (
            ORDER BY StreetAddress, PostalCode
        ) AS LocationNumber
    FROM dbo.Locations
),
GeneratedRequests AS
(
    SELECT
        n.RequestNumber,
        rt.RequestTypeID,
        l.LocationID,
       
        -- Generate a description containing a four-digit, zero-padded
        -- request number and its associated request type.
        CONCAT(
            'Synthetic request #',
            RIGHT('0000' + CAST(n.RequestNumber AS VARCHAR(4)), 4),
            ' - ',
            rt.Name
        ) AS Description,

        -- Distribute submission dates over a fixed 650-day period.
        DATEADD(
            DAY,
            (n.RequestNumber - 1) % 650,
            DATEADD(
                MINUTE,
                (n.RequestNumber * 53) % 600,
                CAST('2025-01-01T08:00:00' AS DATETIME2)
            )
        ) AS SubmittedAt

    FROM Numbers AS n

    -- Distribute requests evenly across all 12 request types.
    INNER JOIN RequestTypeLookup AS rt
        ON rt.TypeNumber = (n.RequestNumber - 1) % 12 + 1
    
    -- Distribute requests across all 250 locations in a consistent,
    -- non-sequential pattern, using 37 to ensure each location is included.
    INNER JOIN LocationLookup AS l
        ON l.LocationNumber = ((n.RequestNumber - 1) * 37) % 250 + 1
),
FinalRequests AS
(
    SELECT
        RequestTypeID,
        LocationID,
        Description,
        SubmittedAt,

        -- Cancel every tenth request, 1-5 days after submission.
        CASE
            WHEN RequestNumber % 10 = 0
                THEN DATEADD(
                    DAY,
                    1 + RequestNumber % 5,
                    SubmittedAt
                )
            ELSE NULL
        END AS CanceledAt

    FROM GeneratedRequests
)
INSERT INTO dbo.ServiceRequests
    (RequestTypeID, LocationID, Description,
     SubmittedAt, CanceledAt)
SELECT
    r.RequestTypeID,
    r.LocationID,
    r.Description,
    r.SubmittedAt,
    r.CanceledAt
FROM FinalRequests AS r

-- Skip previously generated requests on subsequent executions.
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.ServiceRequests AS existing
    WHERE existing.Description = r.Description
);
GO