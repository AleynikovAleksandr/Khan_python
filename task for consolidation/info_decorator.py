import sys

def info_decorator(func):
    def wrapper(*args, **kwargs):
        if not args:
            raise ValueError("Ошибка: Не переданы аргументы.")

        for arg in args:
            if not isinstance(arg, (int, float)):  
                raise TypeError(f"Неверный тип аргумента: {type(arg)}. Ожидается int или float.")
        
        result = func(*args, **kwargs)
        print(f"Тип результата: {type(result)}")
        print(f"Объём памяти: {sys.getsizeof(result)} байт(а)")
        return result
    return wrapper

@info_decorator
def sum_args(*args):
    return sum(args)

print("Результат:", sum_args(1, 2, 3, 4, 5))  
