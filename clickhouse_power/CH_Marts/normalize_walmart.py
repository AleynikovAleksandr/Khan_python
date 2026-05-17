import pandas as pd
from sklearn.preprocessing import MinMaxScaler

file_path = '/home/alex_a/Khan_python/CH_Marts/Walmart_Sales.csv'
walmart_sales = pd.read_csv(file_path)

cols = [ 'Weekly_Sales', 'Temperature', 'Fuel_Price', 'CPI', 'Unemployment']

scaler = MinMaxScaler()

walmart_sales[[col + '_norm' for col in cols]] = scaler.fit_transform(walmart_sales[cols])

output_path = '/home/alex_a/Khan_python/CH_Marts/Walmart_normalized.csv'
walmart_sales.to_csv(output_path, index=False)