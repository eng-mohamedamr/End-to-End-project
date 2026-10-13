FROM python:3.13-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

# Dependencies first: this layer is cached until requirements.txt changes.
# Then remove pip: the running app doesn't need a package manager (and pip bundles its own libraries
# that scanners flag).
COPY requirements.txt .
RUN pip install -r requirements.txt \
 && pip uninstall -y pip

COPY taskboard ./taskboard

# Run as a non-root user with a numeric UID (Kubernetes runAsNonRoot can verify it)
RUN useradd --uid 10001 --no-create-home --shell /usr/sbin/nologin app
USER 10001

ARG APP_VERSION=dev
ENV APP_VERSION=${APP_VERSION}

EXPOSE 8000
CMD ["uvicorn", "taskboard.main:app", "--host", "0.0.0.0", "--port", "8000", "--proxy-headers", "--forwarded-allow-ips", "*"]
