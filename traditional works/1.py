students = [
    ("Иванчиков", "Илья"),
    ("Ивановских", "Иннокентий"),
    ("Иванова", "Ирина"),
    ("Иванников", "Ильдар")
]

logins = []
hash_codes = []

def generate_login(surname, name):
    return surname[:5] + name[0]

def generate_hash(login):
    return sum(ord(ch) for ch in login)

def update_data():
    logins.clear()
    hash_codes.clear()
    for surname, name in students:
        login = generate_login(surname, name)
        logins.append(login)
        hash_codes.append(generate_hash(login))

def count_collisions():
    count = 0
    for i in range(len(hash_codes)):
        for j in range(i + 1, len(hash_codes)):
            if hash_codes[i] == hash_codes[j]:
                count += 1
    return count

def show_table():
    update_data()
    print(f"\n{'#':<3} {'Фамилия':<15} {'Имя':<15} {'Логин':<12} {'Хэш-код':<10}")
    print("-" * 55)
    for i, ((surname, name), login, h) in enumerate(zip(students, logins, hash_codes), start=1):
        print(f"{i:<3} {surname:<15} {name:<15} {login:<12} {h:<10}")
    print("-" * 55)
    print(f"Количество коллизий: {count_collisions()}\n")

def add_student():
    print("\nДобавление нового студента")
    surname = input("Введите фамилию: ").strip()
    name = input("Введите имя: ").strip()
    if surname and name:
        students.append((surname, name))
        print(f"Студент {surname} {name} успешно добавлен!\n")
    else:
        print("Фамилия и имя не могут быть пустыми.\n")

def main_menu():
    while True:
        print("=== МЕНЮ ===")
        print("1. Просмотреть таблицу студентов")
        print("2. Добавить нового студента")
        print("0. Выход")
        choice = input("Выберите действие: ")

        if choice == "1":
            show_table()
        elif choice == "2":
            add_student()
        elif choice == "0":
            print("Программа завершена.")
            break
        else:
            print("Неверный выбор, попробуйте снова.\n")

if __name__ == "__main__":
    main_menu()