import random
import time
import math
from itertools import combinations
import networkx as nx

graph = {
    1: [2, 3, 4, 5],
    2: [1, 3, 4, 5, 6],
    3: [1, 2, 4, 5, 7],
    4: [1, 2, 3, 5, 8],
    5: [1, 2, 3, 4, 9],
    6: [2, 7, 10, 11],
    7: [3, 6, 8, 12],
    8: [4, 7, 9, 13],
    9: [5, 8, 10, 14],
    10: [6, 9, 11, 15],
    11: [6, 10, 12],
    12: [7, 11, 13],
    13: [8, 12, 14],
    14: [9, 13, 15],
    15: [10, 14]
}

G = nx.Graph()
for u in graph:
    for v in graph[u]:
        if u < v:
            G.add_edge(u, v)

nodes = list(G.nodes())

def is_clique(subset):
    for i in range(len(subset)):
        for j in range(i + 1, len(subset)):
            if not G.has_edge(subset[i], subset[j]):
                return False
    return True

def brute_force_max_clique():
    for r in range(len(nodes), 0, -1):
        for subset in combinations(nodes, r):
            if is_clique(subset):
                return len(subset), subset
    return 0, []

def random_max_clique(iterations=5000):
    best_size = 0
    best_clique = []
    for _ in range(iterations):
        size = random.randint(3, min(8, len(nodes)))
        subset = random.sample(nodes, size)
        if is_clique(subset) and len(subset) > best_size:
            best_size = len(subset)
            best_clique = subset
            if best_size >= 5:
                break
    return best_size, best_clique

def greedy_max_clique():
    sorted_nodes = sorted(nodes, key=G.degree, reverse=True)
    clique = []
    for v in sorted_nodes:
        can_add = True
        for u in clique:
            if not G.has_edge(u, v):
                can_add = False
                break
        if can_add:
            clique.append(v)
    return len(clique), clique

K = 100

brute_sizes = []
random_sizes = []
greedy_sizes = []

for i in range(K):
    size_b, _ = brute_force_max_clique()
    brute_sizes.append(size_b)

    size_r, _ = random_max_clique()
    random_sizes.append(size_r)

    size_g, _ = greedy_max_clique()
    greedy_sizes.append(size_g)

def print_stats(sizes, name):
    n = len(sizes)
    mean = sum(sizes) / n
    if n > 1:
        var = sum((x - mean) ** 2 for x in sizes) / (n - 1)
    else:
        var = 0.0
    std = math.sqrt(var)
    z = 1.96
    se = std / math.sqrt(n) if n > 1 else 0.0
    lower = mean - z * se
    upper = mean + z * se
    print(f"{name}:")
    print(f"  Средневыборочная оценка качества: {mean:.4f}")
    print(f"  Дисперсия: {var:.4f}")
    print(f"  Среднеквадратичное отклонение: {std:.4f}")
    print(f"  95% доверительный интервал: [{lower:.4f}, {upper:.4f}]")
    print()

print_stats(brute_sizes, "1. Полный перебор")
print_stats(random_sizes, "2. Случайный перебор")
print_stats(greedy_sizes, "3. Жадный подход")