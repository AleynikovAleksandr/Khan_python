class Node:
    def __init__(self, key):
        self.key = key
        self.left = None
        self.right = None

class MinHeap:
    def __init__(self, arr=None):
        self.heap = arr or []
        if arr:
            self.build_heap()

    def build_heap(self):
        """Построение min-heap из массива"""
        n = len(self.heap)
        for i in range((n - 2) // 2, -1, -1):
            self._heapify_down(i)

    def insert(self, key):
        """Вставка элемента в min-heap"""
        self.heap.append(key)
        self._heapify_up(len(self.heap) - 1)

    def extract_min(self):
        """Извлечение минимального элемента"""
        if not self.heap:
            return None
        if len(self.heap) == 1:
            return self.heap.pop()
        min_val = self.heap[0]
        self.heap[0] = self.heap.pop()
        self._heapify_down(0)
        return min_val

    def _heapify_up(self, index):
        """Восстановление свойств кучи снизу вверх"""
        parent = (index - 1) // 2
        while index > 0 and self.heap[index] < self.heap[parent]:
            self.heap[index], self.heap[parent] = self.heap[parent], self.heap[index]
            index = parent
            parent = (index - 1) // 2

    def _heapify_down(self, index):
        """Восстановление свойств кучи сверху вниз"""
        n = len(self.heap)
        smallest = index
        left = 2 * index + 1
        right = 2 * index + 2

        if left < n and self.heap[left] < self.heap[smallest]:
            smallest = left
        if right < n and self.heap[right] < self.heap[smallest]:
            smallest = right

        if smallest != index:
            self.heap[index], self.heap[smallest] = self.heap[smallest], self.heap[index]
            self._heapify_down(smallest)

    def print_tree(self):
        """Визуализация кучи в виде дерева"""
        if not self.heap:
            print("Куча пуста")
            return
        self._print_tree_recursive(0, "", True)

    def _print_tree_recursive(self, index, prefix="", is_left=True):
        if index >= len(self.heap):
            return
        print(prefix, end="")
        print("└── " if is_left else "┌── ", end="")
        print(self.heap[index])
        
        left_index = 2 * index + 1
        right_index = 2 * index + 2
        new_prefix = prefix + ("    " if is_left else "│   ")
        
        if right_index < len(self.heap):
            self._print_tree_recursive(right_index, new_prefix, False)
        if left_index < len(self.heap):
            self._print_tree_recursive(left_index, new_prefix, True)

# ---------- Функция для построения min-heap из любого бинарного дерева ----------
def build_min_heap_from_any_tree(root):
    """
    Собирает убывающую кучу (min-heap) из любого бинарного дерева.
    
    Args:
        root: Корень произвольного бинарного дерева
        
    Returns:
        MinHeap: Убывающая куча, построенная из элементов дерева
    """
    values = []

    def collect_values(node):
        """Рекурсивный обход дерева для сбора всех значений"""
        if node:
            values.append(node.key)
            collect_values(node.left)
            collect_values(node.right)

    # Собираем все значения из дерева
    collect_values(root)
    
    # Строим min-heap из собранных значений
    return MinHeap(values)

# ---------- Функция для построения произвольного бинарного дерева ----------
def build_arbitrary_tree(keys):
    """
    Строит произвольное бинарное дерево из списка ключей.
    Дерево строится последовательно, без соблюдения свойств кучи.
    """
    if not keys:
        return None
    
    nodes = [Node(key) for key in keys]
    
    # Связываем узлы в дерево (левый потомок = 2*i+1, правый = 2*i+2)
    for i in range(len(nodes)):
        left_idx = 2 * i + 1
        right_idx = 2 * i + 2
        
        if left_idx < len(nodes):
            nodes[i].left = nodes[left_idx]
        if right_idx < len(nodes):
            nodes[i].right = nodes[right_idx]
    
    return nodes[0]

# ---------- Дополнительная функция для красивого вывода произвольного дерева ----------
def print_tree_structure(node, prefix="", is_left=True):
    """Рекурсивный вывод структуры бинарного дерева"""
    if node is None:
        return
    
    print(prefix + ("└── " if is_left else "┌── ") + str(node.key))
    
    new_prefix = prefix + ("    " if is_left else "│   ")
    
    if node.right:
        print_tree_structure(node.right, new_prefix, False)
    if node.left:
        print_tree_structure(node.left, new_prefix, True)

# ====================== Пример использования ======================
if __name__ == "__main__":
    # Произвольные ключи (не упорядочены как куча)
    keys = [50, 30, 78, 20, 40, 60, 90]
    
    # Строим произвольное бинарное дерево
    root = build_arbitrary_tree(keys)
    
    print("Исходное произвольное бинарное дерево:")
    print_tree_structure(root)
    
    # Строим min-heap из произвольного дерева
    min_heap = build_min_heap_from_any_tree(root)
    
    print("\nУбывающая куча (min-heap), построенная из дерева:")
    min_heap.print_tree()
    
    # Демонстрация работы min-heap
    print(f"\nМинимальный элемент: {min_heap.extract_min()}")
    print("Куча после извлечения минимума:")
    min_heap.print_tree()