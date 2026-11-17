USE CityServiceManager;
GO

CREATE TABLE dbo.ServiceRequests
(
    ServiceRequestID INT IDENTITY(1,1) NOT NULL,
    RequestTypeID INT NOT NULL,
    LocationID INT NOT NULL,
    Description NVARCHAR(1000) NOT NULL,
    SubmittedAt DATETIME2 NOT NULL
        CONSTRAINT DF_ServiceRequests_SubmittedAt
        DEFAULT SYSUTCDATETIME(),
    CanceledAt DATETIME2 NULL,

    CONSTRAINT PK_ServiceRequests
        PRIMARY KEY (ServiceRequestID),

    CONSTRAINT FK_ServiceRequests_RequestTypes
        FOREIGN KEY (RequestTypeID)
        REFERENCES dbo.RequestTypes(RequestTypeID),

    CONSTRAINT FK_ServiceRequests_Locations
        FOREIGN KEY (LocationID)
        REFERENCES dbo.Locations(LocationID)
);
GO