import random

def play_game():
    words = ["алгоритм", "переменная", "функция", "цикл", "компилятор"]
    while True:
        secret_word = random.choice(words)
        guessed_word = ["*"] * len(secret_word)
        attempts = 3
        used_letters = set()

        print("\nДобро пожаловать в игру 'Угадай слово по буквам'!")
        print("Загаданное слово:", "".join(guessed_word))

        while attempts > 0 and "*" in guessed_word:
            letter = input("Введите букву: ").lower()

            if len(letter) != 1 or not letter.isalpha():
                print("Пожалуйста, введите одну букву.")
                attempts -= 1
                print(f"Осталось попыток: {attempts}")
                continue

            if letter in used_letters:
                print("Вы уже называли эту букву. Попробуйте другую.")
                attempts -= 1
                print(f"Осталось попыток: {attempts}")
                continue

            used_letters.add(letter)

            if letter in secret_word:
                for idx, char in enumerate(secret_word):
                    if char == letter:
                        guessed_word[idx] = letter
                print("Буква угадана! Текущее слово:", "".join(guessed_word))
            else:
                attempts -= 1
                print(f"Такой буквы нет. Осталось попыток: {attempts}")

        if "*" not in guessed_word:
            print("Поздравляем! Вы угадали слово:", secret_word)
        else:
            print("К сожалению, вы проиграли. Загаданное слово было:", secret_word)

        while True:
            play_again = input("Хотите сыграть ещё раз? (да/нет): ").strip().lower()
            if play_again in ("да", "нет"):
                break
            print('Пожалуйста, введите "да" или "нет".')
        if play_again == "нет":
            print("Спасибо за игру! До встречи!")
            break

if __name__ == "__main__":
    play_game()