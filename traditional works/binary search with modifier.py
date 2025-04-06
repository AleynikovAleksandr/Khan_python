import bisect
import sys
from typing import List, Tuple

class BinarySearch:
    def __init__(self, array: List[int]):
        self.validate_array(array)
        self.original_array = array
        self.sorted_array: List[Tuple[int, int]] = sorted((val, idx) for idx, val in enumerate(array))

    def validate_array(self, array):
        if not isinstance(array, list):
            raise ValueError("Массив должен быть списком.")
        if not array:
            raise ValueError("Массив не должен быть пустым.")

    def binary_search(self, target: int, find_first: bool) -> int:
        left = bisect.bisect_left(self.sorted_array, (target, -1))
        if left < len(self.sorted_array) and self.sorted_array[left][0] == target:
            return self.sorted_array[left][1] if find_first else self.sorted_array[left][1]
        return -1

    def find_occurrence(self, target: int) -> int:
        find_first = self.original_array.count(target) > 1
        return self.binary_search(target, find_first)

if __name__ == "__main__":
    array = [0, 2, 3, 4, 5, 5, 4, 5]

    try:
        binary_search = BinarySearch(array)
        print("Исходный массив:", binary_search.original_array)

        target = int(input("Введите число для поиска: ").strip())
        index = binary_search.find_occurrence(target)

        if index != -1:
            print(f"Индекс первого вхождения элемента {target}: {index}")
        else:
            print(f"Элемент {target} отсутствует в массиве.")
    except ValueError as e:
        print(f"Ошибка: {e}")
        sys.exit()