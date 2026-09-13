import os
from dotenv import load_dotenv


# Load variables from the project's .env file
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ENV_FILE = os.path.join(BASE_DIR, ".env")

load_dotenv(ENV_FILE)


ORACLE_USER = os.getenv("ORACLE_USER")
ORACLE_PASSWORD = os.getenv("ORACLE_PASSWORD")
ORACLE_DSN = os.getenv("ORACLE_DSN")


# Check that required variables exist
if not ORACLE_USER:
    raise ValueError("ORACLE_USER is missing from .env")

if not ORACLE_PASSWORD:
    raise ValueError("ORACLE_PASSWORD is missing from .env")

if not ORACLE_DSN:
    raise ValueError("ORACLE_DSN is missing from .env")