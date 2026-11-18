USE CityServiceManager;
GO

-- Verify the expected service request data exists.
IF (SELECT COUNT(*) FROM dbo.ServiceRequests) <> 2000
    THROW 50020, 'Expected 2,000 service requests.', 1;

IF (
    SELECT COUNT(*)
    FROM dbo.ServiceRequests
    WHERE CanceledAt IS NULL
) <> 1800
    THROW 50021, 'Expected 1,800 non-canceled requests.', 1;
GO

-- Number non-canceled requests consistently by description,
-- allowing the first 1,500 to be selected for work order creation.
;WITH EligibleRequests AS
(
    SELECT
        sr.ServiceRequestID,
        sr.SubmittedAt,
        rt.Name AS RequestTypeName,
        ROW_NUMBER() OVER (
            ORDER BY sr.Description
        ) AS WorkOrderNumber
    FROM dbo.ServiceRequests AS sr
    INNER JOIN dbo.RequestTypes AS rt
        ON sr.RequestTypeID = rt.RequestTypeID
    WHERE sr.CanceledAt IS NULL
),
SelectedRequests AS
(
    SELECT
        ServiceRequestID,
        SubmittedAt,
        WorkOrderNumber,

        -- Assign departments based on service request type.
        CASE
            WHEN RequestTypeName IN
                ('Sidewalk Repair', 'Graffiti Removal')
                THEN 'Public Works'
            WHEN RequestTypeName IN
                ('Park Maintenance', 'Tree Maintenance')
                THEN 'Parks and Recreation'
            WHEN RequestTypeName IN
                ('Pothole Repair', 'Streetlight Repair',
                 'Traffic Sign Repair')
                THEN 'Streets and Transportation'
            WHEN RequestTypeName IN
                ('Water Leak', 'Sewer Backup')
                THEN 'Water Services'
            WHEN RequestTypeName = 'Property Code Violation'
                THEN 'Code Enforcement'
            WHEN RequestTypeName IN
                ('Missed Trash Collection', 'Illegal Dumping')
                THEN 'Sanitation'
        END AS DepartmentName

    FROM EligibleRequests
    WHERE WorkOrderNumber <= 1500
)
INSERT INTO dbo.WorkOrders
(
    ServiceRequestID,
    DepartmentID,
    Status,
    Priority,
    CreatedAt,
    StartedAt,
    DueAt,
    CompletedAt
)
SELECT
    r.ServiceRequestID,
    d.DepartmentID,

    -- Repeat a 10-record pattern to assign statuses:
    -- 5 Completed, 3 In Progress, and 2 Open.
    CASE
        WHEN r.WorkOrderNumber % 10 BETWEEN 1 AND 5
            THEN 'Completed'
        WHEN r.WorkOrderNumber % 10 BETWEEN 6 AND 8
            THEN 'In Progress'
        ELSE 'Open'
    END AS Status,

    -- Assign priorities in a repeating 5-record pattern:
    -- 1 High, 1 Low, and 3 Normal.
    CASE
        WHEN r.WorkOrderNumber % 5 = 0 THEN 'High'
        WHEN r.WorkOrderNumber % 5 = 1 THEN 'Low'
        ELSE 'Normal'
    END AS Priority,

    dates.CreatedAt,

    -- Open work orders have not started.
    CASE
        WHEN r.WorkOrderNumber % 10 BETWEEN 1 AND 8
            THEN dates.StartedAt
        ELSE NULL
    END AS StartedAt,

    dates.DueAt,

    -- Assign completion dates 3–11 days after work begins,
    -- allowing some work orders to finish past their due dates.
    CASE
        WHEN r.WorkOrderNumber % 10 BETWEEN 1 AND 5
            THEN DATEADD(
                DAY,
                3 + r.WorkOrderNumber % 9,
                dates.StartedAt
            )
        ELSE NULL
    END AS CompletedAt

FROM SelectedRequests AS r

-- Resolve department IDs without hard-coding identity values.
INNER JOIN dbo.Departments AS d
    ON d.Name = r.DepartmentName

-- Calculate reusable timestamps for each work order.
CROSS APPLY
(
    SELECT
        DATEADD(
            DAY,
            1 + r.WorkOrderNumber % 3,
            r.SubmittedAt
        ) AS CreatedAt
) AS created

CROSS APPLY
(
    SELECT
        created.CreatedAt,
        DATEADD(DAY, 1, created.CreatedAt) AS StartedAt,
        DATEADD(DAY, 7, created.CreatedAt) AS DueAt
) AS dates

-- Skip requests that already have a work order.
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.WorkOrders AS existing
    WHERE existing.ServiceRequestID = r.ServiceRequestID
);
GO