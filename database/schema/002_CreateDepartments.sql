USE CityServiceManager;
GO

CREATE TABLE dbo.Departments
(
    DepartmentID INT IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(100) NOT NULL,

    CONSTRAINT PK_Departments
        PRIMARY KEY (DepartmentID),

    CONSTRAINT UQ_Departments_Name
        UNIQUE (Name)
);
GO