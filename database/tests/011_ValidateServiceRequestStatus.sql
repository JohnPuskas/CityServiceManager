USE CityServiceManager;
GO

-- Validate the derived service request statuses produced by
-- dbo.vw_ServiceRequestStatus.
-- These are read-only queries verifying status distribution, row uniqueness,
-- status consistency, and representative records.


-- Verify the distribution of derived service request statuses.
-- Expected: 200 Canceled, 750 Closed, 450 In Progress, 600 Open.
SELECT
    EffectiveStatus,
    COUNT(*) AS RequestCount
FROM dbo.vw_ServiceRequestStatus
GROUP BY EffectiveStatus
ORDER BY EffectiveStatus;
GO

-- Verify that the view contains one row per service request.
-- Expected: 2,000 total rows and 2,000 distinct ServiceRequestIDs.
SELECT
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT ServiceRequestID) AS DistinctRequests
FROM dbo.vw_ServiceRequestStatus;
GO

-- Identify requests whose derived status differs from
-- the expected status based on their work order.
-- Expected: 0 rows.
SELECT
    sr.ServiceRequestID,
    v.EffectiveStatus,
    CASE
        WHEN sr.CanceledAt IS NOT NULL THEN 'Canceled'
        WHEN wo.Status = 'Completed' THEN 'Closed'
        WHEN wo.Status = 'In Progress' THEN 'In Progress'
        ELSE 'Open'
    END AS ExpectedStatus
FROM dbo.ServiceRequests AS sr
LEFT JOIN dbo.WorkOrders AS wo
    ON wo.ServiceRequestID = sr.ServiceRequestID
INNER JOIN dbo.vw_ServiceRequestStatus AS v
    ON v.ServiceRequestID = sr.ServiceRequestID
WHERE v.EffectiveStatus <>
    CASE
        WHEN sr.CanceledAt IS NOT NULL THEN 'Canceled'
        WHEN wo.Status = 'Completed' THEN 'Closed'
        WHEN wo.Status = 'In Progress' THEN 'In Progress'
        ELSE 'Open'
    END;
GO

-- Display sample requests from each effective status category.
-- Expected: 12 rows, with 3 requests for each of the 4 statuses.
WITH RankedRequests AS
(
    SELECT
        ServiceRequestID,
        Description,
        EffectiveStatus,
        ROW_NUMBER() OVER (
            PARTITION BY EffectiveStatus
            ORDER BY ServiceRequestID
        ) AS RowNum
    FROM dbo.vw_ServiceRequestStatus
)
SELECT
    ServiceRequestID,
    Description,
    EffectiveStatus
FROM RankedRequests
WHERE RowNum <= 3
ORDER BY EffectiveStatus, ServiceRequestID;
GO