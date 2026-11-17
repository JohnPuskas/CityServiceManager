USE CityServiceManager;
GO

-- Primary key and unique constraints
SELECT
    t.name AS TableName,
    kc.name AS ConstraintName,
    CASE kc.type
        WHEN 'PK' THEN 'PRIMARY KEY'
        WHEN 'UQ' THEN 'UNIQUE'
    END AS ConstraintType
FROM sys.key_constraints AS kc
INNER JOIN sys.tables AS t
    ON kc.parent_object_id = t.object_id
WHERE SCHEMA_NAME(t.schema_id) = 'dbo'
ORDER BY
    t.name,
    kc.type,
    kc.name;
GO