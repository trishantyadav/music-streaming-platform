import os
import pandas as pd
import oracledb

from db_config import ORACLE_USER, ORACLE_PASSWORD, ORACLE_DSN


# ============================================================
# CONFIGURATION
# ============================================================

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA_DIR = os.path.join(BASE_DIR, "data")


BATCH_SIZE = 500


# ============================================================
# DATABASE CONNECTION
# ============================================================

def get_connection():
    try:
        conn = oracledb.connect(
            user=ORACLE_USER,
            password=ORACLE_PASSWORD,
            dsn=ORACLE_DSN
        )

        print("\nOracle connection successful.")
        return conn

    except Exception as e:
        print("\nERROR: Could not connect to Oracle.")
        print(e)
        raise


# ============================================================
# NORMALIZE COLUMN NAMES
# ============================================================

def normalize_columns(df):
    df.columns = (
        df.columns
        .str.strip()
        .str.lower()
        .str.replace(" ", "_")
    )

    return df


# ============================================================
# LOAD USERS
# ============================================================

def load_users(conn):

    file_path = os.path.join(DATA_DIR, "users.csv")

    if not os.path.exists(file_path):
        raise FileNotFoundError(f"File not found: {file_path}")

    print("\n========================================")
    print("LOADING USERS")
    print("========================================")

    df = pd.read_csv(file_path)
    df = normalize_columns(df)

    print("CSV columns:", list(df.columns))
    print("CSV rows:", len(df))

    # Required columns
    required = [
        "user_id",
        "name",
        "email",
        "password",
        "signup_date",
        "country"
    ]

    for col in required:
        if col not in df.columns:
            raise ValueError(f"Missing column in users.csv: {col}")

    cursor = conn.cursor()

    sql = """
        INSERT INTO USERS
        (
            User_id,
            Name,
            Email,
            Password,
            Signup_date,
            Country
        )
        VALUES
        (
            :1, :2, :3, :4, :5, :6
        )
    """

    inserted = 0
    skipped = 0

    for start in range(0, len(df), BATCH_SIZE):

        batch = df.iloc[start:start + BATCH_SIZE]

        rows = []

        for _, row in batch.iterrows():

            try:

                rows.append((
                    int(row["user_id"]),
                    str(row["name"])[:150],
                    str(row["email"])[:150],
                    str(row["password"])[:100],
                    pd.to_datetime(row["signup_date"]).to_pydatetime(),
                    str(row["country"])[:100]
                ))

            except Exception as e:

                skipped += 1

                print(
                    f"Skipping USERS row "
                    f"{start + skipped}: {e}"
                )

        if rows:

            try:
                cursor.executemany(sql, rows)
                conn.commit()

                inserted += len(rows)

                print(
                    f"Users loaded: "
                    f"{inserted}/{len(df)}"
                )

            except oracledb.IntegrityError as e:

                conn.rollback()

                print("\nWARNING: Duplicate or invalid USER record.")
                print("The current batch was rolled back.")
                print("Error:", e)

                # Try rows individually so one bad row
                # does not destroy the entire load.
                for row in rows:

                    try:
                        cursor.execute(sql, row)
                        conn.commit()
                        inserted += 1

                    except Exception:
                        conn.rollback()
                        skipped += 1

    cursor.close()

    print("\nUSERS loading completed.")
    print("Inserted:", inserted)
    print("Skipped:", skipped)


# ============================================================
# LOAD ARTIST
# ============================================================

