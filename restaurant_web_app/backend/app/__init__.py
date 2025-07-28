from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from .config import Config

db = SQLAlchemy()
login_manager = LoginManager()

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    db.init_app(app)
    login_manager.init_app(app)
    login_manager.login_view = "login"  # можно указать маршрут авторизации

    from app.models.visitor import Visitor
    from app.models.waiter import Waiter

    @login_manager.user_loader
    def load_user(user_id):
        # Сначала пробуем найти официанта
        user = Waiter.query.filter_by(login=user_id).first()
        if user:
            return user
        # Если не нашли — ищем среди гостей
        return Visitor.query.filter_by(login=user_id).first()

    from app.routes.auth import auth_bp
    app.register_blueprint(auth_bp)

    return app
