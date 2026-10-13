import logging
import time
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from prometheus_fastapi_instrumentator import Instrumentator
from sqlalchemy.exc import OperationalError

from taskboard import models  # noqa: F401  (registers the tables on Base.metadata)
from taskboard.config import get_settings
from taskboard.database import Base, engine
from taskboard.routes import router

logger = logging.getLogger("taskboard")


def create_tables(attempts: int = 30, delay: float = 2.0) -> None:
    """Create the tables, waiting for the database if it is still starting."""
    for attempt in range(1, attempts + 1):
        try:
            Base.metadata.create_all(engine)
            return
        except OperationalError:
            logger.warning("Database not ready (attempt %s/%s)", attempt, attempts)
            time.sleep(delay)
    raise RuntimeError("Database is not reachable")


@asynccontextmanager
async def lifespan(app: FastAPI):
    create_tables()
    yield


app = FastAPI(
    title="TaskBoard API",
    version=get_settings().app_version,
    lifespan=lifespan,
    docs_url="/api/docs",
    openapi_url="/api/openapi.json",
)

origins = [o.strip() for o in get_settings().cors_origins.split(",") if o.strip()]
if origins:
    app.add_middleware(CORSMiddleware, allow_origins=origins, allow_methods=["*"],
                       allow_headers=["*"])

app.include_router(router)

# Prometheus metrics on /metrics (scraped inside the cluster, not exposed through CloudFront)
Instrumentator().instrument(app).expose(app, endpoint="/metrics", include_in_schema=False)
