USE CityServiceManager;
GO

-- Verify the expected distribution of work order statuses.
SELECT
    Status,
    COUNT(*) AS WorkOrderCount
FROM dbo.WorkOrders
GROUP BY Status
ORDER BY Status;
GO

-- Verify the expected distribution of work order priorities.
SELECT
    Priority,
    COUNT(*) AS WorkOrderCount
FROM dbo.WorkOrders
GROUP BY Priority
ORDER BY Priority;
GO

-- Identify work orders with timestamps inconsistent with their status.
SELECT
    WorkOrderID,
    Status,
    StartedAt,
    CompletedAt
FROM dbo.WorkOrders
WHERE
    (Status = 'Open'
        AND (StartedAt IS NOT NULL
             OR CompletedAt IS NOT NULL))
    OR
    (Status = 'In Progress'
        AND (StartedAt IS NULL
             OR CompletedAt IS NOT NULL))
    OR
    (Status = 'Completed'
        AND (StartedAt IS NULL
             OR CompletedAt IS NULL));
GO