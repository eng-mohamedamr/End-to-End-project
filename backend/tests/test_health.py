def test_health(client):
    response = client.get("/api/health")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"


def test_ready(client):
    response = client.get("/api/health/ready")
    assert response.status_code == 200
    assert response.json() == {"status": "ready"}


def test_metrics(client):
    client.get("/api/health")
    response = client.get("/metrics")
    assert response.status_code == 200
    assert "http_requests_total" in response.text
