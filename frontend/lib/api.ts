export type Task = {
  id: number;
  title: string;
  done: boolean;
  created_at: string;
};

// Empty by default: the browser calls /api on the SAME domain (CloudFront routes /api/* to the backend).
// For `npm run dev`, set NEXT_PUBLIC_API_BASE_URL=http://localhost:8000
const BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL ?? "";

async function request<T>(path: string, init?: RequestInit): Promise<T> {
  const response = await fetch(`${BASE_URL}${path}`, {
    ...init,
    headers: { "Content-Type": "application/json", ...init?.headers },
  });
  if (!response.ok) {
    throw new Error(`${init?.method ?? "GET"} ${path} failed: ${response.status}`);
  }
  return (response.status === 204 ? undefined : await response.json()) as T;
}

export const api = {
  health: () => request<{ status: string; version: string; environment: string }>("/api/health"),
  listTasks: () => request<Task[]>("/api/tasks"),
  createTask: (title: string) =>
    request<Task>("/api/tasks", { method: "POST", body: JSON.stringify({ title }) }),
  toggleTask: (task: Task) =>
    request<Task>(`/api/tasks/${task.id}`, {
      method: "PATCH",
      body: JSON.stringify({ done: !task.done }),
    }),
  deleteTask: (id: number) => request<void>(`/api/tasks/${id}`, { method: "DELETE" }),
};
