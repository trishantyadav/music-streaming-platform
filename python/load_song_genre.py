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
# CHECK CURRENT PROGRESS
# -----------------------------
cursor.execute("SELECT COUNT(*) FROM SONG_GENRE")
current_count = cursor.fetchone()[0]

print(f"SONG_GENRE rows already loaded: {current_count}")

# -----------------------------
# LOAD CSV
# -----------------------------
file_path = r"C:\Music_Streaming_Project\data\song_genre.csv"

df = pd.read_csv(file_path)

df.columns = (
    df.columns
    .str.strip()
    .str.lower()
    .str.replace(" ", "_")
)

print(f"Total records in CSV: {len(df)}")

# -----------------------------
# RESUME FROM CURRENT POSITION
# -----------------------------
df = df.iloc[current_count:].copy()

print(f"Records remaining: {len(df)}")

if len(df) == 0:
    print("SONG_GENRE is already completely loaded.")
    cursor.close()
    conn.close()
    exit()

print(
    f"Starting CSV record: {current_count + 1}"
)

print(
    f"Ending CSV record: {current_count + len(df)}"
)

# -----------------------------
# INSERT SQL
# -----------------------------
sql = """
INSERT INTO SONG_GENRE
(
    Song_id,
    Genre_id
)
VALUES
(
    :1,
    :2
)
"""

batch_size = 500

# -----------------------------
# LOAD IN BATCHES
# -----------------------------
for start in range(0, len(df), batch_size):

    batch = df.iloc[start:start + batch_size]

    records = [
        (
            int(row["song_id"]),
            int(row["genre_id"])
        )
        for _, row in batch.iterrows()
    ]

    try:

        cursor.executemany(sql, records)
        conn.commit()

        first_record = current_count + start + 1
        last_record = current_count + start + len(batch)

        print(
            f"Loaded records {first_record} to {last_record}"
        )

    except Exception as e:

        conn.rollback()

        first_record = current_count + start + 1
        last_record = current_count + start + len(batch)

        print(
            f"\nERROR at records "
            f"{first_record} to {last_record}"
        )

        print(e)
        break

cursor.close()
conn.close()

print("\nSONG_GENRE resume loading finished.")