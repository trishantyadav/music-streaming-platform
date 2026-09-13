import oracledb
from db_config import ORACLE_USER, ORACLE_PASSWORD, ORACLE_DSN
try:
    connection = oracledb.connect(
    user=ORACLE_USER,
    password=ORACLE_PASSWORD,
    dsn=ORACLE_DSN
)

    print("=" * 50)
    print("ORACLE CONNECTION SUCCESSFUL")
    print("=" * 50)

    print("User:", connection.username)
    print("DSN:", connection.dsn)

    cursor = connection.cursor()

    cursor.execute("SELECT COUNT(*) FROM user_tables")
    table_count = cursor.fetchone()[0]

    print("Tables in MUSIC_APP:", table_count)

    cursor.close()
    connection.close()

except Exception as e:
    print("ORACLE CONNECTION FAILED")
    print(e)