class BinarySearch:
    def __init__(self, array):
        if not isinstance(array, list) or not array:
            raise ValueError("Массив должен быть непустым списком.")
        self.array = array

    def find_first_occurrence(self, target):
        for idx, val in enumerate(self.array):
            if val == target:
                return idx
        return -1

if __name__ == "__main__":
    array = [0, 2, 3, 4, 5, 5, 4, 5]
    try:
        bs = BinarySearch(array)
        print("Исходный массив:", array)
        target = int(input("Введите число для поиска: ").strip())
        idx = bs.find_first_occurrence(target)
        if idx != -1:
            print(f"Индекс первого вхождения элемента {target}: {idx}")
        else:
            print(f"Элемент {target} отсутствует в массиве.")
    except ValueError as e:
        print(f"Ошибка: {e}")