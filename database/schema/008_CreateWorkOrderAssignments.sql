USE CityServiceManager;
GO

CREATE TABLE dbo.WorkOrderAssignments
(
    WorkOrderID INT NOT NULL,
    EmployeeID INT NOT NULL,

    AssignedAt DATETIME2 NOT NULL
        CONSTRAINT DF_WorkOrderAssignments_AssignedAt
        DEFAULT SYSUTCDATETIME(),

    CONSTRAINT PK_WorkOrderAssignments
        PRIMARY KEY (WorkOrderID, EmployeeID),

    CONSTRAINT FK_WorkOrderAssignments_WorkOrders
        FOREIGN KEY (WorkOrderID)
        REFERENCES dbo.WorkOrders(WorkOrderID),

    CONSTRAINT FK_WorkOrderAssignments_Employees
        FOREIGN KEY (EmployeeID)
        REFERENCES dbo.Employees(EmployeeID)
);
GO