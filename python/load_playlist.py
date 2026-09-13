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
# LOAD PLAYLIST CSV
# -----------------------------
file_path = r"C:\Music_Streaming_Project\data\playlists.csv"

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

print(f"Playlists found: {len(df)}")

# -----------------------------
# CLEAN DATA
# -----------------------------
df = df.where(pd.notnull(df), None)

# Convert date
df["created_date"] = pd.to_datetime(
    df["created_date"],
    errors="coerce"
)

# -----------------------------
# INSERT SQL
# -----------------------------
sql = """
INSERT INTO PLAYLIST
(
    Playlist_id,
    User_id,
    Name,
    Created_date,
    Is_public
)
VALUES
(
    :1, :2, :3, :4, :5
)
"""

records = []

for _, row in df.iterrows():

    records.append((
        int(row["playlist_id"]),
        int(row["user_id"]),
        str(row["name"])[:150],
        row["created_date"].to_pydatetime()
        if pd.notna(row["created_date"])
        else None,
        int(row["is_public"])
    ))

# -----------------------------
# INSERT IN BATCHES
# -----------------------------
batch_size = 500

for start in range(0, len(records), batch_size):

    batch = records[start:start + batch_size]

    try:

        cursor.executemany(sql, batch)
        conn.commit()

        print(
            f"Loaded playlists "
            f"{start + 1} to {start + len(batch)}"
        )

    except Exception as e:

        conn.rollback()

        print(
            f"ERROR at playlists "
            f"{start + 1} to {start + len(batch)}"
        )

        print(e)
        break

cursor.close()
conn.close()

print("\nPLAYLIST loading finished.")