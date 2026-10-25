import os
import psycopg


postgres_user: str = os.environ["POSTGRES_USER"]
postgres_password: str = os.environ["POSTGRESS_PASSWORD"]
postgres_database: str = os.environ["POSTGRES_DB"]
postgres_host: str = os.environ["POSTGRES_HOST"]
postgres_port: str = os.environ["POSTGRES_PORT"]

with psycopg.connect(
    host=postgres_host,
    dbname=postgres_database,
    user=postgres_user,
    password=postgres_password,
    port=postgres_port
) as conn:

    with conn.cursor() as cur:
        cur.execute("SELECT current_user, current_database();")
        print(cur.fetchall())
    