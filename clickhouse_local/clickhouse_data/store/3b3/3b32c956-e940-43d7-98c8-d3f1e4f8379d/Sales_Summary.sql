ATTACH TABLE _ UUID '7cb8b4a3-bf60-41ea-bb19-2aa20fce9866'
(
    `TheDate` Date,
    `ProductName` String,
    `CustomerName` String,
    `EmployeeName` String,
    `ShipperName` String,
    `Quantity` Int32,
    `Total` Float64
)
ENGINE = MergeTree
ORDER BY (TheDate, ProductName)
SETTINGS index_granularity = 8192
