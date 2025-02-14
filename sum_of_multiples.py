def sum_of_multiples(limit):
    return sum(x for x in range(1, limit) if x % 3 == 0 or x % 5 == 0)

limit = 1000
result = sum_of_multiples(limit)
print(f"The sum of all numbers from 1 to {limit} that are multiples of 3 or 5 is: {result}")