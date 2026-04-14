import clickhouse_connect
from datetime import date
from config import ClickHouseClient


def create_and_fill_tables():
    client = ClickHouseClient.get_client()

    # 1. ReplacingMergeTree
    print("--- Engine: ReplacingMergeTree ---")
    print("Описание: Удаляет дубликаты по ключу сортировки.")

    client.command("""
    CREATE TABLE IF NOT EXISTS test_replacing (
        id UInt64,
        value String,
        version UInt64
    ) ENGINE = ReplacingMergeTree(version)
    ORDER BY id
    """)

    client.insert(
        'test_replacing',
        [
            [1, 'old_data', 1],
            [1, 'new_data', 2]
        ],
        column_names=['id', 'value', 'version']
    )

    # 2. SummingMergeTree
    print("\n--- Engine: SummingMergeTree ---")
    print("Описание: Суммирует числовые значения при слиянии.")

    client.command("""
    CREATE TABLE IF NOT EXISTS test_summing (
        date Date,
        key UInt32,
        clicks UInt64
    ) ENGINE = SummingMergeTree()
    ORDER BY (date, key)
    """)

    client.insert(
        'test_summing',
        [
            [date(2023, 10, 1), 10, 100],
            [date(2023, 10, 1), 10, 50]
        ],
        column_names=['date', 'key', 'clicks']
    )

    # 3. AggregatingMergeTree
    print("\n--- Engine: AggregatingMergeTree ---")
    print("Описание: Хранит агрегатные состояния.")

    client.command("""
    CREATE TABLE IF NOT EXISTS test_aggregating (
        id UInt64,
        unique_users AggregateFunction(uniq, String)
    ) ENGINE = AggregatingMergeTree()
    ORDER BY id
    """)

    client.command("""
    INSERT INTO test_aggregating
    SELECT 1, uniqState('user_1')
    """)

    # 4. View
    print("\n--- Engine: View ---")
    print("Описание: Представление (не хранит данные).")

    client.command("""
    CREATE OR REPLACE VIEW test_view AS
    SELECT id, value
    FROM test_replacing
    WHERE version > 1
    """)

    # 5. Memory
    print("\n--- Engine: Memory ---")
    print("Описание: Данные хранятся в оперативной памяти.")

    client.command("""
    CREATE TABLE IF NOT EXISTS test_memory (
        temp_id UInt32,
        data String
    ) ENGINE = Memory()
    """)

    client.insert(
        'test_memory',
        [
            [1, 'cache_data']
        ],
        column_names=['temp_id', 'data']
    )

    print("\nГотово: Все таблицы созданы и заполнены.")


if __name__ == "__main__":
    # 1. Создаём БД
    ClickHouseClient.create_database()

    # 2. Создаём таблицы и вставляем данные
    create_and_fill_tables()