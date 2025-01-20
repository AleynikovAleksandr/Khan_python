import numpy as np

n = int(input("Введите количество точек n: "))

x = np.linspace(0, 3, n)

y = 3*x**2 + 2*x + 3

print("Значения функции для точек в диапазоне [0, 3]:")
print(y)
