ATTACH TABLE _ UUID '5727620a-c92d-4fd3-8944-5dcd9f901916'
(
    `ProductKey` UInt64,
    `ProductID` Int32,
    `ProductName` String,
    `SupplierName` String,
    `CategoyName` String,
    `ListUnitPrice` Float64
)
ENGINE = MergeTree
ORDER BY ProductKey
SETTINGS index_granularity = 8192
