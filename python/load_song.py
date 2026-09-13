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
file_path = r"C:\Music_Streaming_Project\data\songs.csv"

df = pd.read_csv(file_path)

print(f"Songs found in CSV: {len(df)}")

# -----------------------------
# NORMALIZE COLUMN NAMES
# -----------------------------
df.columns = (
    df.columns
    .str.strip()
    .str.lower()
    .str.replace(" ", "_")
)

print("CSV columns:")
print(df.columns.tolist())

# -----------------------------
# CHECK REQUIRED COLUMNS
# -----------------------------
required = ["song_id", "album_id", "title", "duration"]

for col in required:
    if col not in df.columns:
        raise Exception(f"Required column missing: {col}")

# Spotify URI is optional
if "spotify_track_uri" not in df.columns:
    print("WARNING: spotify_track_uri not found.")
    print("Spotify_track_uri will be stored as NULL.")
    df["spotify_track_uri"] = None

# -----------------------------
# CLEAN DATA
# -----------------------------
df = df.where(pd.notnull(df), None)

# -----------------------------
# INSERT SQL
# -----------------------------
sql = """
INSERT INTO SONG
(
    Song_id,
    Album_id,
    Title,
    Duration,
    Spotify_track_uri
)
VALUES
(
    :1, :2, :3, :4, :5
)
"""

batch_size = 500

# -----------------------------
# LOAD IN BATCHES
# -----------------------------
for start in range(0, len(df), batch_size):

    batch = df.iloc[start:start + batch_size]

    records = []

    for _, row in batch.iterrows():

        uri = row["spotify_track_uri"]

        records.append((
            int(row["song_id"]),
            int(row["album_id"]),
            str(row["title"])[:300],
            float(row["duration"]),
            str(uri)[:200] if uri is not None else None
        ))

    try:

        cursor.executemany(sql, records)
        conn.commit()

        print(
            f"Loaded songs {start + 1} "
            f"to {start + len(batch)}"
        )

    except Exception as e:

        conn.rollback()

        print(
            f"\nERROR at songs "
            f"{start + 1} to {start + len(batch)}"
        )

        print(e)
        break

cursor.close()
conn.close()

print("\nSONG loading finished.")