class ArraySum:
    def __init__(self, data_array):
        # Проверяем, что входной параметр является списком
        if not isinstance(data_array, list):
            raise TypeError("Входной параметр должен быть списком.")
        # Проверяем, что все элементы в списке являются числами (целыми или с плавающей запятой)
        if not all(isinstance(x, (int, float)) for x in data_array):
            raise ValueError("Все элементы в списке должны быть числами.")
        self.data_array = data_array

    def sum_elements(self, index=0):
        """
        Метод возвращает сумму всех элементов в массиве, используя рекурсию.
        """
        if index == len(self.data_array):
            return 0
        else:
            return self.data_array[index] + self.sum_elements(index + 1)

if __name__ == "__main__":
    try:
        data_array = [1, 2, 3, 4, 5]
        array_sum = ArraySum(data_array)
        
        # Вывод самого массива перед вычислением суммы
        print("Исходный массив:", data_array)
        
        # Вычисление и вывод суммы элементов
        print("Сумма элементов массива:", array_sum.sum_elements())
    except (TypeError, ValueError) as e:
        print(f"Ошибка: {e}")

# Анализ вычислительной сложности:
# Временная сложность: O(n), где n - количество элементов в массиве.
# Пространственная сложность: O(n) из-за рекурсивных вызовов.
