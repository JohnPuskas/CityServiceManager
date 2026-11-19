USE CityServiceManager;
GO

-- Validate chronological consistency across work orders
-- and employee assignments.
-- Queries identifying invalid dates should return 0 rows.
-- Read-only Select statements; no database records are modified.

-- Identify work orders with an invalid chronological sequence.
-- Expected: 0 rows.
SELECT
    wo.WorkOrderID,
    sr.SubmittedAt,
    wo.CreatedAt,
    wo.StartedAt,
    wo.CompletedAt
FROM dbo.WorkOrders AS wo
INNER JOIN dbo.ServiceRequests AS sr
    ON sr.ServiceRequestID = wo.ServiceRequestID
WHERE wo.CreatedAt < sr.SubmittedAt
   OR wo.StartedAt < wo.CreatedAt
   OR wo.CompletedAt < wo.StartedAt;
GO

-- Verify that due dates occur seven days after creation.
-- Expected: 0 rows.
SELECT
    WorkOrderID,
    CreatedAt,
    DueAt
FROM dbo.WorkOrders
WHERE DueAt IS NULL
   OR DueAt <> DATEADD(DAY, 7, CreatedAt);
GO

-- Identify employee assignments occurring outside the
-- expected period between work order creation and start.
-- Expected: 0 rows.
SELECT
    woa.WorkOrderID,
    woa.EmployeeID,
    wo.CreatedAt,
    woa.AssignedAt,
    wo.StartedAt
FROM dbo.WorkOrderAssignments AS woa
INNER JOIN dbo.WorkOrders AS wo
    ON wo.WorkOrderID = woa.WorkOrderID
WHERE woa.AssignedAt < wo.CreatedAt
   OR (
        wo.StartedAt IS NOT NULL
        AND woa.AssignedAt > wo.StartedAt
   );
GO