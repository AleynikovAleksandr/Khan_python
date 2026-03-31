from db_client import ClickHouseClient
from config import DatabaseConfig

def setup_database():
    db = ClickHouseClient()

    db.command(f"DROP DATABASE IF EXISTS {DatabaseConfig.DATABASE}")
    db.command(f"CREATE DATABASE {DatabaseConfig.DATABASE}")

    db.set_database()

    db.command("""
    CREATE TABLE Product_Dim (
        ProductKey UInt64,
        ProductID Int32,
        ProductName String,
        SupplierName String,
        CategoyName String,
        ListUnitPrice Float64
    ) ENGINE = MergeTree()
    ORDER BY ProductKey
    """)

    db.command("""
    CREATE TABLE Employee_Dim (
        EmployeeKey UInt64,
        EmployeeID Int32,
        EmployeeName String,
        HireDate Date
    ) ENGINE = MergeTree()
    ORDER BY EmployeeKey
    """)

    db.command("""
    CREATE TABLE Customer_Dim (
        CustomerKey UInt64,
        CustomerID String,
        CompanyName String,
        ContactTitle String,
        Address String,
        City String,
        Region String,
        PostalCode String,
        Country String,
        Phone String,
        Fax String
    ) ENGINE = MergeTree()
    ORDER BY CustomerKey
    """)

    db.command("""
    CREATE TABLE Shipper_Dim (
        ShipperKey UInt64,
        ShipperID Int32,
        ShipperName String
    ) ENGINE = MergeTree()
    ORDER BY ShipperKey
    """)

    db.command("""
    CREATE TABLE Time_Dim (
        TimeKey UInt64,
        TheDate Date,
        DayOfWeek UInt8,
        Month UInt8,
        Year UInt16,
        Quarter UInt8,
        DayOfYear UInt16,
        Holiday UInt8,
        Weekend UInt8,
        YearMonth UInt32,
        WeekOfYear UInt8
    ) ENGINE = MergeTree()
    ORDER BY TimeKey
    """)

    db.command("""
    CREATE TABLE Sales_Fact (
        TimeKey UInt64,
        CustomerKey UInt64,
        ShipperKey UInt64,
        ProductKey UInt64,
        EmployeeKey UInt64,
        RequiredDate Date,
        LineItemFreight Float64,
        LineItemTotal Float64,
        LineItemQuantity Int32,
        LineItemDiscount Float64
    ) ENGINE = MergeTree()
    ORDER BY (TimeKey, CustomerKey, ProductKey)
    """)

    db.command("""
    CREATE TABLE Sales_Summary (
        TheDate Date,
        ProductName String,
        CustomerName String,
        EmployeeName String,
        ShipperName String,
        Quantity Int32,
        Total Float64
    ) ENGINE = MergeTree()
    ORDER BY (TheDate, ProductName)
    """)

    print("БД и таблицы созданы")


if __name__ == "__main__":
    setup_database()