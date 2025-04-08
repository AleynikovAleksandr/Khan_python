class CustomLinkedList:
    def __init__(self):
        self._data1 = []

    def insert(self, data1):
        """Вставить узел в голову списка"""
        self._data1.insert(0, data1)

    def append(self, data1):
        """Вставить узел в хвост списка"""
        self._data1.append(data1)

    def remove(self):
        """Удалить узел из головы списка"""
        if not self._data1:
            raise IndexError("Удаление из пустого списка невозможно")
        self._data1.pop(0)

    def delete(self):
        """Удалить узел из хвоста списка"""
        if not self._data1:
            raise IndexError("Удаление из пустого списка невозможно")
        self._data1.pop()

    def iterate(self):
        """Напечатать все узлы списка"""
        for item in self._data1:
            print(item, end=' ')
        print()

    def size(self):
        """Возвращает длину списка"""
        return len(self._data1)

    def __str__(self):
        """Возвращает строковое представление списка"""
        return ' '.join(str(item) for item in self._data1)

    def __len__(self):
        """Возвращает длину списка"""
        return len(self._data1)

    def __iter__(self):
        """Возвращает итератор для списка"""
        self._index = 0
        return self

    def __next__(self):
        """Возвращает следующий элемент итерации"""
        if self._index < len(self._data1):
            result = self._data1[self._index]
            self._index += 1
            return result
        else:
            raise StopIteration


class SingletonMeta(type):
    _instances = {}
    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            instance = super().__call__(*args, **kwargs)
            cls._instances[cls] = instance
        return cls._instances[cls]


class SingletonCustomLinkedList(CustomLinkedList, metaclass=SingletonMeta):
    pass


class LinkedListFactory:
    def create_linked_list(self, singleton=False):
        if singleton:
            return SingletonCustomLinkedList()
        return CustomLinkedList()


class LinkedListFacade:
    def __init__(self, singleton=False):
        self.linked_list = LinkedListFactory().create_linked_list(singleton)

    def insert(self, data1):
        self.linked_list.insert(data1)

    def append(self, data1):
        self.linked_list.append(data1)

    def remove(self):
        self.linked_list.remove()

    def delete(self):
        self.linked_list.delete()

    def iterate(self):
        self.linked_list.iterate()

    def size(self):
        return self.linked_list.size()

    def __str__(self):
        """Возвращает строковое представление списка"""
        return str(self.linked_list)


if __name__ == "__main__":
    data1_list = LinkedListFacade(singleton=True)

    data1_list.insert(3)
    data1_list.insert(2)
    data1_list.insert(1)
    print("Список после вставки в голову:")
    print(data1_list)

    data1_list.append(4)
    data1_list.append(5)
    print("Список после вставки в хвост:")
    print(data1_list)

    data1_list.remove()
    print("Список после удаления из головы:")
    print(data1_list)

    data1_list.delete()
    print("Список после удаления из хвоста:")
    print(data1_list)

    print("Размер списка:", data1_list.size())