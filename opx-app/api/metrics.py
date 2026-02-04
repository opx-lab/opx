from prometheus_client import Counter, Histogram


HTTP_REQS = Counter(
"opx_http_requests_total",
"Total HTTP requests",
["method", "path", "status"],
)


HTTP_LAT = Histogram(
"opx_http_request_duration_seconds",
"HTTP request latency",
["method", "path"],
)


DB_OPS = Counter(
"opx_db_ops_total",
"DB operations",
["db", "op"],
)