USE CityServiceManager;
GO

CREATE OR ALTER VIEW dbo.vw_ServiceRequestStatus
AS
SELECT
    sr.ServiceRequestID,
    sr.RequestTypeID,
    sr.LocationID,
    sr.Description,
    sr.SubmittedAt,
    sr.CanceledAt,

    CASE
        WHEN sr.CanceledAt IS NOT NULL
            THEN 'Canceled'
        WHEN wo.Status = 'Completed'
            THEN 'Closed'
        WHEN wo.Status = 'In Progress'
            THEN 'In Progress'
        ELSE 'Open'
    END AS EffectiveStatus

FROM dbo.ServiceRequests AS sr
LEFT JOIN dbo.WorkOrders AS wo
    ON wo.ServiceRequestID = sr.ServiceRequestID;
GO