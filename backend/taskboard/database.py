from collections.abc import Iterator

from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase, Session, sessionmaker
from sqlalchemy.pool import StaticPool

from taskboard.config import get_settings


class Base(DeclarativeBase):
    pass


def _make_engine():
    url = get_settings().sqlalchemy_url
    if str(url).startswith("sqlite"):
        # In-memory SQLite for the tests: one shared connection across threads
        return create_engine(url, connect_args={"check_same_thread": False}, poolclass=StaticPool)
    return create_engine(url, pool_pre_ping=True)


engine = _make_engine()
SessionLocal = sessionmaker(bind=engine, autoflush=False, expire_on_commit=False)


def get_session() -> Iterator[Session]:
    with SessionLocal() as session:
        yield session
