ATTACH TABLE _ UUID 'a3fcf973-95a8-4f41-8c90-47b9ff156c55'
(
    `CustomerKey` UInt64,
    `CustomerID` String,
    `CompanyName` String,
    `ContactTitle` String,
    `Address` String,
    `City` String,
    `Region` String,
    `PostalCode` String,
    `Country` String,
    `Phone` String,
    `Fax` String
)
ENGINE = MergeTree
ORDER BY CustomerKey
SETTINGS index_granularity = 8192
