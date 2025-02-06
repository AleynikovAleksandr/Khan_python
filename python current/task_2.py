# Исходные данные
word = 'zeppelin'
phrase = 'Съешь же еще этих мягких французских булок да выпей чаю'

# 1. Перевернуть word
reversed_word = word[::-1]

# 2. Вычислить количество букв 'е' в phrase
count_e = phrase.lower().count('е')

# 3. Заменить "булок" на "пирожных"
modified_phrase = phrase.replace('булок', 'пирожных')

print(f"Исходное слово: {word}")
print(f"Перевернутое слово: {reversed_word}")
print(f"Исходная фраза: {phrase}")
print(f"Количество букв 'е' в фразе: {count_e}")
print(f"Измененная фраза: {modified_phrase}")
