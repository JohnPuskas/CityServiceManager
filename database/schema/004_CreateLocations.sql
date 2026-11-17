USE CityServiceManager;
GO

CREATE TABLE dbo.Locations
(
    LocationID INT IDENTITY(1,1) NOT NULL,
    StreetAddress NVARCHAR(200) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    StateCode CHAR(2) NOT NULL,
    PostalCode NVARCHAR(10) NOT NULL,

    CONSTRAINT PK_Locations
        PRIMARY KEY (LocationID)
);
GO