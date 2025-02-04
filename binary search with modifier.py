import bisect

class BinarySearch:
    def __init__(self, array):
        """Запоминаем исходный массив и сортируем для бинарного поиска"""
        self.original_array = array
        self.sorted_array = sorted((val, idx) for idx, val in enumerate(array))

    def binary_search(self, target, find_first):
        """Используем bisect для бинарного поиска"""
        left = bisect.bisect_left(self.sorted_array, (target, -1))
        if left < len(self.sorted_array) and self.sorted_array[left][0] == target:
            if find_first:
                # Находим первое вхождение
                while left > 0 and self.sorted_array[left - 1][0] == target:
                    left -= 1
            return self.sorted_array[left][1]  # Возвращаем индекс из оригинального массива
        return -1  # Элемент не найден

    def find_occurrence(self, target):
        """Определяем, искать первое вхождение или любое, и выполняем бинарный поиск"""
        find_first = self.original_array.count(target) > 1
        result = self.binary_search(target, find_first)

        # Дополнительная проверка: если есть дубликаты, убеждаемся, что найден первый индекс
        if find_first and result != -1:
            return min(idx for idx, val in enumerate(self.original_array) if val == target)

        return result  # Возвращаем результат: индекс первого вхождения или -1, если не найдено

    def print_array(self):
        """Метод для вывода массива и проверки на пустоту"""
        if not self.original_array:  # Проверка, что массив не пустой
            print("Массив пустой!")
        else:
            print("Исходный массив:", self.original_array)

# Основной код
if __name__ == "__main__":
    array = [0, 2, 3, 4, 5, 5, 4, 5]  # Исходный массив
    binary_search = BinarySearch(array)

    # Выводим массив с проверкой на пустоту
    binary_search.print_array()

    try:
        target = int(input("Введите число для поиска: "))  # Вводим число
        index = binary_search.find_occurrence(target)

        if index != -1:
            print(f"Индекс найденного элемента {target}: {index}")
        else:
            print(f"Элемент {target} не найден в массиве.")
    except ValueError:
        print("Ошибка ввода! Введите целое число.")
