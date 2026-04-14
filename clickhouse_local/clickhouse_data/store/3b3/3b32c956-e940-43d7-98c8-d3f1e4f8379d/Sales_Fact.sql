ATTACH TABLE _ UUID 'f05eb227-4c51-4ec5-96a6-be65a465408d'
(
    `TimeKey` UInt64,
    `CustomerKey` UInt64,
    `ShipperKey` UInt64,
    `ProductKey` UInt64,
    `EmployeeKey` UInt64,
    `RequiredDate` Date,
    `LineItemFreight` Float64,
    `LineItemTotal` Float64,
    `LineItemQuantity` Int32,
    `LineItemDiscount` Float64
)
ENGINE = MergeTree
ORDER BY (TimeKey, CustomerKey, ProductKey)
SETTINGS index_granularity = 8192
