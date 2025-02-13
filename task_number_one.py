students = {"Иванов": [2, 3, 2], "Петров": [3, 3, 3], "Сидоров": [1, 2, 3]}

while True:
    choice = input("Выберите действие: (1) Добавить студента, (2) Показать список студентов, (3) Выход: ")
    
    if choice == '1':
        name = input("Введите имя студента: ")
        grades = list(map(int, input("Введите оценки через пробел: ").split()))
        students[name] = grades  
    
    elif choice == '2':
        for name, grades in students.items():
            average = sum(grades) / len(grades)
            print(f"Студент: {name}, Оценки: {grades}, Средний балл: {average:.2f}")
    
    elif choice == '3':
        break
    
    else:
        print("Неверный выбор. Пожалуйста, попробуйте снова.")