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
file_path = r"C:\Music_Streaming_Project\data\payments.csv"

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

print(f"Payments found: {len(df)}")

# -----------------------------
# CLEAN DATA
# -----------------------------
df = df.where(pd.notnull(df), None)

df["payment_date"] = pd.to_datetime(
    df["payment_date"],
    errors="coerce"
)

df["amount"] = pd.to_numeric(
    df["amount"],
    errors="coerce"
)

# -----------------------------
# INSERT SQL
# -----------------------------
sql = """
INSERT INTO PAYMENT
(
    Payment_id,
    Subscription_id,
    Payment_date,
    Payment_method,
    Amount,
    Status
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
            int(row["payment_id"]),
            int(row["subscription_id"]),
            row["payment_date"].to_pydatetime()
            if pd.notna(row["payment_date"])
            else None,
            str(row["payment_method"])[:30],
            float(row["amount"]),
            str(row["status"])[:20]
        ))

    try:

        cursor.executemany(sql, records)
        conn.commit()

        print(
            f"Loaded payments "
            f"{start + 1} to {start + len(batch)}"
        )

    except Exception as e:

        conn.rollback()

        print(
            f"\nERROR at payments "
            f"{start + 1} to {start + len(batch)}"
        )

        print(e)
        break

cursor.close()
conn.close()

print("\nPAYMENT loading finished.")
