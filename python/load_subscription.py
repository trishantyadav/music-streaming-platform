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
file_path = r"C:\Music_Streaming_Project\data\subscriptions.csv"

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

print(f"Subscriptions found: {len(df)}")

# -----------------------------
# CLEAN DATA
# -----------------------------
df = df.where(pd.notnull(df), None)

df["start_date"] = pd.to_datetime(
    df["start_date"],
    errors="coerce"
)

df["end_date"] = pd.to_datetime(
    df["end_date"],
    errors="coerce"
)

# -----------------------------
# INSERT SQL
# -----------------------------
sql = """
INSERT INTO SUBSCRIPTION
(
    Subscription_id,
    User_id,
    Plan_type,
    Start_date,
    End_date
)
VALUES
(
    :1, :2, :3, :4, :5
)
"""

records = []

for _, row in df.iterrows():

    records.append((
        int(row["subscription_id"]),
        int(row["user_id"]),
        str(row["plan_type"]),
        row["start_date"].to_pydatetime()
        if pd.notna(row["start_date"])
        else None,
        row["end_date"].to_pydatetime()
        if pd.notna(row["end_date"])
        else None
    ))

# -----------------------------
# LOAD
# -----------------------------
batch_size = 500

for start in range(0, len(records), batch_size):

    batch = records[start:start + batch_size]

    try:

        cursor.executemany(sql, batch)
        conn.commit()

        print(
            f"Loaded subscriptions "
            f"{start + 1} to {start + len(batch)}"
        )

    except Exception as e:

        conn.rollback()

        print(
            f"\nERROR at subscriptions "
            f"{start + 1} to {start + len(batch)}"
        )

        print(e)
        break

cursor.close()
conn.close()

print("\nSUBSCRIPTION loading finished.")