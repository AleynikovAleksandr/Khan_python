import sys
from functools import wraps

def memory_usage_decorator(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        result = func(*args, **kwargs)
        size = sys.getsizeof(result)
        print(f"[INFO] Размер возвращаемого значения: {size} байт")
        return result
    return wrapper

@memory_usage_decorator
def get_list(n):
    return list(range(n))

my_list = get_list(1000)
