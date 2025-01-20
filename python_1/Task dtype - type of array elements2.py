import numpy as np

n = int(input("Введите положительное целое число n: "))


array = np.arange(1, n**2 + 1, dtype=float).reshape(n, n)

print(array)
