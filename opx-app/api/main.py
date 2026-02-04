from fastapi import FastAPI, HTTPException
from fastapi.responses import Response
from pydantic import BaseModel
from prometheus_client import CONTENT_TYPE_LATEST, generate_latest

from api.db import (
    app_db_ready,
    jobs_db_ready,
    insert_item,
    list_items,
    enqueue_job,
    list_jobs,
)

app = FastAPI(title="opx-app")


class ItemIn(BaseModel):
    payload: dict


class JobIn(BaseModel):
    payload: dict
    run_in_seconds: int = 0


@app.get("/healthz")
def healthz():
    return {"ok": True}


@app.get("/readyz")
def readyz():
    return {"app_db": app_db_ready(), "jobs_db": jobs_db_ready()}


@app.get("/metrics")
def metrics():
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)


@app.post("/items")
def create_item(body: ItemIn):
    try:
        item_id = insert_item(body.payload)
        return {"id": item_id}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/items")
def get_items(limit: int = 20):
    try:
        return {"items": list_items(limit)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/jobs")
def create_job(body: JobIn):
    try:
        job_id = enqueue_job(body.payload, body.run_in_seconds)
        return {"id": job_id}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/jobs")
def get_jobs(limit: int = 50):
    try:
        return {"jobs": list_jobs(limit)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

