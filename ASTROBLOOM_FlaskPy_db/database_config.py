from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base


class DatabaseConfig:
    """
    Конфигурация подключения к базе данных MySQL через SQLAlchemy
    """

    # Строка подключения к БД
    SQLALCHEMY_DATABASE_URI = (
        "mysql+pymysql://dba:passw@127.0.0.1:3306/AleynikovAD_db2"
    )

    # Создаём движок SQLAlchemy
    engine = create_engine(
        SQLALCHEMY_DATABASE_URI,
        echo=True,              # показывает SQL в консоли (можешь выключить)
        future=True
    )

    # Сессии для запросов
    SessionLocal = sessionmaker(bind=engine)

    # Базовый класс для моделей
    Base = declarative_base()
