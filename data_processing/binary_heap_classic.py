class MaxHeap:
    def __init__(self, arr=None):
        self.heap = arr or []
        if arr:
            self.build_heap()

    def build_heap(self):
        """Построение кучи из неупорядоченного массива."""
        n = len(self.heap)
        for i in range((n - 2) // 2, -1, -1):
            self._heapify_down(i)

    def insert(self, key):
        """Вставка элемента в кучу."""
        self.heap.append(key)
        self._heapify_up(len(self.heap) - 1)

    def extract_max(self):
        """Удаление и возврат максимального элемента (корня)."""
        if not self.heap:
            return None
        if len(self.heap) == 1:
            return self.heap.pop()
        max_val = self.heap[0]
        self.heap[0] = self.heap.pop()
        self._heapify_down(0)
        return max_val

    def _heapify_up(self, index):
        parent = (index - 1) // 2
        while index > 0 and self.heap[index] > self.heap[parent]:
            self.heap[index], self.heap[parent] = self.heap[parent], self.heap[index]
            index = parent
            parent = (index - 1) // 2

    def _heapify_down(self, index):
        n = len(self.heap)
        largest = index
        left = 2 * index + 1
        right = 2 * index + 2

        if left < n and self.heap[left] > self.heap[largest]:
            largest = left
        if right < n and self.heap[right] > self.heap[largest]:
            largest = right

        if largest != index:
            self.heap[index], self.heap[largest] = self.heap[largest], self.heap[index]
            self._heapify_down(largest)

    # ---------- Печать кучи в стиле дерева (без None) ----------
    def print_tree(self):
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


# ====================== Пример использования ======================
if __name__ == "__main__":
    arr = [3, 1, 6, 5, 2, 4]
    heap = MaxHeap(arr)

    print("Куча после построения из массива:")
    heap.print_tree()

    value_to_insert = 10
    print(f"\nВставляем элемент {value_to_insert}:")
    heap.insert(value_to_insert)
    heap.print_tree()

    print("\nУдаляем максимальный элемент:")
    max_val = heap.extract_max()
    print("Удаленный элемент:", max_val)
    heap.print_tree()
