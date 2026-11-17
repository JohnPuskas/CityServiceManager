USE CityServiceManager;
GO

CREATE TABLE dbo.Employees
(
    EmployeeID INT IDENTITY(1,1) NOT NULL,
    DepartmentID INT NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,

    CONSTRAINT PK_Employees
        PRIMARY KEY (EmployeeID),

    CONSTRAINT FK_Employees_Departments
        FOREIGN KEY (DepartmentID)
        REFERENCES dbo.Departments(DepartmentID)
);
GO