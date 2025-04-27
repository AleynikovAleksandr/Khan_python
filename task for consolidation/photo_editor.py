"""
imp это программа ракетной обработки изображений
(image processing)
Входные параметры:
-dir папка, в которой следует искать изображения
-format расширение имени изображений
-action=scale команда для обработки файлам
-factor это коэффициент преобразования
-outdir пака для сохранения результата
"""
#python myimp.py -dir='files_5' -format=jpg -action=scale -factor=0.5 -outdir=out

import sys,os
from PIL import Image
import numpy as np
import imageio


params = {}
for keyvalue in sys.argv[1:]:
    key,value = keyvalue[1:].split('=')
    if value.isdecimal():       #для целых
        params.update({key:int(value)}) 
    elif value.replace('.','0').isdecimal(): #для десятичных
        params.update({key:float(value)})
    elif value.replace('e-','0').isdecimal() \
        or value.replace('e+','0').isdecimal()\
            or value.replace('e','0').isdecimal():
        params.update({key:eval(value)})  
    else:
        params.update({key:value})  

for key in params:
    print(f"Параметр {key} имеет занчение {params[key]} и тип {type(params[key])} ")

#1 обход файлов папки
dirAbsPath = os.path.abspath(params['dir'])
if not os.path.exists(dirAbsPath):
    raise FileNotFoundError

for fname in os.listdir(dirAbsPath):
    print('fname=',fname)
    if fname.split('.')[1] in ['jpg','png','tif']:
        #откроем картинку
        mat = imageio.v2.imread(os.path.join(dirAbsPath,fname))
        #выполним действие
        if params['action'] == 'scale':
            print(mat.shape)
            h,w,ch = mat.shape
            h_new,w_new = int(h*params['factor']),int(w*params['factor'])
            #mat_scaled = np.resize(mat,(h_new,w_new,ch))
            #mat_scaled = rescale(mat,params['factor'])
            mat_scaled = Image.fromarray(mat).resize((w_new,h_new))
        else:
            print('Команда не найдена!')   
        #сохраним картинку 
        #dirAbsOutPath = os.path.abspath(params['outdir'])
        if not os.path.exists(params['outdir']):
            os.makedirs(params['outdir'])
        foutpath = os.path.join(params['outdir'],fname.split('.')[0]+\
                                '_'+params['action']+'.'+fname.split('.')[1])
        imageio.imsave(foutpath,mat_scaled)