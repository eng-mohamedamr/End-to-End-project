from functools import lru_cache

from pydantic_settings import BaseSettings
from sqlalchemy import URL


class Settings(BaseSettings):
    """Configuration read from environment variables (e.g. DB_HOST, APP_VERSION)."""

    app_version: str = "dev"
    environment: str = "local"

    db_host: str = "localhost"
    db_port: int = 5432
    db_name: str = "taskboard"
    db_user: str = "taskboard"
    db_password: str = "taskboard"

    # Full SQLAlchemy URL. When set, it replaces the DB_* settings (the tests use SQLite).
    database_url: str | None = None

    # Comma-separated origins allowed to call the API from another domain (local `npm run dev`).
    cors_origins: str = ""

    @property
    def sqlalchemy_url(self) -> URL | str:
        if self.database_url:
            return self.database_url
        return URL.create(
            "postgresql+psycopg",
            username=self.db_user,
            password=self.db_password,
            host=self.db_host,
            port=self.db_port,
            database=self.db_name,
        )


@lru_cache
def get_settings() -> Settings:
    return Settings()
