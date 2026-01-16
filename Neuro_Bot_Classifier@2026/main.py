import os
import logging
from logging.handlers import RotatingFileHandler
import asyncio
import hashlib
import re

from dotenv import load_dotenv
import joblib
import stanza
from telegram import Update, InlineKeyboardButton, InlineKeyboardMarkup
from telegram.ext import (
    ApplicationBuilder,
    CommandHandler,
    MessageHandler,
    filters,
    ContextTypes,
    CallbackQueryHandler,
)
import aiosqlite
from db import Database
from config import PATHS, SETTINGS, validate_paths

load_dotenv()

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

formatter = logging.Formatter('%(asctime)s [%(levelname)s] %(name)s: %(message)s')

file_handler = RotatingFileHandler(
    PATHS["log_file"],
    maxBytes=5 * 1024 * 1024,
    backupCount=4,
    encoding='utf-8'
)
file_handler.setFormatter(formatter)
logger.addHandler(file_handler)

console_handler = logging.StreamHandler()
console_handler.setFormatter(formatter)
logger.addHandler(console_handler)

logger.info("Инициализация Stanza... (может занять некоторое время)")
stanza.download(SETTINGS["stanza_language"], logging_level='ERROR')
nlp = stanza.Pipeline(
    lang=SETTINGS["stanza_language"],
    processors='tokenize,lemma',
    logging_level='ERROR',
    verbose=False
)
logger.info("Stanza готова к работе.")

def lemmatize_text_stanza(texts):
    lemmatized_texts = []
    for text in texts:
        text = re.sub(r'[^а-яА-Я\s]', '', text)
        doc = nlp(text)
        lemmas = [word.lemma for sent in doc.sentences for word in sent.words]
        lemmatized_texts.append(' '.join(lemmas))
    return lemmatized_texts

def clean_and_lemmatize(text: str) -> str:
    text = re.sub(r'https?://\S+|www\.\S+', '', text)
    text = re.sub(r'[^а-яА-ЯёЁ\s-]', '', text)
    text = re.sub(r'\s+', ' ', text).strip()
    if not text:
        return ""
    doc = nlp(text)
    lemmas = [w.lemma.lower() for sent in doc.sentences for w in sent.words if w.lemma]
    return ' '.join(lemmas)


