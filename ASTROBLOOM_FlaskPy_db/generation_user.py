from sqlalchemy import Column, String
from sqlalchemy.orm import declarative_base, sessionmaker
from sqlalchemy.exc import IntegrityError
from database_config import DatabaseConfig
from faker import Faker

# ===========================
# Настройка базы
# ===========================
Base = declarative_base()
engine = DatabaseConfig().engine
Session = sessionmaker(bind=engine)
session = Session()
fake = Faker('ru_RU')  # русские имена и адреса

# ===========================
# Модель Visitor
# ===========================
class Visitor(Base):
    __tablename__ = "visitor"

    passport = Column(String(10), primary_key=True)
    last_name = Column(String(50), nullable=False)
    first_name = Column(String(50), nullable=False)
    middle_name = Column(String(50))
    bank_card = Column(String(20), nullable=False)
    login = Column(String(50), nullable=False, unique=True)
    user_password = Column(String(255), nullable=False)

# ===========================
# Модель Waiter
# ===========================
class Waiter(Base):
    __tablename__ = "waiter"

    login = Column(String(50), primary_key=True)
    last_name = Column(String(50), nullable=False)
    first_name = Column(String(50), nullable=False)
    middle_name = Column(String(50))
    user_password = Column(String(255), nullable=False)

# ===========================
# Создание таблиц
# ===========================
Base.metadata.create_all(engine)

# ===========================
# Генерация данных с Faker
# ===========================
def generate_visitors(n=40):
    visitors = []
    for _ in range(n):
        visitor = Visitor(
            passport=fake.unique.random_number(digits=10, fix_len=True),
            last_name=fake.last_name(),
            first_name=fake.first_name(),
            middle_name=fake.middle_name(),
            bank_card=fake.credit_card_number(card_type='mastercard'),
            login=fake.unique.user_name(),
            user_password=fake.password(length=10)
        )
        visitors.append(visitor)
    return visitors

def generate_waiters(n=40):
    waiters = []
    for _ in range(n):
        waiter = Waiter(
            login=fake.unique.user_name(),
            last_name=fake.last_name(),
            first_name=fake.first_name(),
            middle_name=fake.middle_name(),
            user_password=fake.password(length=10)
        )
        waiters.append(waiter)
    return waiters

# ===========================
# Сохранение в базу
# ===========================
def seed_data():
    visitors = generate_visitors()
    waiters = generate_waiters()

    for v in visitors:
        try:
            session.add(v)
            session.commit()
        except IntegrityError:
            session.rollback()

    for w in waiters:
        try:
            session.add(w)
            session.commit()
        except IntegrityError:
            session.rollback()

    # ===========================
    # Вывод всех записей
    # ===========================
    print("Все посетители:")
    for v in session.query(Visitor).all():
        print(f"{v.passport} | {v.last_name} {v.first_name} {v.middle_name} | {v.bank_card} | {v.login}")

    print("\nВсе официанты:")
    for w in session.query(Waiter).all():
        print(f"{w.login} | {w.last_name} {w.first_name} {w.middle_name} | {w.user_password}")

if __name__ == "__main__":
    seed_data()
    print("\nДанные успешно сгенерированы и выведены.")
