import time
import timeit
import tracemalloc

class Node:
    def __init__(self, key):
        self.key = key
        self.left = None
        self.right = None

class BinarySearchTree:
    def __init__(self):
        self.root = None

    def insert(self, key):
        new_node = Node(key)
        if self.root is None:
            self.root = new_node
            return

        current = self.root
        while True:
            if key < current.key:
                if current.left is None:
                    current.left = new_node
                    break
                current = current.left
            elif key > current.key:
                if current.right is None:
                    current.right = new_node
                    break
                current = current.right
            else:
                break

    def search(self, key):
        current = self.root
        while current is not None:
            if key == current.key:
                return current
            elif key < current.key:
                current = current.left
            else:
                current = current.right
        return None

class BSTAdapter:
    def __init__(self, bst: BinarySearchTree):
        self.bst = bst

    def find(self, key):
        result = self.bst.search(key)
        return result.key if result else None

def benchmark(func, *args, repeats=10):
    start = timeit.default_timer()
    for _ in range(repeats):
        _ = func(*args)
    return (timeit.default_timer() - start) * 1000 / repeats

def run_experiment(sizes, search_key=80, repeats=20):
    print(f"{'Размер дерева':>12} | {'Ключ':>6} | {'Среднее время (мс)':>18}")
    print("-" * 42)
    for size in sizes:
        bst = BinarySearchTree()
        values = list(range(1, size + 1))
        for val in values:
            bst.insert(val)

        adapter = BSTAdapter(bst)
        elapsed = benchmark(adapter.find, search_key, repeats=repeats)
        found = adapter.find(search_key)

        print(f"{size:12d} | {search_key:6d} | {elapsed:18.6f}")

if __name__ == "__main__":
    sizes = list(range(100, 1001, 100))

    start_time = time.time()
    tracemalloc.start()

    run_experiment(sizes, search_key=80)

    current, peak = tracemalloc.get_traced_memory()
    tracemalloc.stop()
    end_time = time.time()

    print("\nОбщее время работы программы: {:.6f} сек".format(end_time - start_time))
    print("Используемая память: {:.2f} KB".format(current / 1024))
    print("Пиковое использование памяти: {:.2f} KB".format(peak / 1024))
