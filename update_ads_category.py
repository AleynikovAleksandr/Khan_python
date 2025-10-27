# file: update_ads_category.py

import sqlite3
import pandas as pd
import re
import joblib

def clean_text(text):
    """
    Очистка текста: приведение к нижнему регистру, удаление спецсимволов и ссылок
    """
    text = str(text).lower()
    text = re.sub(r"http\S+", " ", text)
    text = re.sub(r"[^а-яa-z0-9\s]", " ", text)
    text = re.sub(r"\s+", " ", text).strip()
    return text

def update_ads_with_predictions(db_path: str,
                                model_path: str,
                                label_encoder_path: str):
    """
    Обновляет таблицу Ads в базе SQLite, заполняя CategoryId и processed
    для объявлений, которые ещё не обработаны (Processed=0)
    
    :param db_path: путь к SQLite базе
    :param model_path: путь к сохранённой модели XGBClassifier
    :param label_encoder_path: путь к LabelEncoder
    """
    # Загружаем модель и энкодер
    pipe = joblib.load(model_path)
    le = joblib.load(label_encoder_path)

    # Подключаемся к базе
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    # Выбираем объявления с Processed=0
    df_ads = pd.read_sql_query("SELECT rowid, Text FROM Ads WHERE Processed=0;", conn)
    if df_ads.empty:
        print("Нет необработанных объявлений.")
        conn.close()
        return

    # Чистим текст
    df_ads["Text_clean"] = df_ads["Text"].apply(clean_text)

    # Делаем предсказание
    preds = pipe.predict(df_ads["Text_clean"])
    preds_category = le.inverse_transform(preds)

    # Получаем CategoryId для каждой предсказанной категории
    category_df = pd.read_sql_query("SELECT CategoryId, CategoryName FROM Categories;", conn)
    category_map = dict(zip(category_df["CategoryName"], category_df["CategoryId"]))
    df_ads["CategoryId"] = df_ads["Text_clean"].map(lambda x: None)  # по умолчанию
    df_ads["CategoryId"] = [category_map.get(cat) for cat in preds_category]

    # Обновляем таблицу Ads
    for _, row in df_ads.iterrows():
        cursor.execute("""
            UPDATE Ads
            SET CategoryId = ?, Processed = 1
            WHERE rowid = ?;
        """, (row["CategoryId"], row["rowid"]))

    conn.commit()
    conn.close()
    print(f"Обновлено {len(df_ads)} объявлений.")


if __name__ == "__main__":
    update_ads_with_predictions(
    db_path="/content/drive/My Drive/ads.db",
    model_path="/content/drive/My Drive/best_xgb_text_clf.pkl",
    label_encoder_path="/content/drive/My Drive/label_encoder.pkl"
)

