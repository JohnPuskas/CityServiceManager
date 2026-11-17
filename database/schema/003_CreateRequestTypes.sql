USE CityServiceManager;
GO

CREATE TABLE dbo.RequestTypes
(
    RequestTypeID INT IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(100) NOT NULL,

    CONSTRAINT PK_RequestTypes
        PRIMARY KEY (RequestTypeID),

    CONSTRAINT UQ_RequestTypes_Name
        UNIQUE (Name)
);
GO