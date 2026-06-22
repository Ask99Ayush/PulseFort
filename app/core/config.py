from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    APP_NAME: str = "PulseFort"
    APP_VERSION: str = "1.0.0"

    POSTGRES_HOST: str = "postgres"
    POSTGRES_PORT: int = 5432
    POSTGRES_DB: str = "pulsefort"
    POSTGRES_USER: str = "pulsefort"
    POSTGRES_PASSWORD: str = "pulsefort"

    REDIS_HOST: str = "redis"
    REDIS_PORT: int = 6379

    LOG_LEVEL: str = "INFO"

    model_config = SettingsConfigDict(
        env_file=".env",
        extra="ignore"
    )


settings = Settings()