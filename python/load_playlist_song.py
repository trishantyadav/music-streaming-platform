import pandas as pd
import oracledb
from db_config import ORACLE_USER, ORACLE_PASSWORD, ORACLE_DSN
# -----------------------------
# ORACLE CONNECTION
# -----------------------------
conn = oracledb.connect(
    user=ORACLE_USER,
    password=ORACLE_PASSWORD,
    dsn=ORACLE_DSN
)

cursor = conn.cursor()

print("Connected to Oracle successfully.")

# -----------------------------
# LOAD CSV
# -----------------------------
file_path = r"C:\Music_Streaming_Project\data\playlist_song.csv"

df = pd.read_csv(file_path)

# Normalize column names
df.columns = (
    df.columns
    .str.strip()
    .str.lower()
    .str.replace(" ", "_")
)

print("CSV columns:")
print(df.columns.tolist())

print(f"Playlist-Song records found: {len(df)}")

# -----------------------------
# CHECK REQUIRED COLUMNS
# -----------------------------
required = ["playlist_id", "song_id"]

for col in required:
    if col not in df.columns:
        raise Exception(f"Required column missing: {col}")

# -----------------------------
# CLEAN DATA
# -----------------------------
df = df.where(pd.notnull(df), None)

# -----------------------------
# INSERT SQL
# -----------------------------
sql = """
INSERT INTO PLAYLIST_SONG
(
    Playlist_id,
    Song_id
)
VALUES
(
    :1,
    :2
)
"""

batch_size = 500

for start in range(0, len(df), batch_size):

    batch = df.iloc[start:start + batch_size]

    records = [
        (
            int(row["playlist_id"]),
            int(row["song_id"])
        )
        for _, row in batch.iterrows()
    ]

    try:

        cursor.executemany(sql, records)
        conn.commit()

        print(
            f"Loaded records "
            f"{start + 1} to {start + len(batch)}"
        )

    except Exception as e:

        conn.rollback()

        print(
            f"\nERROR at records "
            f"{start + 1} to {start + len(batch)}"
        )

        print(e)
        break

cursor.close()
conn.close()

print("\nPLAYLIST_SONG loading finished.")