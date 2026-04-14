ATTACH TABLE _ UUID '74184ca2-b075-4aeb-bc70-7dd358067ccf'
(
    `ShipperKey` UInt64,
    `ShipperID` Int32,
    `ShipperName` String
)
ENGINE = MergeTree
ORDER BY ShipperKey
SETTINGS index_granularity = 8192
