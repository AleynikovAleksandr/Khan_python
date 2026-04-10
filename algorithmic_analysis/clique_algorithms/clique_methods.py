import random
import time
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

def random_max_clique(iterations=20000):
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

start = time.time()
size_brute, clique_brute = brute_force_max_clique()
time_brute = time.time() - start

print(f"1. Полный перебор:")
print(f"   Размер максимальной клики: {size_brute}")
print(f"   Пример клики: {sorted(clique_brute)}")
print(f"   Время выполнения: {time_brute:.4f} сек\n")

start = time.time()
size_rand, clique_rand = random_max_clique()
time_rand = time.time() - start

print(f"2. Случайный перебор (20000 итераций):")
print(f"   Найденный размер: {size_rand}")
print(f"   Пример клики: {sorted(clique_rand)}")
print(f"   Время выполнения: {time_rand:.4f} сек\n")

start = time.time()
size_greedy, clique_greedy = greedy_max_clique()
time_greedy = time.time() - start

print(f"3. Жадный подход:")
print(f"   Найденный размер: {size_greedy}")
print(f"   Построенная клика: {sorted(clique_greedy)}")
print(f"   Время выполнения: {time_greedy:.4f} сек")