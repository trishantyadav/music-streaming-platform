import pandas as pd
import oracledb
from datetime import datetime
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
# LOAD ALBUM
# -----------------------------
file_path = r"C:\Music_Streaming_Project\data\albums.csv"

df = pd.read_csv(file_path)

print(f"Albums found in CSV: {len(df)}")

# Make sure column names match Oracle table
df.columns = [col.strip() for col in df.columns]

# Convert dates
df["Release_date"] = pd.to_datetime(
    df["Release_date"],
    errors="coerce"
)

# Replace NaN with None
df = df.where(pd.notnull(df), None)

sql = """
INSERT INTO ALBUM
(
    Album_id,
    Artist_id,
    Title,
    Release_date,
    Cover_art_url
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
            int(row["Album_id"]),
            int(row["Artist_id"]),
            str(row["Title"])[:300],
            row["Release_date"].to_pydatetime()
                if pd.notna(row["Release_date"])
                else None,
            str(row["Cover_art_url"])[:500]
                if row["Cover_art_url"] is not None
                else None
        ))

    try:
        cursor.executemany(sql, records)
        conn.commit()

        print(
            f"Loaded albums {start + 1} "
            f"to {start + len(batch)}"
        )

    except Exception as e:

        conn.rollback()

        print(
            f"\nERROR at albums "
            f"{start + 1} to {start + len(batch)}"
        )

        print(e)

        break

cursor.close()
conn.close()

print("\nALBUM loading finished.")