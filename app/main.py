from fastapi import FastAPI

from prometheus_client import generate_latest
from prometheus_client import CONTENT_TYPE_LATEST

from fastapi.responses import Response

from app.api.health import router as health_router
from app.api.users import router as users_router
from app.api.cache import router as cache_router

from app.core.config import settings
from app.core.logging import configure_logging

configure_logging(settings.LOG_LEVEL)

app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION
)

app.include_router(health_router)
app.include_router(users_router)
app.include_router(cache_router)


@app.get("/metrics")
def metrics():

    return Response(
        content=generate_latest(),
        media_type=CONTENT_TYPE_LATEST
    )