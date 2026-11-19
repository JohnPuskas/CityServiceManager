USE CityServiceManager;
GO

-- Validate work order status, priority, and timestamp consistency.
-- Status and priority counts should match the expected distributions
-- and queries identifying inconsistent records should return 0 rows.
-- Read-only Select statements; no database records are modified.

-- Verify the expected distribution of work order statuses.
-- Expected: 750 Completed, 450 In Progress, 300 Open.
SELECT
    Status,
    COUNT(*) AS WorkOrderCount
FROM dbo.WorkOrders
GROUP BY Status
ORDER BY Status;
GO

-- Verify the expected distribution of work order priorities.
-- Expected: 300 High, 300 Low, 900 Normal.
SELECT
    Priority,
    COUNT(*) AS WorkOrderCount
FROM dbo.WorkOrders
GROUP BY Priority
ORDER BY Priority;
GO

-- Identify work orders with timestamps inconsistent with their status.
-- Expected: 0 rows.
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