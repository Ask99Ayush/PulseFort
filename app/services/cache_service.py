from app.db.redis import redis_client


def set_cache(
    key: str,
    value: str
):

    redis_client.set(key, value)

    return {
        "key": key,
        "value": value
    }


def get_cache(
    key: str
):

    value = redis_client.get(key)

    return value