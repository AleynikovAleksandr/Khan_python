import aiosqlite
from typing import Optional, List, Tuple
from pathlib import Path


class Database:
    def __init__(self, db_path: str | Path):
        self.path = str(db_path) if isinstance(db_path, Path) else db_path

    async def setup(self):
        async with aiosqlite.connect(self.path) as db:
            await db.execute("""
                CREATE TABLE IF NOT EXISTS users (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    tg_user_id INTEGER UNIQUE NOT NULL,
                    username TEXT,
                    first_name TEXT,
                    last_name TEXT,
                    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
                )
            """)
            await db.execute("""
                CREATE TABLE IF NOT EXISTS stickers (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    class_name TEXT NOT NULL UNIQUE,
                    filename TEXT NOT NULL,
                    file_hash TEXT,
                    added_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                    active BOOLEAN DEFAULT 1
                )
            """)
            await db.execute("""
                CREATE TABLE IF NOT EXISTS conversations (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    user_id INTEGER NOT NULL,
                    tg_user_id INTEGER NOT NULL,
                    sticker_id INTEGER,
                    user_message TEXT NOT NULL,
                    bot_response TEXT,
                    success BOOLEAN DEFAULT 1,
                    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY(user_id) REFERENCES users(id),
                    FOREIGN KEY(sticker_id) REFERENCES stickers(id)
                )
            """)
            await db.commit()

    async def get_or_create_user(self, tg_user_id: int, username: Optional[str] = None,
                               first_name: Optional[str] = None, last_name: Optional[str] = None) -> int:
        async with aiosqlite.connect(self.path) as db:
            async with db.execute("SELECT id FROM users WHERE tg_user_id = ?", (tg_user_id,)) as cur:
                row = await cur.fetchone()
                if row:
                    return row[0]

            await db.execute(
                """INSERT INTO users (tg_user_id, username, first_name, last_name)
                   VALUES (?, ?, ?, ?)""",
                (tg_user_id, username, first_name, last_name)
            )
            await db.commit()

            async with db.execute("SELECT last_insert_rowid()") as cur:
                return (await cur.fetchone())[0]

    async def save_conversation(self, user_id: int, tg_user_id: int, user_message: str,
                              bot_response: str = "", sticker_id: Optional[int] = None,
                              success: bool = True):
        async with aiosqlite.connect(self.path) as db:
            await db.execute(
                """INSERT INTO conversations
                   (user_id, tg_user_id, sticker_id, user_message, bot_response, success)
                   VALUES (?, ?, ?, ?, ?, ?)""",
                (user_id, tg_user_id, sticker_id, user_message, bot_response, int(success))
            )
            await db.commit()

    async def get_user_stats(self, tg_user_id: int) -> Tuple[int, int]:
        async with aiosqlite.connect(self.path) as db:
            async with db.execute(
                "SELECT COUNT(*), SUM(success) FROM conversations WHERE tg_user_id = ?",
                (tg_user_id,)
            ) as cur:
                row = await cur.fetchone()
                return row if row else (0, 0)

    async def sync_stickers(self, stickers_list: List[Tuple[str, str, str]]):
        async with aiosqlite.connect(self.path) as db:
            for class_name, filename, file_hash in stickers_list:
                async with db.execute(
                    "SELECT id FROM stickers WHERE class_name = ?",
                    (class_name,)
                ) as cur:
                    if await cur.fetchone():
                        await db.execute(
                            "UPDATE stickers SET filename = ?, file_hash = ?, active = 1 WHERE class_name = ?",
                            (filename, file_hash, class_name)
                        )
                    else:
                        await db.execute(
                            "INSERT INTO stickers (class_name, filename, file_hash) VALUES (?, ?, ?)",
                            (class_name, filename, file_hash)
                        )
            await db.commit()

    async def get_sticker_by_class(self, class_name: str) -> Optional[Tuple[int, str]]:
        async with aiosqlite.connect(self.path) as db:
            async with db.execute(
                "SELECT id, filename FROM stickers WHERE class_name = ? AND active = 1",
                (class_name,)
            ) as cur:
                return await cur.fetchone()