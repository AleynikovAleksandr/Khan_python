from sqlalchemy import text
import pandas as pd
from database_config import DatabaseConfig # если конфиг в отдельном файле

# SQL-запрос (один в один как у тебя)
sql = text("""
SELECT 
    ro.order_id,
    ro.open_time,
    ro.total_cost,
    os.status_name,
    v.passport AS visitor_passport,
    v.bank_card,
    v.login AS visitor_login,
    rt.table_id,
    rt.table_label,
    rt.seat_count,
    zt.zone_type AS table_zone,
    pc.check_id,
    pc.date_time AS check_date,
    pt.payment_name AS payment_type,
    pc.amount_paid,
    pc.change_amount,
    mi.menu_item_id,
    mi.menu_name,
    mi.price AS menu_price,
    dio.quantity
FROM restaurant_order ro
JOIN visitor v ON ro.visitor_passport = v.passport
JOIN waiter w ON ro.waiter_login = w.login
JOIN restaurant_table rt ON ro.table_id = rt.table_id
JOIN zone_type zt ON rt.zone_type_id = zt.zone_type_id
JOIN order_status os ON ro.status_id = os.status_id
JOIN payment_check pc ON ro.check_id = pc.check_id
JOIN payment_type pt ON pc.payment_type_id = pt.payment_type_id
JOIN dishes_in_order dio ON ro.order_id = dio.order_id
JOIN menu_item mi ON dio.menu_item_id = mi.menu_item_id
WHERE ro.order_id <= :max_order_id
ORDER BY ro.order_id
""")

# Подключение и выполнение
with DatabaseConfig.engine.connect() as connection:
    df = pd.read_sql(sql, connection, params={"max_order_id": 3000})

# Сохранение в CSV
df.to_csv("restaurant_orders.csv", index=False, encoding="utf-8-sig")
