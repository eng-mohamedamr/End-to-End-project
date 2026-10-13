def test_list_is_empty_at_start(client):
    assert client.get("/api/tasks").json() == []


def test_create_task(client):
    response = client.post("/api/tasks", json={"title": "Write the Helm chart"})
    assert response.status_code == 201
    body = response.json()
    assert body["title"] == "Write the Helm chart"
    assert body["done"] is False
    assert client.get("/api/tasks").json()[0]["id"] == body["id"]


def test_title_is_required(client):
    assert client.post("/api/tasks", json={"title": ""}).status_code == 422


def test_complete_task(client):
    task_id = client.post("/api/tasks", json={"title": "Deploy to EKS"}).json()["id"]
    response = client.patch(f"/api/tasks/{task_id}", json={"done": True})
    assert response.status_code == 200
    assert response.json()["done"] is True


def test_delete_task(client):
    task_id = client.post("/api/tasks", json={"title": "Temporary"}).json()["id"]
    assert client.delete(f"/api/tasks/{task_id}").status_code == 204
    assert client.get("/api/tasks").json() == []


def test_unknown_task_returns_404(client):
    assert client.patch("/api/tasks/999", json={"done": True}).status_code == 404
    assert client.delete("/api/tasks/999").status_code == 404
