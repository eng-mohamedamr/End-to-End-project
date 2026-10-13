import os

# Use an in-memory SQLite database for the tests (set BEFORE the app is imported)
os.environ["DATABASE_URL"] = "sqlite+pysqlite:///:memory:"

import pytest  # noqa: E402
from fastapi.testclient import TestClient  # noqa: E402

from taskboard.database import Base, engine  # noqa: E402
from taskboard.main import app  # noqa: E402


@pytest.fixture
def client():
    with TestClient(app) as test_client:  # runs the lifespan (creates the tables)
        yield test_client
    Base.metadata.drop_all(engine)
