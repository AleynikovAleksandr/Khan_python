import json
import os
import platform
import shutil
import sys

FILENAME = "tasks.json"

class ConsoleUtils:
    @staticmethod
    def clear_console():
        """Кроссплатформенная очистка консоли."""
        if sys.stdout.isatty():
            if platform.system() == "Windows":
                os.system("cls")
            else:
                sys.stdout.write("\033c")
                sys.stdout.flush()
        else:
            print("\n" * shutil.get_terminal_size().lines)

class TaskManager:
    def __init__(self, filename):
        self.filename = filename
        self.tasks = self.load_tasks()

    def load_tasks(self):
        if os.path.exists(self.filename):
            with open(self.filename, "r", encoding="utf-8") as file:
                return json.load(file)
        return []

    def save_tasks(self):
        with open(self.filename, "w", encoding="utf-8") as file:
            json.dump(self.tasks, file, ensure_ascii=False, indent=4)

    def delete_old_file(self):
        """Удаляет старый файл при каждом запуске программы, если он существует."""
        if os.path.exists(self.filename):
            os.remove(self.filename)
            self.tasks = []

    def add_task(self):
        ConsoleUtils.clear_console()
        title = input("Введите название дела: ")
        description = input("Введите описание: ")
        deadline = input("Введите срок выполнения: ")
        participants = input("Введите участников (через запятую): ").split(",")

        task = {
            "title": title,
            "description": description,
            "deadline": deadline,
            "participants": [p.strip() for p in participants]
        }

        self.tasks.append(task)
        self.save_tasks()
        print("Задача добавлена!")
        input("\nНажмите Enter, чтобы продолжить...")

    def list_tasks(self):
        ConsoleUtils.clear_console()
        if not self.tasks:
            print("Список дел пуст.")
        else:
            print("Список дел:")
            for i, task in enumerate(self.tasks, start=1):
                print(f"{i}. Название: {task['title']}")
                print(f"   Описание: {task['description']}")
                print(f"   Срок: {task['deadline']}")
                print(f"   Участники: {', '.join(task['participants'])}")
                print("-" * 20)

        input("\nНажмите Enter, чтобы продолжить...")

    def edit_task(self):
        ConsoleUtils.clear_console()
        if not self.tasks:
            print("Нет задач для редактирования.")
            input("\nНажмите Enter, чтобы продолжить...")
            return

        self.list_tasks()
        try:
            index = int(input("Введите номер задачи для редактирования: ")) - 1
            if index < 0 or index >= len(self.tasks):
                print("Некорректный номер.")
                input("\nНажмите Enter, чтобы продолжить...")
                return

            task = self.tasks[index]
            print("\nВыберите, что изменить (можно несколько через запятую):")
            print("1. Название")
            print("2. Описание")
            print("3. Срок выполнения")
            print("4. Участников")
            choices = input("Введите номера полей для изменения: ").split(",")

            valid_choices = {"1", "2", "3", "4"}
            if not all(choice.strip() in valid_choices for choice in choices):
                print("Некорректный ввод. Попробуйте снова.")
                input("\nНажмите Enter, чтобы продолжить...")
                return

            choices = {c.strip() for c in choices}

            if "1" in choices:
                task["title"] = input(f"Новое название ({task['title']}): ") or task["title"]
            if "2" in choices:
                task["description"] = input(f"Новое описание ({task['description']}): ") or task["description"]
            if "3" in choices:
                task["deadline"] = input(f"Новый срок ({task['deadline']}): ") or task["deadline"]
            if "4" in choices:
                new_participants = input(f"Новые участники ({', '.join(task['participants'])}): ")
                task["participants"] = [p.strip() for p in new_participants.split(",")] if new_participants else task["participants"]

            self.save_tasks()
            print("Задача обновлена!")
            input("\nНажмите Enter, чтобы продолжить...")

        except ValueError:
            print("Ошибка ввода номера задачи.")
            input("\nНажмите Enter, чтобы продолжить...")

    def delete_task(self):
        ConsoleUtils.clear_console()
        if not self.tasks:
            print("Нет задач для удаления.")
            input("\nНажмите Enter, чтобы продолжить...")
            return

        self.list_tasks()
        try:
            index = int(input("Введите номер задачи для удаления: ")) - 1
            if index < 0 or index >= len(self.tasks):
                print("Некорректный номер.")
                input("\nНажмите Enter, чтобы продолжить...")
                return

            self.tasks.pop(index)
            self.save_tasks()
            print("Задача удалена!")
            input("\nНажмите Enter, чтобы продолжить...")

        except ValueError:
            print("Ошибка ввода номера задачи.")
            input("\nНажмите Enter, чтобы продолжить...")

class Application:
    def __init__(self):
        self.task_manager = TaskManager(FILENAME)
        self.task_manager.delete_old_file()

    def run(self):
        while True:
            ConsoleUtils.clear_console()
            print("\n1. Добавить дело")
            print("2. Показать список дел")
            print("3. Редактировать дело")
            print("4. Удалить дело")
            print("5. Выход")
            choice = input("Выберите действие: ")

            if choice == "1":
                self.task_manager.add_task()
            elif choice == "2":
                self.task_manager.list_tasks()
            elif choice == "3":
                self.task_manager.edit_task()
            elif choice == "4":
                self.task_manager.delete_task()
            elif choice == "5":
                break
            else:
                print("Некорректный ввод. Попробуйте снова.")
                input("\nНажмите Enter, чтобы продолжить...")

if __name__ == "__main__":
    app = Application()
    app.run()