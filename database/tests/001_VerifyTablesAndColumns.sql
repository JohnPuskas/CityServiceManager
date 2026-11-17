USE CityServiceManager;
GO

-- List tables, columns, data types, and nullability
SELECT
    t.name AS TableName,
    c.column_id AS ColumnPosition,
    c.name AS ColumnName,
    TYPE_NAME(c.user_type_id) AS DataType,
    c.max_length AS MaxLengthBytes,
    c.is_nullable AS IsNullable,
    c.is_identity AS IsIdentity
FROM sys.tables AS t
INNER JOIN sys.columns AS c
    ON t.object_id = c.object_id
WHERE SCHEMA_NAME(t.schema_id) = 'dbo'
ORDER BY
    t.name,
    c.column_id;
GO