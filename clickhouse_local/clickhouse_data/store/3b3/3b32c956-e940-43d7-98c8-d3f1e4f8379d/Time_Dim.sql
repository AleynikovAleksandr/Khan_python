ATTACH TABLE _ UUID '53d0c1df-35c0-41d5-a66e-49d2e9e097fa'
(
    `TimeKey` UInt64,
    `TheDate` Date,
    `DayOfWeek` UInt8,
    `Month` UInt8,
    `Year` UInt16,
    `Quarter` UInt8,
    `DayOfYear` UInt16,
    `Holiday` UInt8,
    `Weekend` UInt8,
    `YearMonth` UInt32,
    `WeekOfYear` UInt8
)
ENGINE = MergeTree
ORDER BY TimeKey
SETTINGS index_granularity = 8192
