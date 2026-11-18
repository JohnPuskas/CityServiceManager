USE CityServiceManager;
GO

-- Identify work orders without any employee assignments.
SELECT
    wo.WorkOrderID,
    wo.Status,
    d.Name AS Department
FROM dbo.WorkOrders AS wo
INNER JOIN dbo.Departments AS d
    ON d.DepartmentID = wo.DepartmentID
LEFT JOIN dbo.WorkOrderAssignments AS woa
    ON woa.WorkOrderID = wo.WorkOrderID
WHERE woa.WorkOrderID IS NULL;
GO

-- Summarize how many employees are assigned to each work order.
WITH AssignmentCounts AS
(
    SELECT
        wo.WorkOrderID,
        COUNT(woa.EmployeeID) AS EmployeeCount
    FROM dbo.WorkOrders AS wo
    LEFT JOIN dbo.WorkOrderAssignments AS woa
        ON woa.WorkOrderID = wo.WorkOrderID
    GROUP BY wo.WorkOrderID
)
SELECT
    EmployeeCount,
    COUNT(*) AS WorkOrderCount
FROM AssignmentCounts
GROUP BY EmployeeCount
ORDER BY EmployeeCount;
GO

-- Employees must belong to the department responsible
-- for each work order to which they are assigned.
SELECT
    woa.WorkOrderID,
    woa.EmployeeID,
    wo.DepartmentID AS WorkOrderDepartmentID,
    e.DepartmentID AS EmployeeDepartmentID
FROM dbo.WorkOrderAssignments AS woa
INNER JOIN dbo.WorkOrders AS wo
    ON wo.WorkOrderID = woa.WorkOrderID
INNER JOIN dbo.Employees AS e
    ON e.EmployeeID = woa.EmployeeID
WHERE wo.DepartmentID <> e.DepartmentID;
GO