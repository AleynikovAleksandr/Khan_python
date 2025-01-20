import numpy as np

n = int(input("Введите положительное целое число n: "))
m = int(input("Введите положительное целое число m: "))

array = np.arange(n * m, 0, -1).reshape(n, m)

print(array)
