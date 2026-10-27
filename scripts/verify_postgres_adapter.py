import os

import psycopg

postgres_user: str = os.environ["POSTGRES_USER"]
postgres_password: str = os.environ["POSTGRES_PASSWORD"]
postgres_database: str = os.environ["POSTGRES_DB"]
postgres_host: str = os.environ["POSTGRES_HOST"]
postgres_port: str = os.environ["POSTGRES_PORT"]

with psycopg.connect(
    host=postgres_host,
    dbname=postgres_database,
    user=postgres_user,
    password=postgres_password,
    port=postgres_port,
    connect_timeout=5,
) as conn:
    with conn.cursor() as cur:
        cur.execute("SELECT current_user, current_database();")
        row = cur.fetchone()

        assert row is not None
        assert row[0] == postgres_user
        assert row[1] == postgres_database

        print(f"\033[92m[PASS]\033[0m PostgreSQL connection: user={row[0]}, database={row[1]}")
