from sqlalchemy import Column, Integer, String, ForeignKey, CheckConstraint
from sqlalchemy.orm import relationship
from database_config import DatabaseConfig
from faker import Faker
from sqlalchemy.exc import IntegrityError

Base = DatabaseConfig.Base
session = DatabaseConfig.SessionLocal()
fake = Faker()

class ZoneType(Base):
    __tablename__ = 'zone_type'
    
    zone_type_id = Column(Integer, primary_key=True, autoincrement=True)
    zone_type = Column(String(50), nullable=False)
    
    tables = relationship('RestaurantTable', back_populates='zone')

class RestaurantTable(Base):
    __tablename__ = 'restaurant_table'
    
    table_id = Column(Integer, primary_key=True, autoincrement=True)
    zone_type_id = Column(Integer, ForeignKey('zone_type.zone_type_id', ondelete='CASCADE', onupdate='CASCADE'), nullable=False)
    table_label = Column(String(50), nullable=False)
    seat_count = Column(Integer, nullable=False)
    
    __table_args__ = (
        CheckConstraint('seat_count >= 0', name='check_seat_count_positive'),
    )
    
    zone = relationship('ZoneType', back_populates='tables')

# ===========================
# Создание типов зон
# ===========================
zone_names = [
    'VIP', 
    'Курящая зона', 
    'Некурящая зона', 
    'На улице', 
    'Семейная', 
    'Романтическая', 
    'Детская', 
    'Бизнес-зал', 
    'Барная зона', 
    'Зал для мероприятий'
]

zone_objects = []

for name in zone_names:
    zone = ZoneType(zone_type=name)
    session.add(zone)
    zone_objects.append(zone)

try:
    session.commit()
except IntegrityError:
    session.rollback()

# ===========================
# Создание столов
# ===========================
for _ in range(40):
    table = RestaurantTable(
        zone_type_id=fake.random_element(elements=zone_objects).zone_type_id,
        table_label=f"T{fake.random_int(min=1, max=100)}",
        seat_count=fake.random_int(min=1, max=8)
    )
    session.add(table)

try:
    session.commit()
    print("Данные для zone_type и restaurant_table успешно добавлены!")
except IntegrityError:
    session.rollback()
    print("Произошла ошибка при добавлении столов.")

# ===========================
# Вывод всех данных
# ===========================
print("\n=== Список типов зон ===")
for zone in session.query(ZoneType).all():
    print(f"{zone.zone_type_id}: {zone.zone_type}")

print("\n=== Список столов ===")
for table in session.query(RestaurantTable).all():
    print(f"{table.table_id}: {table.table_label}, Зона: {table.zone.zone_type}, Мест: {table.seat_count}")

# Закрываем сессию
session.close()
