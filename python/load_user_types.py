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
# FUNCTION TO LOAD TABLE
# -----------------------------
def load_table(csv_file, table_name, columns, numeric_columns, sql):

    path = rf"C:\Music_Streaming_Project\data\{csv_file}"

    df = pd.read_csv(path)

    df.columns = (
        df.columns
        .str.strip()
        .str.lower()
        .str.replace(" ", "_")
    )

    print(f"\n{table_name}")
    print(f"Records found: {len(df)}")

    df = df.where(pd.notnull(df), None)

    records = []

    for _, row in df.iterrows():

        values = []

        for col in columns:

            value = row[col]

            if value is not None and col in numeric_columns:
                value = int(value)

            values.append(value)

        records.append(tuple(values))

    try:

        cursor.executemany(sql, records)
        conn.commit()

        print(
            f"{table_name} loaded successfully: "
            f"{len(records)} rows"
        )

    except Exception as e:

        conn.rollback()

        print(f"ERROR loading {table_name}:")
        print(e)


# -----------------------------
# PREMIUM USER
# -----------------------------
load_table(
    "premium_user.csv",
    "PREMIUM_USER",

    [
        "user_id",
        "offline_downloads",
        "audio_quality",
        "ad_free"
    ],

    [
        "user_id",
        "offline_downloads",
        "ad_free"
    ],

    """
    INSERT INTO PREMIUM_USER
    (
        User_id,
        Offline_downloads,
        Audio_quality,
        Ad_free
    )
    VALUES
    (
        :1, :2, :3, :4
    )
    """
)


# -----------------------------
# FREE USER
# -----------------------------
load_table(
    "free_user.csv",
    "FREE_USER",

    [
        "user_id",
        "skip_limit_per_hr",
        "ads_enabled"
    ],

    [
        "user_id",
        "skip_limit_per_hr",
        "ads_enabled"
    ],

    """
    INSERT INTO FREE_USER
    (
        User_id,
        Skip_limit_per_hr,
        Ads_enabled
    )
    VALUES
    (
        :1, :2, :3
    )
    """
)


cursor.close()
conn.close()

print("\nUSER TYPE LOADING FINISHED.")