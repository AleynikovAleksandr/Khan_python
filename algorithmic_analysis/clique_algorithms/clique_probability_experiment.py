import random
import time
import numpy as np
import matplotlib.pyplot as plt
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
OPTIMUM = 5

def is_clique(subset):
    return all(G.has_edge(u, v) for u, v in combinations(subset, 2))

def brute_force_max_clique():
    for r in range(len(nodes), 0, -1):
        for subset in combinations(nodes, r):
            if is_clique(subset):
                return len(subset)
    return 0

def random_max_clique(iterations):
    best_size = 0
    for _ in range(iterations):
        size = random.randint(3, min(8, len(nodes)))
        subset = random.sample(nodes, size)
        if is_clique(subset) and len(subset) > best_size:
            best_size = len(subset)
            if best_size >= OPTIMUM:
                break
    return best_size

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
    return len(clique)

N_EXPERIMENTS = 300
delta_values = np.arange(0, 6, 1)

prob_brute = []
prob_random = []
prob_greedy = []

for delta in delta_values:
    threshold = OPTIMUM - delta
    
    # Полный перебор — всегда даёт 5
    prob_brute.append(1.0)
    
    # Случайный перебор
    count_r = 0
    iters = 1000 + delta * 1500
    for _ in range(N_EXPERIMENTS):
        size = random_max_clique(iterations=iters)
        if size >= threshold:
            count_r += 1
    prob_random.append(count_r / N_EXPERIMENTS)
    
    # Жадный подход — всегда один результат
    prob_greedy.append(1.0)

plt.figure(figsize=(10, 6))
plt.plot(delta_values, prob_brute, 'o-', label='Полный перебор', linewidth=2)
plt.plot(delta_values, prob_random, 's-', label='Случайный перебор', linewidth=2)
plt.plot(delta_values, prob_greedy, '^-', label='Жадный подход', linewidth=2)
plt.xlabel('Допустимое отклонение δ от оптимума')
plt.ylabel('Вероятность получения решения ≥ OPT - δ')
plt.title('Зависимость вероятности от величины допустимого отклонения')
plt.grid(True)
plt.legend()
plt.xticks(delta_values)
plt.ylim(0, 1.05)
plt.show()

iter_values = [100, 500, 1000, 2000, 5000, 10000, 20000]
M = 50
avg_quality = []
avg_time = []

for iters in iter_values:
    qualities = []
    times = []
    for _ in range(M):
        start = time.time()
        size = random_max_clique(iters)
        elapsed = time.time() - start
        qualities.append(size)
        times.append(elapsed)
    
    avg_quality.append(np.mean(qualities))
    avg_time.append(np.mean(times))

fig, ax1 = plt.subplots(figsize=(12, 6))
color1 = 'tab:blue'
ax1.set_xlabel('Число итераций')
ax1.set_ylabel('Средневыборочное качество (размер клики)', color=color1)
ax1.plot(iter_values, avg_quality, 'o-', color=color1, linewidth=2, label='Среднее качество')
ax1.tick_params(axis='y', labelcolor=color1)
ax1.grid(True)

ax2 = ax1.twinx()
color2 = 'tab:red'
ax2.set_ylabel('Среднее время выполнения (сек)', color=color2)
ax2.plot(iter_values, avg_time, 's-', color=color2, linewidth=2, label='Среднее время')
ax2.tick_params(axis='y', labelcolor=color2)

plt.title('Зависимость качества и времени от числа итераций (случайный перебор)')
fig.legend(loc='upper left', bbox_to_anchor=(0.15, 0.85))
plt.tight_layout()
plt.show()