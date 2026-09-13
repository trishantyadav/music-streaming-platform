import pandas as pd
import oracledb
from db_config import ORACLE_USER, ORACLE_PASSWORD, ORACLE_DSN
# ------------------------------------------------------------
# Read artist data
# ------------------------------------------------------------

df = pd.read_csv("data/artists.csv")

row = df.iloc[0]

artist_id = int(row["Artist_id"])
name = str(row["Name"])
country = str(row["Country"])
bio = str(row["Bio"])
awards = str(row["Awards"])

print("Python values:")
print(artist_id, type(artist_id))
print(name, type(name))
print(country, type(country))
print(bio, type(bio))
print(awards, type(awards))


# ------------------------------------------------------------
# Connect to Oracle
# ------------------------------------------------------------

conn = oracledb.connect(
    user=ORACLE_USER,
    password=ORACLE_PASSWORD,
    dsn=ORACLE_DSN
)

cursor = connection.cursor()


# ------------------------------------------------------------
# Explicitly define Oracle bind types
# ------------------------------------------------------------

cursor.setinputsizes(
    oracledb.DB_TYPE_NUMBER,
    oracledb.DB_TYPE_VARCHAR,
    oracledb.DB_TYPE_VARCHAR,
    oracledb.DB_TYPE_VARCHAR,
    oracledb.DB_TYPE_VARCHAR
)


# ------------------------------------------------------------
# Insert ONE artist
# ------------------------------------------------------------

sql = """
INSERT INTO ARTIST
(
    ARTIST_ID,
    NAME,
    COUNTRY,
    BIO,
    AWARDS
)
VALUES
(
    :1,
    :2,
    :3,
    :4,
    :5
)
"""

cursor.execute(
    sql,
    (
        artist_id,
        name,
        country,
        bio,
        awards
    )
)

connection.commit()

print("\nARTIST TEST INSERT SUCCESSFUL!")

cursor.close()
connection.close()