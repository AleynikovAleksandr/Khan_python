import time
import sys
sys.setrecursionlimit(20000)

class Node:
    def __init__(self, key):
        self.key = key
        self.left = self.right = None

def insert(root, key):
    if root is None:
        return Node(key)
    if key < root.key:
        root.left = insert(root.left, key)
    else:
        root.right = insert(root.right, key)
    return root

def find_min(root):
    while root.left:
        root = root.left
    return root.key

def build_balanced_bst(elements):
    if not elements:
        return None
    mid = len(elements) // 2
    node = Node(elements[mid])
    node.left = build_balanced_bst(elements[:mid])
    node.right = build_balanced_bst(elements[mid+1:])
    return node

def build_left_skewed_bst(elements):
    root = None
    for key in reversed(elements):
        root = insert(root, key)
    return root

def benchmark(func, *args, repeats=10):
    start = time.perf_counter()
    for _ in range(repeats):
        func(*args)
    elapsed = (time.perf_counter() - start) * 1000 / repeats  # ms
    return elapsed

def main():
    print(f"{'Кол-во узлов':<15}{'Сбаланс. дерево (мс)':<25}{'Несбаланс. дерево (мс)'}")
    sizes = list(range(100, 1000, 100)) + list(range(1000, 10001, 1000))
    repeats = 3

    for n in sizes:
        data = list(range(1, n + 1))
        balanced_tree = build_balanced_bst(data)
        unbalanced_tree = build_left_skewed_bst(data)

        balanced_time = benchmark(find_min, balanced_tree, repeats=repeats)
        unbalanced_time = benchmark(find_min, unbalanced_tree, repeats=repeats)

        print(f"{n:<15}{balanced_time:<25.6f}{unbalanced_time:.6f}")

if __name__ == "__main__":
    main()