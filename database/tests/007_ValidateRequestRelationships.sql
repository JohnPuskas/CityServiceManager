USE CityServiceManager;
GO

-- Classify service requests by cancellation and work order existence.
SELECT
    CASE
        WHEN sr.CanceledAt IS NOT NULL
            THEN 'Canceled'
        WHEN wo.WorkOrderID IS NOT NULL
            THEN 'Has Work Order'
        ELSE 'Awaiting Work Order'
    END AS RequestCategory,
    COUNT(*) AS RequestCount
FROM dbo.ServiceRequests AS sr
LEFT JOIN dbo.WorkOrders AS wo
    ON wo.ServiceRequestID = sr.ServiceRequestID
GROUP BY
    CASE
        WHEN sr.CanceledAt IS NOT NULL
            THEN 'Canceled'
        WHEN wo.WorkOrderID IS NOT NULL
            THEN 'Has Work Order'
        ELSE 'Awaiting Work Order'
    END
ORDER BY RequestCategory;
GO

-- Canceled requests must not have associated work orders.
SELECT
    sr.ServiceRequestID,
    sr.CanceledAt,
    wo.WorkOrderID
FROM dbo.ServiceRequests AS sr
INNER JOIN dbo.WorkOrders AS wo
    ON wo.ServiceRequestID = sr.ServiceRequestID
WHERE sr.CanceledAt IS NOT NULL;
GO