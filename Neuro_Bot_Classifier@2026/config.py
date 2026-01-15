from pathlib import Path

# Точная папка проекта, как ты указал
BASE_DIR = Path("/Users/alex/Documents/GitHub/Khan_python/Neuro_Bot_Classifier@2026")

# Все важные пути относительно BASE_DIR
PATHS = {
    "model":        BASE_DIR / "model_25" / "text_classifier (1).joblib",
    "stickers_dir": BASE_DIR / "stickers",
    "database":     BASE_DIR / "Bot_Classifier.db",
    "log_file":     BASE_DIR / "bot_classifier.log",
}

SETTINGS = {
    "max_message_length": 1200,
    "stanza_language": "ru",
    "telegram_token_env_var": "TELEGRAM_TOKEN",
}

def validate_paths():
    errors = []
    if not PATHS["model"].is_file():
        errors.append(f"Модель не найдена: {PATHS['model']}")
    if not PATHS["stickers_dir"].is_dir():
        errors.append(f"Папка со стикерами отсутствует: {PATHS['stickers_dir']}")
    
    if errors:
        raise RuntimeError("Ошибка конфигурации проекта:\n" + "\n".join(errors))