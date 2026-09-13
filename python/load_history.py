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
file_path = r"C:\Music_Streaming_Project\data\listening_history.csv"

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

print(f"Listening records found: {len(df)}")

# -----------------------------
# CLEAN DATA
# -----------------------------
df = df.where(pd.notnull(df), None)

df["played_at"] = pd.to_datetime(
    df["played_at"],
    errors="coerce"
)

df["duration_played"] = pd.to_numeric(
    df["duration_played"],
    errors="coerce"
)

# Invalid durations → 0
df.loc[df["duration_played"] < 0, "duration_played"] = 0

# -----------------------------
# INSERT SQL
# -----------------------------
sql = """
INSERT INTO LISTENING_HISTORY
(
    Song_id,
    History_id,
    User_id,
    Played_at,
    Duration_played
)
VALUES
(
    :1, :2, :3, :4, :5
)
"""

batch_size = 500

for start in range(0, len(df), batch_size):

    batch = df.iloc[start:start + batch_size]

    records = []

    for _, row in batch.iterrows():

        records.append((
            int(row["song_id"]),
            int(row["history_id"]),
            int(row["user_id"]),
            row["played_at"].to_pydatetime()
            if pd.notna(row["played_at"])
            else None,
            float(row["duration_played"])
        ))

    try:

        cursor.executemany(sql, records)
        conn.commit()

        print(
            f"Loaded history "
            f"{start + 1} to {start + len(batch)}"
        )

    except Exception as e:

        conn.rollback()

        print(
            f"\nERROR at history "
            f"{start + 1} to {start + len(batch)}"
        )

        print(e)
        break

cursor.close()
conn.close()

print("\nLISTENING_HISTORY loading finished.")