def load_artists(conn):

    file_path = os.path.join(DATA_DIR, "artists.csv")

    if not os.path.exists(file_path):
        raise FileNotFoundError(f"File not found: {file_path}")

    print("\n========================================")
    print("LOADING ARTIST")
    print("========================================")

    df = pd.read_csv(file_path)
    df = normalize_columns(df)

    print("CSV columns:", list(df.columns))
    print("CSV rows:", len(df))

    required = [
        "artist_id",
        "name",
        "country",
        "bio",
        "awards"
    ]

    for col in required:
        if col not in df.columns:
            raise ValueError(f"Missing column in artists.csv: {col}")

    cursor = conn.cursor()

    sql = """
        INSERT INTO ARTIST
        (
            Artist_id,
            Name,
            Country,
            Bio,
            Awards
        )
        VALUES
        (
            :1, :2, :3, :4, :5
        )
    """

    inserted = 0
    skipped = 0

    for start in range(0, len(df), BATCH_SIZE):

        batch = df.iloc[start:start + BATCH_SIZE]

        rows = []

        for _, row in batch.iterrows():

            try:

                rows.append((
                    int(row["artist_id"]),
                    str(row["name"])[:150],
                    str(row["country"])[:100],
                    str(row["bio"])[:500],
                    str(row["awards"])[:200]
                ))

            except Exception as e:

                skipped += 1
                print(
                    f"Skipping ARTIST row: {e}"
                )

        if rows:

            try:

                cursor.executemany(sql, rows)
                conn.commit()

                inserted += len(rows)

                print(
                    f"Artists loaded: "
                    f"{inserted}/{len(df)}"
                )

            except oracledb.IntegrityError as e:

                conn.rollback()

                print("\nWARNING: Duplicate or invalid ARTIST record.")
                print("The current batch was rolled back.")
                print("Error:", e)

                # Retry individual rows
                for row in rows:

                    try:

                        cursor.execute(sql, row)
                        conn.commit()
                        inserted += 1

                    except Exception:

                        conn.rollback()
                        skipped += 1

    cursor.close()

    print("\nARTIST loading completed.")
    print("Inserted:", inserted)
    print("Skipped:", skipped)


# ============================================================
# LOAD GENRE
# ============================================================

def load_genres(conn):

    file_path = os.path.join(DATA_DIR, "genres.csv")

    if not os.path.exists(file_path):
        raise FileNotFoundError(f"File not found: {file_path}")

    print("\n========================================")
    print("LOADING GENRE")
    print("========================================")

    df = pd.read_csv(file_path)
    df = normalize_columns(df)

    print("CSV columns:", list(df.columns))
    print("CSV rows:", len(df))

    required = [
        "genre_id",
        "name"
    ]

    for col in required:
        if col not in df.columns:
            raise ValueError(f"Missing column in genres.csv: {col}")

    cursor = conn.cursor()

    sql = """
        INSERT INTO GENRE
        (
            Genre_id,
            Name
        )
        VALUES
        (
            :1, :2
        )
    """

    inserted = 0
    skipped = 0

    for _, row in df.iterrows():

        try:

            values = (
                int(row["genre_id"]),
                str(row["name"])[:100]
            )

            cursor.execute(sql, values)
            conn.commit()

            inserted += 1

        except Exception as e:

            conn.rollback()
            skipped += 1

            print(
                f"Skipping GENRE "
                f"{row.get('genre_id', '?')}: {e}"
            )

    cursor.close()

    print("\nGENRE loading completed.")
    print("Inserted:", inserted)
    print("Skipped:", skipped)


# ============================================================
# MAIN PROGRAM
# ============================================================

def main():

    print("\n")
    print("================================================")
    print("      MUSIC STREAMING DATABASE LOADER")
    print("================================================")

    print("\nThis script loads ONLY:")
    print("1. USERS")
    print("2. ARTIST")
    print("3. GENRE")

    print("\nIt will NOT load:")
    print("ALBUM")
    print("SONG")
    print("SONG_GENRE")
    print("PREMIUM_USER")
    print("FREE_USER")
    print("PLAYLIST")
    print("PLAYLIST_SONG")
    print("SUBSCRIPTION")
    print("PAYMENT")
    print("RATING")
    print("LISTENING_HISTORY")

    conn = None

    try:

        conn = get_connection()

        # ----------------------------------------------------
        # IMPORTANT ORDER
        # USERS first
        # ARTIST second
        # GENRE third
        # ----------------------------------------------------

        load_users(conn)

        load_artists(conn)

        load_genres(conn)

        print("\n================================================")
        print("ALL CORE TABLES LOADED SUCCESSFULLY")
        print("================================================")

    except Exception as e:

        print("\n================================================")
        print("LOADING STOPPED")
        print("================================================")

        print("ERROR:")
        print(e)

    finally:

        if conn:

            conn.close()

            print("\nOracle connection closed.")


# ============================================================
# RUN
# ============================================================

if __name__ == "__main__":
    main()