import sys

params = {}  

for keyval in sys.argv[1:]:
    key, value = keyval[1:].split('=')

    if value.isdigit():
        params.update({key: eval(value)})
    else:
        try:
            # Пробуем преобразовать в float (включая экспоненциальную форму)
            float_val = float(value)
            params.update({key: float_val})
        except ValueError:
            # Если не число — оставим как строку
            params.update({key: value})

for k, v in params.items():
    print(f"{k} = {v}({type(v)})")
    
#python data_parsing.py -var1=100 -var2=3.14 -var3=1e-21 -var4=Булки -var5=ещё -var6=мягких