USE CityServiceManager;
GO

CREATE TABLE dbo.WorkOrders
(
    WorkOrderID INT IDENTITY(1,1) NOT NULL,
    ServiceRequestID INT NOT NULL,
    DepartmentID INT NOT NULL,

    Status NVARCHAR(20) NOT NULL
        CONSTRAINT DF_WorkOrders_Status
        DEFAULT 'Open',

    Priority NVARCHAR(20) NOT NULL
        CONSTRAINT DF_WorkOrders_Priority
        DEFAULT 'Normal',

    CreatedAt DATETIME2 NOT NULL
        CONSTRAINT DF_WorkOrders_CreatedAt
        DEFAULT SYSUTCDATETIME(),

    StartedAt DATETIME2 NULL,
    DueAt DATETIME2 NULL,
    CompletedAt DATETIME2 NULL,

    CONSTRAINT PK_WorkOrders
        PRIMARY KEY (WorkOrderID),

    CONSTRAINT UQ_WorkOrders_ServiceRequestID
        UNIQUE (ServiceRequestID),

    CONSTRAINT FK_WorkOrders_ServiceRequests
        FOREIGN KEY (ServiceRequestID)
        REFERENCES dbo.ServiceRequests(ServiceRequestID),

    CONSTRAINT FK_WorkOrders_Departments
        FOREIGN KEY (DepartmentID)
        REFERENCES dbo.Departments(DepartmentID),

    CONSTRAINT CK_WorkOrders_Status
        CHECK (Status IN ('Open', 'In Progress', 'Completed')),

    CONSTRAINT CK_WorkOrders_Priority
        CHECK (Priority IN ('Low', 'Normal', 'High'))
);
GO