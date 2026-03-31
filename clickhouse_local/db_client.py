import clickhouse_connect
from config import DatabaseConfig

class ClickHouseClient:
    def __init__(self):
        self.client = clickhouse_connect.get_client(
            host=DatabaseConfig.HOST,
            port=DatabaseConfig.PORT,
            username=DatabaseConfig.USERNAME,
            password=DatabaseConfig.PASSWORD
        )

    def set_database(self):
        self.client.database = DatabaseConfig.DATABASE

    def command(self, query):
        return self.client.command(query)

    def query(self, query):
        return self.client.query(query)

    def insert(self, table, data, columns=None):
        self.client.insert(table, data, column_names=columns)