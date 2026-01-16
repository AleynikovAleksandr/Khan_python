# `Neuro_Bot_Classifier` installation instructions

# Project Setup

## Checking project paths

Make sure the project structure matches the settings in `config.py`:

```bash
from pathlib import Path

# Exact project folder
BASE_DIR = Path("/Users/alex/Documents/GitHub/Khan_python/Neuro_Bot_Classifier@2026")

PATHS = {
    "model":        BASE_DIR / "model_25" / "text_classifier (1).joblib",
    "stickers_dir": BASE_DIR / "stickers",
    "database":     BASE_DIR / "Bot_Classifier.db",
    "log_file":     BASE_DIR / "bot_classifier.log",
}
```
* `model_25/text_classifier (1).joblib`— model file

* `stickers/ `— folder with PNG stickers

* `Bot_Classifier.db` — database (if not present, will be created by the bot upon startup)

* `bot_classifier.log` — log file

## Configuring .env with the Telegram token
Create a .env file in the root of the project (Neuro_Bot_Classifier@2026) with the following contents:
```bash
# .env
TELEGRAM_TOKEN=your_bot_token_from_@BotFather
```
### Notes:

* Don't use quotes around the token.

* The `.env` file isn't committable in Git (add `.env` to `.gitignore`).

* Python will automatically load variables from `.env` via `python-dotenv`.


### 1. Create and activate a virtual environment:
* On macOS/Linux:

    ```bash
       python3.11 -m venv .venv
       source .venv/bin/activate
    ```
* On Windows:
    
    ```bash
       python -m venv .venv
       .venv\Scripts\activate
    ```

required version of the interpreter  `3.11` 
### 2. Install dependencies:

```bash
pip install --upgrade pip
pip install -r requirements.txt
   ```

### 3. Run the Bot:

```bash
python3 main.py
```
