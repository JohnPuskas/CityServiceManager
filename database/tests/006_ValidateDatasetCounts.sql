USE CityServiceManager;
GO

-- Validate record counts across all seven database tables.
-- Results should match the expected counts for the synthetic dataset.
-- Read-only Select statments; no database records are modified.

-- Verify record counts across all seven tables.
-- Expected: Departments=6, RequestTypes=12, Locations=250,
-- Employees=40, ServiceRequests=2000, WorkOrders=1500,
-- WorkOrderAssignments=2000.

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