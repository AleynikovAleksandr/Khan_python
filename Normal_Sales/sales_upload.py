from hdfs import InsecureClient

client = InsecureClient('http://172.22.0.2:98700', user='alex')

local_path = '/home/alex_a/Khan_python/Normal_Sales/sales_records_norm.parquet'
hdfs_path = '/Alexander_Aleinikov/sales_records_norm.parquet'

client.upload(hdfs_path, local_path, overwrite=True)