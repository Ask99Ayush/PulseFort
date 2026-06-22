from pydantic import BaseModel

from fastapi import APIRouter
from fastapi import HTTPException

from app.services.cache_service import (
    set_cache,
    get_cache
)

router = APIRouter(
    prefix="/cache",
    tags=["Cache"]
)


class CacheRequest(BaseModel):
    key: str
    value: str


@router.post("")
def set_cache_endpoint(
    payload: CacheRequest
):

    return set_cache(
        payload.key,
        payload.value
    )


@router.get("/{key}")
def get_cache_endpoint(
    key: str
):

    value = get_cache(key)

    if value is None:
        raise HTTPException(
            status_code=404,
            detail="Key not found"
        )

    return {
        "key": key,
        "value": value
    }