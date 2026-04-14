from create_tables import setup_database
from data_loader import insert_data
from analytics import Analytics

if __name__ == "__main__":
    setup_database()
    insert_data()

    analytics = Analytics()
    analytics.fill_summary()
    analytics.console_output()
    analytics.show_summary()