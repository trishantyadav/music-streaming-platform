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
file_path = r"C:\Music_Streaming_Project\data\ratings.csv"

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

print(f"Ratings found: {len(df)}")

# -----------------------------
# CLEAN DATA
# -----------------------------
df = df.where(pd.notnull(df), None)

df["rating"] = pd.to_numeric(
    df["rating"],
    errors="coerce"
)

df["rated_at"] = pd.to_datetime(
    df["rated_at"],
    errors="coerce"
)

# -----------------------------
# INSERT SQL
# -----------------------------
sql = """
INSERT INTO RATING
(
    Rating_id,
    User_id,
    Song_id,
    Rating,
    Review_text,
    Rated_at
)
VALUES
(
    :1, :2, :3, :4, :5, :6
)
"""

batch_size = 500

for start in range(0, len(df), batch_size):

    batch = df.iloc[start:start + batch_size]

    records = []

    for _, row in batch.iterrows():

        records.append((
            int(row["rating_id"]),
            int(row["user_id"]),
            int(row["song_id"]),
            int(row["rating"]),
            str(row["review_text"])[:500]
            if row["review_text"] is not None
            else None,
            row["rated_at"].to_pydatetime()
            if pd.notna(row["rated_at"])
            else None
        ))

    try:

        cursor.executemany(sql, records)
        conn.commit()

        print(
            f"Loaded ratings "
            f"{start + 1} to {start + len(batch)}"
        )

    except Exception as e:

        conn.rollback()

        print(
            f"\nERROR at ratings "
            f"{start + 1} to {start + len(batch)}"
        )

        print(e)
        break

cursor.close()
conn.close()

print("\nRATING loading finished.")