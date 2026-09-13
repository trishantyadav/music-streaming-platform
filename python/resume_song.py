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
# BYTE-SAFE STRING FUNCTION
# -----------------------------
def truncate_oracle(value, max_bytes):
    if value is None:
        return None

    value = str(value)

    encoded = value.encode("utf-8")

    if len(encoded) <= max_bytes:
        return value

    # Remove characters until UTF-8 byte length <= limit
    while len(value.encode("utf-8")) > max_bytes:
        value = value[:-1]

    return value


# -----------------------------
# LOAD SONG CSV
# -----------------------------
file_path = r"C:\Music_Streaming_Project\data\songs.csv"

df = pd.read_csv(file_path)

df.columns = (
    df.columns
    .str.strip()
    .str.lower()
    .str.replace(" ", "_")
)

# -----------------------------
# RESUME FROM SONG 12001
# -----------------------------
df = df[df["song_id"] > 12000].copy()

print(f"Songs remaining: {len(df)}")
print(f"Starting Song ID: {df['song_id'].min()}")
print(f"Ending Song ID: {df['song_id'].max()}")

# -----------------------------
# CLEAN DURATION
# -----------------------------
df["duration"] = pd.to_numeric(
    df["duration"],
    errors="coerce"
)

valid_median = int(
    df.loc[df["duration"] > 0, "duration"].median()
)

df.loc[df["duration"] <= 0, "duration"] = valid_median

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

        title = truncate_oracle(
            row["title"],
            300
        )

        uri = truncate_oracle(
            row["spotify_track_uri"],
            200
        )

        records.append((
            int(row["song_id"]),
            int(row["album_id"]),
            title,
            float(row["duration"]),
            uri
        ))

    try:

        cursor.executemany(sql, records)
        conn.commit()

        print(
            f"Loaded Song IDs "
            f"{batch['song_id'].min()} "
            f"to {batch['song_id'].max()}"
        )

    except Exception as e:

        conn.rollback()

        print(
            f"\nERROR at Song IDs "
            f"{batch['song_id'].min()} "
            f"to {batch['song_id'].max()}"
        )

        print(e)
        break

cursor.close()
conn.close()

print("\nSONG resume loading finished.")