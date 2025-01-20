import numpy as np


n = int(input("Введите положительное целое число n: "))

array = np.linspace(0, 5, n)

result = array * 3

print(result)
