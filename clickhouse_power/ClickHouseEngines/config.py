import clickhouse_connect


class BaseConfig:
    HOST = 'localhost'
    PORT = 8123
    USERNAME = 'alex'
    PASSWORD = 'Aa272996099'
    DATABASE = 'ClickEngines'


class ClickHouseClient(BaseConfig):

    @classmethod
    def get_base_client(cls):
        return clickhouse_connect.get_client(
            host=cls.HOST,
            port=cls.PORT,
            username=cls.USERNAME,
            password=cls.PASSWORD
        )

    @classmethod
    def create_database(cls):
        client = cls.get_base_client()
        client.command(f"CREATE DATABASE IF NOT EXISTS {cls.DATABASE}")
        print(f"База данных '{cls.DATABASE}' готова")
        
    @classmethod
    def get_client(cls):
        client = cls.get_base_client()
        client.database = cls.DATABASE
        return client