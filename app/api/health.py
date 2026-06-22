from fastapi import APIRouter
from sqlalchemy import text

from app.db.session import SessionLocal
from app.db.redis import redis_client

router = APIRouter(tags=["Health"])


@router.get("/")
def root():

    return {
        "application": "PulseFort",
        "status": "running"
    }


@router.get("/health")
def health():

    return {
        "status": "healthy"
    }


@router.get("/live")
def live():

    return {
        "status": "alive"
    }


@router.get("/ready")
def ready():

    postgres_ok = False
    redis_ok = False

    try:

        db = SessionLocal()

        db.execute(
            text("SELECT 1")
        )

        postgres_ok = True

    except Exception:
        postgres_ok = False

    finally:

        try:
            db.close()
        except Exception:
            pass

    try:

        redis_client.ping()

        redis_ok = True

    except Exception:
        redis_ok = False

    status = postgres_ok and redis_ok

    return {
        "ready": status,
        "postgres": postgres_ok,
        "redis": redis_ok
    }