from clickhouse_power.clickhouse_local.create_tables import setup_database
from clickhouse_power.clickhouse_local.data_loader import insert_data
from clickhouse_power.clickhouse_local.analytics import Analytics

if __name__ == "__main__":
    setup_database()
    insert_data()

    analytics = Analytics()
    analytics.fill_summary()
    analytics.console_output()
    analytics.show_summary()