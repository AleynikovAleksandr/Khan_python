import numpy as np

n = int(input("Введите число n: "))

points = np.linspace(0, 7, n)

print("Массив точек:", points)
step = points[1] - points[0] if n > 1 else 0
print("Шаг между элементами:", step)
