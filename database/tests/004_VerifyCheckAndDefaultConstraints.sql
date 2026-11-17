USE CityServiceManager;
GO

-- CHECK constraints
SELECT
    OBJECT_NAME(parent_object_id) AS TableName,
    name AS ConstraintName,
    definition,
    is_disabled AS IsDisabled,
    is_not_trusted AS IsNotTrusted
FROM sys.check_constraints
ORDER BY TableName, ConstraintName;
GO

-- DEFAULT constraints
SELECT
    OBJECT_NAME(dc.parent_object_id) AS TableName,
    c.name AS ColumnName,
    dc.name AS ConstraintName,
    dc.definition AS DefaultValue
FROM sys.default_constraints AS dc
INNER JOIN sys.columns AS c
    ON dc.parent_object_id = c.object_id
    AND dc.parent_column_id = c.column_id
ORDER BY TableName, ColumnName;
GO
