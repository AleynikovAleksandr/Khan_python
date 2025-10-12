import time
import timeit
import tracemalloc
import random

# Имплементация хеш-таблицы с открытой адресацией
class HashTableOpenAddressing:
    def __init__(self, size):
        self.size = size
        self.table = [None] * size

    def _hash(self, key):
        return key % self.size

    def insert(self, key):
        idx = self._hash(key)
        for i in range(self.size):
            probe_idx = (idx + i) % self.size
            if self.table[probe_idx] is None:
                self.table[probe_idx] = key
                return
        raise Exception("Hash table is full")

    def search(self, key):
        idx = self._hash(key)
        for i in range(self.size):
            probe_idx = (idx + i) % self.size
            if self.table[probe_idx] == key:
                return key
            if self.table[probe_idx] is None:
                return None
        return None

# Абстракция поиска (Bridge interface)
class TableSearch:
    def find(self, key):
        raise NotImplementedError()

# Реализация моста: связывает абстракцию и реализацию
class HashTableSearchBridge(TableSearch):
    def __init__(self, table_impl):
        self.table_impl = table_impl

    def find(self, key):
        return self.table_impl.search(key)

# Можно добавить другие реализации поиска — например, для другой структуры данных
# class LinearTable: ...
# class LinearTableSearchBridge(TableSearch): ...

def benchmark(func, *args, repeats=10):
    start = timeit.default_timer()
    for _ in range(repeats):
        _ = func(*args)
    return (timeit.default_timer() - start) * 1000 / repeats

def run_experiment(slot_sizes, load_factors, search_key=80, repeats=20):
    print(f"{'Слотов':>7} | {'Фактор загрузки':>15} | {'Ключ':>6} | {'Среднее время (мс)':>18}")
    print("-" * 60)
    for size in slot_sizes:
        for load_factor in load_factors:
            num_elements = int(size * load_factor)
            ht = HashTableOpenAddressing(size)
            values = random.sample(range(1, size * 10), num_elements)
            for val in values:
                ht.insert(val)
            # Гарантируем, что search_key точно есть
            ht.insert(search_key)
            # Используем мост для поиска
            searcher = HashTableSearchBridge(ht)
            elapsed = benchmark(searcher.find, search_key, repeats=repeats)
            found = searcher.find(search_key)
            print(f"{size:7d} | {load_factor:15.2f} | {search_key:6d} | {elapsed:18.6f}")

if __name__ == "__main__":
    slot_sizes = list(range(100, 1001, 100))  # количество слотов
    load_factors = [0.3, 0.5, 0.7, 0.9]       # фактор загрузки

    start_time = time.time()
    tracemalloc.start()

    run_experiment(slot_sizes, load_factors, search_key=80)

    current, peak = tracemalloc.get_traced_memory()
    tracemalloc.stop()
    end_time = time.time()

    print("\nОбщее время работы программы: {:.6f} сек".format(end_time - start_time))
    print("Используемая память: {:.2f} KB".format(current / 1024))
    print("Пиковое использование памяти: {:.2f} KB".format(peak / 1024))