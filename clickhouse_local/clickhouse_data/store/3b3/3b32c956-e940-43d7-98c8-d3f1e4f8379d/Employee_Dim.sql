ATTACH TABLE _ UUID 'f7a415f1-1f66-43fd-b4b0-e609b54ea7bd'
(
    `EmployeeKey` UInt64,
    `EmployeeID` Int32,
    `EmployeeName` String,
    `HireDate` Date
)
ENGINE = MergeTree
ORDER BY EmployeeKey
SETTINGS index_granularity = 8192
