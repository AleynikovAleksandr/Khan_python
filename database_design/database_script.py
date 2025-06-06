import os
import sqlite3
import csv

# Названия файлов
db_filename = 'projects_database.db'
schema_filename = 'todo_schema.sql'
export_filename = 'tasks_export.csv'

# Проверка: существует ли база данных
is_newdb = not os.path.exists(db_filename)

if is_newdb:
    with sqlite3.connect(db_filename) as conn:
        # Чтение схемы из SQL-файла
        with open(schema_filename, encoding='utf-8') as f:
            schema = f.read()
        conn.executescript(schema)

        # Добавление записи в project
        conn.execute("""
            INSERT INTO project (name, description, deadline)
            VALUES ('python coding', 'becoming robust coder', '2025-06-20')
        """)

        # Добавление нескольких записей в task
        conn.executescript("""
            INSERT INTO task (details, status, deadline, project)
            VALUES ('learn pandas', 'in progress', '2025-06-19', 'python coding');

            INSERT INTO task (details, status, deadline, project)
            VALUES ('learn numpy', 'done', '2025-04-10', 'python coding');

            INSERT INTO task (details, status, deadline, project)
            VALUES ('learn scipy', 'postponed', '2025-04-10', 'python coding');

            INSERT INTO task (details, status, deadline, project)
            VALUES ('read records', 'scheduled', '2025-06-18', 'python coding');

            INSERT INTO task (details, status, deadline, project)
            VALUES ('create report', 'scheduled', '2025-06-17', 'python coding');
        """)

        # Экспорт таблицы task в CSV
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM task")

        with open(export_filename, 'w', newline='', encoding='utf-8') as csvfile:
            csvwriter = csv.writer(csvfile)
            # Заголовки
            csvwriter.writerow([i[0] for i in cursor.description])
            # Данные
            csvwriter.writerows(cursor)

    print("Скрипт успешно выполнен.")
    print(f"База данных: {db_filename}")
    print(f"Таблица 'task' экспортирована в: {export_filename}")
else:
    print('База данных уже существует! Действия не выполнены повторно.')
