import os
import json
from typing import Any, Dict, List, Optional

import psycopg
from psycopg.rows import dict_row


APP_DSN = os.environ.get("APP_DSN", "").strip()
JOBS_DSN = os.environ.get("JOBS_DSN", "").strip()


def _conn(dsn: str):
    # autocommit=True so simple statements work without explicit commit
    return psycopg.connect(dsn, autocommit=True, row_factory=dict_row)


def app_db_ready() -> bool:
    if not APP_DSN:
        return False
    try:
        with _conn(APP_DSN) as c:
            with c.cursor() as cur:
                cur.execute("SELECT 1;")
        return True
    except Exception:
        return False


def jobs_db_ready() -> bool:
    if not JOBS_DSN:
        return False
    try:
        with _conn(JOBS_DSN) as c:
            with c.cursor() as cur:
                cur.execute("SELECT 1;")
        return True
    except Exception:
        return False


def insert_item(payload: Dict[str, Any]) -> int:
    with _conn(APP_DSN) as c:
        with c.cursor() as cur:
            cur.execute(
                "INSERT INTO app.items (payload, status) VALUES (%s::jsonb, 'new') RETURNING id;",
                (json.dumps(payload),),
            )
            row = cur.fetchone()
            return int(row["id"])


def list_items(limit: int = 20) -> List[Dict[str, Any]]:
    limit = max(1, min(int(limit), 200))
    with _conn(APP_DSN) as c:
        with c.cursor() as cur:
            cur.execute(
                "SELECT id, created_at, payload, status FROM app.items ORDER BY id DESC LIMIT %s;",
                (limit,),
            )
            rows = cur.fetchall()
            # payload might already be dict, keep it as-is
            return rows


def enqueue_job(payload: Dict[str, Any], run_in_seconds: int = 0) -> int:
    run_in_seconds = max(0, int(run_in_seconds))
    with _conn(JOBS_DSN) as c:
        with c.cursor() as cur:
            cur.execute(
                """
                INSERT INTO jobs.queue (run_at, payload, status)
                VALUES (now() + (%s || ' seconds')::interval, %s::jsonb, 'new')
                RETURNING id;
                """,
                (str(run_in_seconds), json.dumps(payload)),
            )
            row = cur.fetchone()
            return int(row["id"])


def list_jobs(limit: int = 50) -> List[Dict[str, Any]]:
    limit = max(1, min(int(limit), 200))
    with _conn(JOBS_DSN) as c:
        with c.cursor() as cur:
            cur.execute(
                "SELECT id, created_at, run_at, payload, status FROM jobs.queue ORDER BY id DESC LIMIT %s;",
                (limit,),
            )
            return cur.fetchall()

