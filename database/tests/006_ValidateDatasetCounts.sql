USE CityServiceManager;
GO

-- Verify record counts across all seven tables.
SELECT
    'Departments' AS TableName,
    COUNT(*) AS RecordCount
FROM dbo.Departments

UNION ALL

SELECT 'RequestTypes', COUNT(*)
FROM dbo.RequestTypes

UNION ALL

SELECT 'Locations', COUNT(*)
FROM dbo.Locations

UNION ALL

SELECT 'Employees', COUNT(*)
FROM dbo.Employees

UNION ALL

SELECT 'ServiceRequests', COUNT(*)
FROM dbo.ServiceRequests

UNION ALL

SELECT 'WorkOrders', COUNT(*)
FROM dbo.WorkOrders

UNION ALL

SELECT 'WorkOrderAssignments', COUNT(*)
FROM dbo.WorkOrderAssignments;
GO