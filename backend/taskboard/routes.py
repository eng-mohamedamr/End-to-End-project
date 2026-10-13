from fastapi import APIRouter, Depends, HTTPException, Response, status
from sqlalchemy import select, text
from sqlalchemy.orm import Session

from taskboard.config import get_settings
from taskboard.database import get_session
from taskboard.models import Task
from taskboard.schemas import TaskCreate, TaskOut, TaskUpdate

router = APIRouter(prefix="/api")


@router.get("/health")
def health():
    """Liveness: the process is up."""
    settings = get_settings()
    return {"status": "ok", "version": settings.app_version, "environment": settings.environment}


@router.get("/health/ready")
def ready(response: Response, session: Session = Depends(get_session)):
    """Readiness: the database answers."""
    try:
        session.execute(text("SELECT 1"))
    except Exception:
        response.status_code = status.HTTP_503_SERVICE_UNAVAILABLE
        return {"status": "database unavailable"}
    return {"status": "ready"}


@router.get("/tasks", response_model=list[TaskOut])
def list_tasks(session: Session = Depends(get_session)):
    return session.scalars(select(Task).order_by(Task.id)).all()


@router.post("/tasks", response_model=TaskOut, status_code=status.HTTP_201_CREATED)
def create_task(payload: TaskCreate, session: Session = Depends(get_session)):
    task = Task(title=payload.title)
    session.add(task)
    session.commit()
    session.refresh(task)
    return task


@router.patch("/tasks/{task_id}", response_model=TaskOut)
def update_task(task_id: int, payload: TaskUpdate, session: Session = Depends(get_session)):
    task = session.get(Task, task_id)
    if task is None:
        raise HTTPException(status_code=404, detail="Task not found")
    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(task, field, value)
    session.commit()
    session.refresh(task)
    return task


@router.delete("/tasks/{task_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_task(task_id: int, session: Session = Depends(get_session)):
    task = session.get(Task, task_id)
    if task is None:
        raise HTTPException(status_code=404, detail="Task not found")
    session.delete(task)
    session.commit()
