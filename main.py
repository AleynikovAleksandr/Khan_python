import random

def play_game():
    # Список слов для игры
    words = ["алгоритм", "переменная", "функция", "цикл", "компилятор"]
    # Выбираем случайное слово из списка
    secret_word = random.choice(words)
    # Создаем список для отображения угаданных букв
    guessed_word = ["*"] * len(secret_word)
    # Количество оставшихся попыток
    attempts = 3
    # Множество для хранения уже названных букв
    used_letters = set()

    print("Добро пожаловать в игру 'Угадай слово по буквам'!")
    print("Загаданное слово:", "".join(guessed_word))

    while attempts > 0 and "*" in guessed_word:
        # Запрашиваем у игрока букву
        letter = input("Введите букву: ").lower()

        if len(letter) != 1 or not letter.isalpha():
            print("Пожалуйста, введите одну букву.")
            continue

        if letter in used_letters:
            print("Вы уже называли эту букву. Попробуйте другую.")
            continue

        used_letters.add(letter)

        if letter in secret_word:
            # Если буква угадана, открываем её в слове
            for i in range(len(secret_word)):
                if secret_word[i] == letter:
                    guessed_word[i] = letter
            print("Буква угадана! Текущее слово:", "".join(guessed_word))
        else:
            # Если буква не угадана, уменьшаем количество попыток
            attempts -= 1
            print(f"Такой буквы нет. Осталось попыток: {attempts}")

    # Проверяем результат игры
    if "*" not in guessed_word:
        print("Поздравляем! Вы угадали слово:", secret_word)
    else:
        print("К сожалению, вы проиграли. Загаданное слово было:", secret_word)

    # Предложение сыграть ещё раз
    while True:
        play_again = input("Хотите сыграть ещё раз? (да/нет): ").lower()
        if play_again in ["да", "нет"]:  # Проверка корректности ввода
            break
        print('Пожалуйста, введите "да" или "нет".')  # Сообщение об ошибке

    if play_again == "да":
        play_game()  # Запуск игры заново
    else:
        print("Спасибо за игру! До встречи!")  # Завершение игры

# Запуск игры
play_game()