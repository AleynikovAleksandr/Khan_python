import random
from datetime import datetime, timedelta
from faker import Faker
from sqlalchemy.exc import IntegrityError
from database_config import DatabaseConfig
from models import (
    Base, RestaurantOrder, DishesInOrder, PaymentCheck, MenuItem, 
    Visitor, Waiter, RestaurantTable, OrderStatus
)

fake = Faker()
session = DatabaseConfig.SessionLocal()

# Получаем все данные для связей
menu_items = session.query(MenuItem).all()
menu_item_ids = [item.menu_item_id for item in menu_items]
visitors = session.query(Visitor).all()
waiters = session.query(Waiter).all()
tables = session.query(RestaurantTable).all()
statuses = session.query(OrderStatus).all()
payment_types = [1, 2]  # 1 - Наличный, 2 - Безналичный
dish_counts = [1, 2, 6, 9, 10, 14, 20, 50]

for _ in range(3000):
    visitor = random.choice(visitors)
    waiter = random.choice(waiters)
    table = random.choice(tables)
    open_time = datetime.now() - timedelta(days=random.randint(0, 60), hours=random.randint(0,23))
    
    # Выбираем случайное количество блюд и уникальные блюда
    num_dishes = random.choice(dish_counts)
    chosen_menu_ids = random.sample(menu_item_ids, min(num_dishes, len(menu_item_ids)))

    # Считаем total_cost
    total_cost = round(sum([float(session.query(MenuItem).get(mid).price) for mid in chosen_menu_ids]), 2)

    # Выбираем тип оплаты и считаем сдачу
    payment_type_id = random.choice(payment_types)
    if payment_type_id == 1:  # Наличные
        amount_paid = round(total_cost + random.randint(0, 1000), 2)
        change_amount = round(amount_paid - total_cost, 2)
    else:
        amount_paid = total_cost
        change_amount = 0

    # Создаём чек сначала
    check = PaymentCheck(
        date_time=open_time,
        payment_type_id=payment_type_id,
        amount_paid=amount_paid,
        total_amount=total_cost,
        change_amount=change_amount
    )
    session.add(check)
    session.flush()
    session.refresh(check)

    # Случайный статус
    status = random.choice(statuses)

    # Создаём заказ
    order = RestaurantOrder(
        check_id=check.check_id,
        waiter_login=waiter.login,
        open_time=open_time,
        table_id=table.table_id,
        total_cost=total_cost,
        status_id=status.status_id,
        visitor_passport=visitor.passport
    )
    session.add(order)
    session.flush()
    session.refresh(order)

    # Добавляем блюда в заказ
    for mid in chosen_menu_ids:
        dio = DishesInOrder(
            menu_item_id=mid,
            order_id=order.order_id,
            quantity=1
        )
        session.add(dio)

try:
    session.commit()
except IntegrityError as e:
    print(f"Ошибка при добавлении: {e}")
    session.rollback()
finally:
    session.close()
