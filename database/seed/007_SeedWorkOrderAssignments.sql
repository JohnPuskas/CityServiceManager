USE CityServiceManager;
GO

-- Number work orders consistently to determine assignment counts
-- and distribute assignments across available employees.
;WITH WorkOrderData AS
(
    SELECT
        wo.WorkOrderID,
        wo.DepartmentID,
        wo.CreatedAt,
        ROW_NUMBER() OVER (
            ORDER BY sr.Description
        ) AS WorkOrderNumber
    FROM dbo.WorkOrders AS wo
    INNER JOIN dbo.ServiceRequests AS sr
        ON sr.ServiceRequestID = wo.ServiceRequestID
),
EmployeeData AS
(
    SELECT
        EmployeeID,
        DepartmentID,
        ROW_NUMBER() OVER (
            PARTITION BY DepartmentID
            ORDER BY LastName, FirstName, EmployeeID
        ) AS EmployeeNumber,
        COUNT(*) OVER (
            PARTITION BY DepartmentID
        ) AS EmployeeCount
    FROM dbo.Employees
),
GeneratedAssignments AS
(
    SELECT
        wo.WorkOrderID,
        e.EmployeeID,
        DATEADD(MINUTE, 15, wo.CreatedAt) AS AssignedAt
    FROM WorkOrderData AS wo

    -- Generate one assignment per work order, plus a second
    -- assignment for every third work order.
    CROSS APPLY
    (
        VALUES (1), (2)
    ) AS a(AssignmentNumber)

    INNER JOIN EmployeeData AS e
        ON e.DepartmentID = wo.DepartmentID

        -- Cycle through employees within the assigned department.
        AND e.EmployeeNumber =
            ((wo.WorkOrderNumber + a.AssignmentNumber - 2)
                % e.EmployeeCount) + 1

    WHERE a.AssignmentNumber = 1
       OR (
            a.AssignmentNumber = 2
            AND wo.WorkOrderNumber % 3 = 0
            AND e.EmployeeCount > 1
       )
)
INSERT INTO dbo.WorkOrderAssignments
    (WorkOrderID, EmployeeID, AssignedAt)
SELECT
    ga.WorkOrderID,
    ga.EmployeeID,
    ga.AssignedAt
FROM GeneratedAssignments AS ga

-- Skip assignments already present to allow repeatable execution.
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.WorkOrderAssignments AS existing
    WHERE existing.WorkOrderID = ga.WorkOrderID
      AND existing.EmployeeID = ga.EmployeeID
);
GO