class StickerBot:
    def __init__(self, token: str):
        if not token:
            raise RuntimeError("TELEGRAM_TOKEN не найден")

        self.token = token
        self.db = Database(PATHS["database"])

        logger.info("Загрузка модели классификации...")
        try:
            self.model = joblib.load(PATHS["model"])
            logger.info("Модель успешно загружена")
        except Exception as e:
            logger.critical(f"Ошибка загрузки модели: {e}")
            raise

        self.application = ApplicationBuilder().token(self.token).build()

        self.application.add_handler(CommandHandler("start", self.cmd_start))
        self.application.add_handler(CommandHandler("history", self.cmd_history))
        self.application.add_handler(CommandHandler("help", self.cmd_help))
        self.application.add_handler(CallbackQueryHandler(self.on_help_buttons))
        self.application.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, self.handle_message))

    async def _send_text(self, update: Update, context: ContextTypes.DEFAULT_TYPE, text: str, reply_markup=None):
        if getattr(update, "message", None):
            await update.message.reply_text(text, reply_markup=reply_markup)
            return
        query = getattr(update, "callback_query", None)
        if query and getattr(query, "message", None):
            await query.message.reply_text(text, reply_markup=reply_markup)
            return
        chat = getattr(update, "effective_chat", None)
        if chat:
            await context.bot.send_message(chat_id=chat.id, text=text, reply_markup=reply_markup)
            return
        user = getattr(update, "effective_user", None)
        if user:
            await context.bot.send_message(chat_id=user.id, text=text, reply_markup=reply_markup)
            return
        logger.warning("Не удалось о��править сообщение: нет доступного чата/пользователя в update")

    async def cmd_start(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        user = update.effective_user

        has_history = await self.db.has_any_conversations(user.id)

        await self._send_text(update, context, "Привет! Пиши любой текст — я постараюсь ответить картинкой 🎉")

        uid = await self.db.get_or_create_user(
            tg_user_id=user.id,
            username=user.username,
            first_name=user.first_name,
            last_name=user.last_name
        )

        await self.db.save_conversation(
            user_id=uid,
            tg_user_id=user.id,
            user_message="/start",
            bot_response="GREETING",
            success=True
        )

        if not has_history:
            await self.cmd_help(update, context)

        logger.info(f"START | @{user.username or 'no_username'} ({user.id})")

    async def cmd_history(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        user = update.effective_user
        async with aiosqlite.connect(self.db.path) as db:
            async with db.execute(
                "SELECT user_message, bot_response, timestamp FROM conversations WHERE tg_user_id=? ORDER BY timestamp ASC",
                (user.id,)
            ) as cur:
                rows = await cur.fetchall()

        if not rows:
            await self._send_text(update, context, "История диалогов пустая.")
            return

        history_text = ""
        for umsg, bmsg, ts in rows:
            history_text += f"[{ts}] Ты: {umsg}\nБот: {bmsg}\n\n"

        for i in range(0, len(history_text), 4000):
            await self._send_text(update, context, history_text[i:i+4000])

    async def cmd_help(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        text = (
            "Доступные команды:\n\n"
            "/start — запуск бота\n"
            "/help — справка по командам\n"
            "/history — история переписки\n\n"
            "Просто отправь сообщение, и бот подберёт подходящую картинку."
        )

        keyboard = [
            [InlineKeyboardButton("▶️ Start", callback_data="cmd_start")],
            [InlineKeyboardButton("📜 History", callback_data="cmd_history")],
        ]
        reply_markup = InlineKeyboardMarkup(keyboard)

        await self._send_text(update, context, text, reply_markup=reply_markup)

    async def on_help_buttons(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        query = update.callback_query
        if query:
            await query.answer()

        if not query:
            return

        if query.data == "cmd_start":
            await self.cmd_start(update, context)
        elif query.data == "cmd_history":
            await self.cmd_history(update, context)

    async def handle_message(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        user = update.effective_user
        raw_text = (update.message.text or "").strip()

        if not raw_text or len(raw_text) > SETTINGS["max_message_length"]:
            await update.message.reply_text("Сообщение слишком длинное или пустое")
            return

        processed_text = clean_and_lemmatize(raw_text)
        if not processed_text:
            await update.message.reply_text("После очистки текста ничего не осталось...")
            return

        uid = await self.db.get_or_create_user(
            user.id, user.username, user.first_name, user.last_name
        )

        try:
            label_str = str(self.model.predict([processed_text])[0]).strip()
            sticker_info = await self.db.get_sticker_by_class(label_str)

            success = False
            sticker_id = None
            bot_response_text = ""

            if sticker_info:
                sid, filename = sticker_info
                sticker_path = PATHS["stickers_dir"] / filename

                if sticker_path.is_file():
                    with open(sticker_path, "rb") as f:
                        await update.message.reply_photo(
                            photo=f,
                            caption=f"Класс: {label_str}"
                        )
                    success = True
                    sticker_id = sid
                    bot_response_text = f"Отправлен стикер класса: {label_str}"
                else:
                    bot_response_text = f"Класс: {label_str}\n\n(файл не найден)"
                    await update.message.reply_text(bot_response_text)
            else:
                bot_response_text = f"Класс: {label_str}\n\n(нет такого стикера в базе)"
                await update.message.reply_text(bot_response_text)

            await self.db.save_conversation(
                user_id=uid,
                tg_user_id=user.id,
                user_message=raw_text,
                bot_response=bot_response_text,
                sticker_id=sticker_id,
                success=success
            )

            logger.info(
                f"MSG | @{user.username or 'no_username'} | "
                f"raw: {raw_text[:70]}... | "
                f"clean: {processed_text[:60]}... | "
                f"class: {label_str} | ok: {success}"
            )

        except Exception:
            logger.exception("Ошибка обработки сообщения")
            await update.message.reply_text("Внутренняя ошибка... Попробуй позже")

    async def sync_stickers(self):
        items = []
        for file in PATHS["stickers_dir"].glob("*.png"):
            if file.is_file():
                with open(file, "rb") as f:
                    file_hash = hashlib.sha256(f.read()).hexdigest()
                items.append((file.stem, file.name, file_hash))

        if items:
            await self.db.sync_stickers(items)
            logger.info(f"Синхронизировано стикеров: {len(items)}")
        else:
            logger.warning("В папке stickers не найдено .png файлов!")

    def run(self):
        asyncio.run(self.db.setup())
        asyncio.run(self.sync_stickers())

        logger.info(f"Бот запущен • База данных: {PATHS['database']}")

        created_loop = False
        try:
            loop = asyncio.get_running_loop()
        except RuntimeError:
            loop = asyncio.new_event_loop()
            asyncio.set_event_loop(loop)
            created_loop = True

        try:
            self.application.run_polling(drop_pending_updates=True)
        except KeyboardInterrupt:
            logger.info("Остановка бота (KeyboardInterrupt).")
        except Exception:
            logger.exception("Ошибка при запуске polling.")
        finally:
            if created_loop:
                try:
                    loop.stop()
                except Exception:
                    pass
                try:
                    loop.close()
                except Exception:
                    pass


if __name__ == "__main__":
    token = os.getenv("TELEGRAM_TOKEN")
    if not token:
        logger.critical(
            "TELEGRAM_TOKEN не найден ни в .env, ни в переменных окружения!"
        )
        exit(1)

    validate_paths()

    bot = StickerBot(token)

    bot.run()