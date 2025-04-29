import sys

params = {}

for keyval in sys.argv[1:]:
    if '=' in keyval:
        raw_key, value = keyval.split('=', 1)
        key = raw_key.lstrip('-')  

        if value.isdigit():
            params[key] = int(value)
        else:
            try:
                float_val = float(value)
                params[key] = float_val
            except ValueError:
                params[key] = value
    else:
        print(f"Пропущен некорректный аргумент: {keyval}")

print('\n'.join(f"{k.ljust(max(len(k) for k in params))} : {str(v).ljust(10)} > ({type(v).__name__})" for k, v in params.items()))

#python3 data_parsing.py --var1=100 --var2=3.14 --var3=1e-21 --var4=good