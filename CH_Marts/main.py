import pandas as pd
from clickhouse_config import ClickHouseClient


def load_data():
    df = pd.read_csv('/home/alex_a/Khan_python/CH_Marts/Walmart_normalized.csv')
    df['Date'] = pd.to_datetime(df['Date'], dayfirst=True).dt.date

    create_sql = """
        CREATE TABLE IF NOT EXISTS walmart_sales (
        Store UInt32,
        Date Date,
        Weekly_Sales Float64,
        Weekly_Sales_norm Float32,
        Holiday_Flag UInt8,
        Temperature Float32,
        Temperature_norm Float32,
        Fuel_Price Float32,
        Fuel_Price_norm Float32,
        CPI Float32,
        CPI_norm Float32,
        Unemployment Float32,
        Unemployment_norm Float32
    )
    ENGINE = MergeTree()
    ORDER BY (Store, Date)
    """

    ClickHouseClient.insert_dataframe(
        df=df,
        table_name="walmart_sales",
        create_table_sql=create_sql
    )


def create_mart_year_sales():
    client = ClickHouseClient.get_client()

    client.command("""
    CREATE TABLE IF NOT EXISTS mart_year_sales
    ENGINE = SummingMergeTree()
    ORDER BY (year, store)
    AS
    SELECT
        toYear(Date) AS year,
        Store AS store,
        sum(Weekly_Sales) AS revenue
    FROM walmart_sales
    GROUP BY year, store
    """)


def create_mart_best_week():
    client = ClickHouseClient.get_client()

    client.command("""
    CREATE TABLE IF NOT EXISTS mart_best_week
    ENGINE = MergeTree()
    ORDER BY (Date, Store)
    AS
    SELECT
        Date,
        Store,
        Weekly_Sales,
        Temperature,
        Fuel_Price
    FROM walmart_sales
    ORDER BY Weekly_Sales DESC
    """)


if __name__ == "__main__":
    ClickHouseClient.create_database()

    load_data()

    create_mart_year_sales()
    create_mart_best_week()
