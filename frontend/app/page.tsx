"use client";

import { FormEvent, useEffect, useState } from "react";
import { api, Task } from "@/lib/api";

const FRONTEND_VERSION = process.env.NEXT_PUBLIC_APP_VERSION ?? "dev";

export default function Home() {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [title, setTitle] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [backendVersion, setBackendVersion] = useState("…");

  async function refresh() {
    try {
      setTasks(await api.listTasks());
      setError(null);
    } catch (e) {
      setError((e as Error).message);
    }
  }

  useEffect(() => {
    api.health().then((h) => setBackendVersion(h.version)).catch(() => setBackendVersion("offline"));
    api
      .listTasks()
      .then(setTasks)
      .catch((e: Error) => setError(e.message));
  }, []);

  async function addTask(event: FormEvent) {
    event.preventDefault();
    if (!title.trim()) return;
    await api.createTask(title.trim());
    setTitle("");
    await refresh();
  }

  const remaining = tasks.filter((t) => !t.done).length;

  return (
    <main className="container">
      <header>
        <h1>✅ TaskBoard</h1>
        <p className="muted">
          {remaining} of {tasks.length} tasks left
        </p>
      </header>

      <form onSubmit={addTask} className="new-task">
        <input
          aria-label="New task"
          placeholder="What needs to be done?"
          value={title}
          maxLength={200}
          onChange={(e) => setTitle(e.target.value)}
        />
        <button type="submit">Add</button>
      </form>

      {error && <p className="error">⚠️ {error}</p>}

      <ul className="tasks">
        {tasks.map((task) => (
          <li key={task.id} className={task.done ? "done" : ""}>
            <label>
              <input
                type="checkbox"
                checked={task.done}
                onChange={async () => {
                  await api.toggleTask(task);
                  await refresh();
                }}
              />
              <span>{task.title}</span>
            </label>
            <button
              className="delete"
              aria-label={`Delete ${task.title}`}
              onClick={async () => {
                await api.deleteTask(task.id);
                await refresh();
              }}
            >
              ✕
            </button>
          </li>
        ))}
      </ul>

      <footer className="muted">
        frontend {FRONTEND_VERSION} · backend {backendVersion}
      </footer>
    </main>
  );
}
