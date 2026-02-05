import time
import sys
import functools

def time_measure(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        start = time.perf_counter()
        result = func(*args, **kwargs)
        end = time.perf_counter()
        return result, end - start
    return wrapper

class TraversalStrategy:
    def traverse(self, tree):
        result = []
        for index in self.order(tree):
            result.append(tree.data[index])
        return result

    def order(self, tree):
        raise NotImplementedError

class ReverseRightTraversalStrategy(TraversalStrategy):
    def order(self, tree):
        yield from self._order(0, tree)

    def _order(self, index, tree):
        if index >= tree.size:
            return
        yield from self._order(2 * index + 2, tree)  # правый потомок
        yield from self._order(2 * index + 1, tree)  # левый потомок
        yield index  # текущий узел

class ArrayBinaryTree:
    def __init__(self, size, strategy: TraversalStrategy):
        self.size = size
        self.data = list(range(size))
        self.strategy = strategy

    def set_strategy(self, strategy: TraversalStrategy):
        self.strategy = strategy

    def traverse(self):
        return self.strategy.traverse(self)

class TreeTestRunner:
    def __init__(self, start=100, end=1000, step=100):
        self.start = start
        self.end = end
        self.step = step
        self.strategy = ReverseRightTraversalStrategy()

    @time_measure
    def run_traversal(self, tree):
        return tree.traverse()

    def run_tests(self):
        print(f"{'Вершины':<10}{'Время (с)':<15}{'Память (байт)':<20}")
        print("-" * 45)
        total_memory = 0  # для суммарной памяти
        for size in range(self.start, self.end + 1, self.step):
            tree = ArrayBinaryTree(size, self.strategy)
            _, exec_time = self.run_traversal(tree)
            memory_usage = sys.getsizeof(tree) + sys.getsizeof(tree.data)
            total_memory += memory_usage  # суммируем память
            print(f"{size:<10}{exec_time:<15.6f}{memory_usage:<20}")
        
        print("-" * 45)
        print(f"{'Итого память (байт)':<25}{total_memory:<20}")

# Основной запуск программы
program_start = time.perf_counter()
tester = TreeTestRunner()
tester.run_tests()
program_end = time.perf_counter()
print("Общее время работы программы:", f"{program_end - program_start:.6f} сек")
