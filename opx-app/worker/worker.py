import os
import json
import time
import signal
from typing import Any, Dict, Optional

import psycopg
from psycopg.rows import dict_row
from http.server import BaseHTTPRequestHandler, HTTPServer
from prometheus_client import CONTENT_TYPE_LATEST, Counter, Histogram, generate_latest


JOBS_DSN = os.environ.get("JOBS_DSN", "").strip()
POLL_INTERVAL_SEC = int(os.environ.get("WORKER_POLL_INTERVAL_SEC", "2"))
HTTP_ADDR = os.environ.get("WORKER_HTTP_ADDR", "0.0.0.0")
HTTP_PORT = int(os.environ.get("WORKER_HTTP_PORT", "9109"))

RUNNING = True

jobs_processed_total = Counter("opx_jobs_processed_total", "Total jobs processed")
jobs_failed_total = Counter("opx_jobs_failed_total", "Total jobs failed")
job_duration_seconds = Histogram("opx_job_duration_seconds", "Job processing time (seconds)")


def _conn():
    return psycopg.connect(JOBS_DSN, autocommit=True, row_factory=dict_row)


def _db_ready() -> bool:
    if not JOBS_DSN:
        return False
    try:
        with _conn() as c:
            with c.cursor() as cur:
                cur.execute("SELECT 1;")
        return True
    except Exception:
        return False


def claim_one_job() -> Optional[Dict[str, Any]]:
    """
    Atomically claim one ready job using SKIP LOCKED.
    Requires table: jobs.queue (id, run_at, payload, status)
    """
    with _conn() as c:
        with c.cursor() as cur:
            cur.execute(
                """
                WITH picked AS (
                  SELECT id
                  FROM jobs.queue
                  WHERE status = 'new'
                    AND run_at <= now()
                  ORDER BY run_at ASC, id ASC
                  FOR UPDATE SKIP LOCKED
                  LIMIT 1
                )
                UPDATE jobs.queue q
                SET status = 'processing'
                FROM picked
                WHERE q.id = picked.id
                RETURNING q.id, q.payload;
                """
            )
            row = cur.fetchone()
            return row


def mark_done(job_id: int):
    with _conn() as c:
        with c.cursor() as cur:
            cur.execute(
                "UPDATE jobs.queue SET status = 'done' WHERE id = %s;",
                (job_id,),
            )


def mark_failed(job_id: int):
    with _conn() as c:
        with c.cursor() as cur:
            cur.execute(
                "UPDATE jobs.queue SET status = 'failed' WHERE id = %s;",
                (job_id,),
            )


def process(payload: Any):
    # Dummy "work": just sleep up to 0.2s based on payload size.
    s = json.dumps(payload)
    time.sleep(min(0.2, max(0.01, len(s) / 5000.0)))


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            if _db_ready():
                self.send_response(200)
                self.end_headers()
                self.wfile.write(b"OK\n")
            else:
                self.send_response(503)
                self.end_headers()
                self.wfile.write(b"DB NOT READY\n")
            return

        if self.path == "/metrics":
            data = generate_latest()
            self.send_response(200)
            self.send_header("Content-Type", CONTENT_TYPE_LATEST)
            self.end_headers()
            self.wfile.write(data)
            return

        # keep it simple; anything else is 404
        self.send_response(404)
        self.end_headers()

    def log_message(self, format, *args):
        # quiet
        return


def http_server():
    srv = HTTPServer((HTTP_ADDR, HTTP_PORT), Handler)
    while RUNNING:
        srv.handle_request()


def stop(_sig=None, _frame=None):
    global RUNNING
    RUNNING = False


def main():
    if not JOBS_DSN:
        raise RuntimeError("JOBS_DSN is empty")

    signal.signal(signal.SIGTERM, stop)
    signal.signal(signal.SIGINT, stop)

    # start HTTP metrics/health in-process (simple, no deps)
    import threading
    t = threading.Thread(target=http_server, daemon=True)
    t.start()

    while RUNNING:
        job = None
        try:
            job = claim_one_job()
        except Exception:
            time.sleep(POLL_INTERVAL_SEC)
            continue

        if not job:
            time.sleep(POLL_INTERVAL_SEC)
            continue

        job_id = int(job["id"])
        payload = job["payload"]

        with job_duration_seconds.time():
            try:
                process(payload)
                mark_done(job_id)
                jobs_processed_total.inc()
            except Exception:
                mark_failed(job_id)
                jobs_failed_total.inc()


if __name__ == "__main__":
    main()

