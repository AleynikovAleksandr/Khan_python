from sqlalchemy import Column, Integer, String, DECIMAL, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from database_config import DatabaseConfig

Base = DatabaseConfig.Base

# ==========================
#  ЗОНЫ И СТОЛЫ
# ==========================
class ZoneType(Base):
    __tablename__ = 'zone_type'

    zone_type_id = Column(Integer, primary_key=True, autoincrement=True)
    zone_type = Column(String(50), nullable=False)

    restaurant_tables = relationship("RestaurantTable", back_populates="zone_type", cascade="all, delete-orphan")


class RestaurantTable(Base):
    __tablename__ = 'restaurant_table'

    table_id = Column(Integer, primary_key=True, autoincrement=True)
    zone_type_id = Column(Integer, ForeignKey('zone_type.zone_type_id', ondelete='CASCADE', onupdate='CASCADE'), nullable=False)
    table_label = Column(String(50), nullable=False)
    seat_count = Column(Integer, nullable=False)

    zone_type = relationship("ZoneType", back_populates="restaurant_tables")
    orders = relationship("RestaurantOrder", back_populates="table", cascade="all, delete-orphan")


# ==========================
#  ВИЗИТОРЫ И ОФИЦИАНТЫ
# ==========================
class Visitor(Base):
    __tablename__ = 'visitor'

    passport = Column(String(10), primary_key=True)
    last_name = Column(String(50), nullable=False)
    first_name = Column(String(50), nullable=False)
    middle_name = Column(String(50))
    bank_card = Column(String(20), nullable=False)
    login = Column(String(50), nullable=False, unique=True)
    user_password = Column(String(255), nullable=False)

    orders = relationship("RestaurantOrder", back_populates="visitor", cascade="all, delete-orphan")


class Waiter(Base):
    __tablename__ = 'waiter'

    login = Column(String(50), primary_key=True)
    last_name = Column(String(50), nullable=False)
    first_name = Column(String(50), nullable=False)
    middle_name = Column(String(50))
    user_password = Column(String(255), nullable=False)

    orders = relationship("RestaurantOrder", back_populates="waiter", cascade="all, delete-orphan")


# ==========================
#  ОПЛАТА
# ==========================
class PaymentType(Base):
    __tablename__ = 'payment_type'

    payment_type_id = Column(Integer, primary_key=True, autoincrement=True)
    type_name = Column(String(50), nullable=False)

    payment_checks = relationship("PaymentCheck", back_populates="payment_type", cascade="all, delete-orphan")


class PaymentCheck(Base):
    __tablename__ = 'payment_check'

    check_id = Column(Integer, primary_key=True, autoincrement=True)
    date_time = Column(DateTime, nullable=False)
    payment_type_id = Column(Integer, ForeignKey('payment_type.payment_type_id', ondelete='CASCADE', onupdate='CASCADE'), nullable=False)
    amount_paid = Column(DECIMAL(10,2), nullable=False)
    total_amount = Column(DECIMAL(10,2), nullable=False)
    change_amount = Column(DECIMAL(10,2), nullable=False)

    payment_type = relationship("PaymentType", back_populates="payment_checks")
    orders = relationship("RestaurantOrder", back_populates="check", cascade="all, delete-orphan")


# ==========================
#  СТАТУСЫ ЗАКАЗА
# ==========================
class OrderStatus(Base):
    __tablename__ = 'order_status'

    status_id = Column(Integer, primary_key=True, autoincrement=True)
    status_name = Column(String(50), nullable=False)

    orders = relationship("RestaurantOrder", back_populates="status", cascade="all, delete-orphan")


# ==========================
#  МЕНЮ
# ==========================
class MenuItem(Base):
    __tablename__ = 'menu_item'

    menu_item_id = Column(Integer, primary_key=True, autoincrement=True)
    menu_name = Column(String(100), nullable=False)
    price = Column(DECIMAL(10,2), nullable=False)

    dishes_in_orders = relationship("DishesInOrder", back_populates="menu_item", cascade="all, delete-orphan")


# ==========================
#  ЗАКАЗЫ
# ==========================
class RestaurantOrder(Base):
    __tablename__ = 'restaurant_order'

    order_id = Column(Integer, primary_key=True, autoincrement=True)
    check_id = Column(Integer, ForeignKey('payment_check.check_id', ondelete='CASCADE', onupdate='CASCADE'), nullable=False)
    waiter_login = Column(String(50), ForeignKey('waiter.login', ondelete='CASCADE', onupdate='CASCADE'), nullable=False)
    open_time = Column(DateTime, nullable=False)
    table_id = Column(Integer, ForeignKey('restaurant_table.table_id', ondelete='CASCADE', onupdate='CASCADE'), nullable=False)
    total_cost = Column(DECIMAL(10,2), nullable=False)
    status_id = Column(Integer, ForeignKey('order_status.status_id', ondelete='CASCADE', onupdate='CASCADE'), nullable=False)
    visitor_passport = Column(String(10), ForeignKey('visitor.passport', ondelete='CASCADE', onupdate='CASCADE'), nullable=False)

    check = relationship("PaymentCheck", back_populates="orders")
    waiter = relationship("Waiter", back_populates="orders")
    table = relationship("RestaurantTable", back_populates="orders")
    status = relationship("OrderStatus", back_populates="orders")
    visitor = relationship("Visitor", back_populates="orders")
    dishes_in_orders = relationship("DishesInOrder", back_populates="order", cascade="all, delete-orphan")


# ==========================
#  БЛЮДА В ЗАКАЗЕ
# ==========================
class DishesInOrder(Base):
    __tablename__ = 'dishes_in_order'

    id = Column(Integer, primary_key=True, autoincrement=True)
    menu_item_id = Column(Integer, ForeignKey('menu_item.menu_item_id', ondelete='CASCADE', onupdate='CASCADE'), nullable=False)
    order_id = Column(Integer, ForeignKey('restaurant_order.order_id', ondelete='CASCADE', onupdate='CASCADE'), nullable=False)
    quantity = Column(Integer, nullable=False)

    menu_item = relationship("MenuItem", back_populates="dishes_in_orders")
    order = relationship("RestaurantOrder", back_populates="dishes_in_orders")
