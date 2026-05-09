import logging
import pandas as pd
from dataclasses import dataclass
import clickhouse_connect

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


@dataclass
class ClickHouseConfig:
    HOST: str = 'localhost'
    PORT: int = 8123
    USERNAME: str = 'alex'
    PASSWORD: str = 'Aa272996099'
    DATABASE: str = 'CH_MARTS'
    CONNECT_TIMEOUT: int = 10


class ClickHouseClient(ClickHouseConfig):
    _client = None

    @classmethod
    def get_base_client(cls):
        if cls._client is None:
            cls._client = clickhouse_connect.get_client(
                host=cls.HOST,
                port=cls.PORT,
                username=cls.USERNAME,
                password=cls.PASSWORD,
                connect_timeout=cls.CONNECT_TIMEOUT,
                compress=True
            )
        return cls._client

    @classmethod
    def create_database(cls):
        client = cls.get_base_client()
        client.command(f"CREATE DATABASE IF NOT EXISTS {cls.DATABASE}")
        logger.info(f"База данных '{cls.DATABASE}' готова")

    @classmethod
    def get_client(cls):
        client = cls.get_base_client()
        client.database = cls.DATABASE
        return client

    @classmethod
    def insert_dataframe(
        cls,
        df: pd.DataFrame,
        table_name: str,
        create_table_sql: str = None
    ):
        if df.empty:
            logger.warning("DataFrame пустой, ничего не загружаем")
            return

        client = cls.get_client()

        try:
            if create_table_sql:
                client.command(create_table_sql)

            client.insert_df(table_name, df)

            logger.info(f"Успешно загружено {len(df):,} строк в таблицу `{table_name}`")

        except Exception as e:
            logger.error(f"Ошибка при вставке данных в `{table_name}`: {e}")
            raise