def mod_exp(base, exp, mod):
    result = 1
    base = base % mod
    while exp > 0:
        if exp % 2 == 1:
            result = (result * base) % mod
        base = (base * base) % mod
        exp //= 2
    return result

m = 15
n = 143
e = 37
d = 13

s = mod_exp(m, d, n)
print("Подпись s =", s)

m_check = mod_exp(s, e, n)
print("Проверка m =", m_check)
print("Подпись ВЕРНА" if m_check == m else "Подпись НЕВЕРНА")

tests = [(46, 85), (16, 74), (129, 116)]

print("\nПроверка сообщений:")
for m_val, s_val in tests:
    m_calc = mod_exp(s_val, e, n)
    print(f"<{m_val}, {s_val}> -> {'верно' if m_calc == m_val else 'неверно'}")