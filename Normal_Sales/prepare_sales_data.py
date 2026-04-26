import pandas as pd

df = pd.read_csv('/home/alex_a/Khan_python/Normal_Sales/sales_records.csv')

min_val = df['Total Profit'].min()
max_val = df['Total Profit'].max()
df['Total Profit_norm'] = (df['Total Profit'] - min_val) / (max_val - min_val)

df.drop(columns=['Total Profit'], inplace=True)

df.to_parquet('/home/alex_a/Khan_python/Normal_Sales/sales_records_norm.parquet', index=False)
print(df.head()) 