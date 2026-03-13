import random
import time
import heapq
import multiprocessing as mp
from functools import wraps
from typing import List, Tuple, Callable


def timer(func: Callable) -> Callable:
    @wraps(func)
    def wrapper(*args, **kwargs):
        start = time.perf_counter()
        result = func(*args, **kwargs)
        elapsed = time.perf_counter() - start
        return result, elapsed
    return wrapper


def generate_graph(n: int, density: float = 0.1, max_weight: int = 30) -> List[List[Tuple[int, int]]]:
    graph = [[] for _ in range(n)]
    for i in range(n):
        for j in range(n):
            if i != j and random.random() < density:
                w = random.randint(1, max_weight)
                graph[i].append((j, w))
    return graph


@timer
def dijkstra_sequential(graph: List[List[Tuple[int, int]]], start: int) -> List[float]:
    n = len(graph)
    dist = [float('inf')] * n
    visited = [False] * n
    dist[start] = 0
    pq = [(0, start)]

    while pq:
        du, u = heapq.heappop(pq)
        if visited[u]:
            continue
        visited[u] = True
        for v, w in graph[u]:
            if not visited[v] and dist[v] > du + w:
                dist[v] = du + w
                heapq.heappush(pq, (dist[v], v))
    return dist


def relax_chunk(args):
    du, neighbors_chunk, dist_snapshot = args
    updates = []
    for v, w in neighbors_chunk:
        new_dist = du + w
        if new_dist < dist_snapshot[v]:
            updates.append((v, new_dist))
    return updates


@timer
def dijkstra_parallel(graph: List[List[Tuple[int, int]]], start: int, processes: int = 4) -> List[float]:
    n = len(graph)
    dist = [float('inf')] * n
    visited = [False] * n
    dist[start] = 0
    pq = [(0, start)]

    with mp.Pool(processes=processes) as pool:
        while pq:
            du, u = heapq.heappop(pq)
            if visited[u]:
                continue
            visited[u] = True
            neighbors = graph[u]
            if not neighbors:
                continue
            chunk_size = max(1, len(neighbors) // processes)
            tasks = [
                (du, neighbors[i:i + chunk_size], dist.copy())
                for i in range(0, len(neighbors), chunk_size)
            ]
            if len(tasks) > 1:
                results = pool.map(relax_chunk, tasks)
            else:
                results = [relax_chunk(tasks[0])]
            for updates in results:
                for v, new_dist in updates:
                    if new_dist < dist[v]:
                        dist[v] = new_dist
                        heapq.heappush(pq, (new_dist, v))
    return dist


def run_tests():
    print("Vertices | Sequential | 2 cores | 4 cores | Speedup(2) | Speedup(4)")
    print("-" * 75)

    for n in range(100, 1001, 100):
        graph = generate_graph(n, density=0.08)

        _, t_seq = dijkstra_sequential(graph, 0)
        _, t_par2 = dijkstra_parallel(graph, 0, processes=2)
        _, t_par4 = dijkstra_parallel(graph, 0, processes=4)

        speedup2 = t_seq / t_par2 if t_par2 > 1e-9 else 0
        speedup4 = t_seq / t_par4 if t_par4 > 1e-9 else 0

        print(f"{n:8} | {t_seq:10.4f} | {t_par2:8.4f} | {t_par4:8.4f} | "
              f"{speedup2:10.3f} | {speedup4:10.3f}")


if __name__ == "__main__":
    mp.set_start_method("spawn", force=True)
    random.seed(42)
    run_tests()