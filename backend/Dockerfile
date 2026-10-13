FROM python:3.13 as build
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt\
    && pip uninstall -y pip
COPY taskboard ./taskboard
ARG APP_VERSION=dev
ENV APP_VERSION=${APP_VERSION}
ENV ENVIRONMENT=production
EXPOSE 8000
USER 10001
CMD ["gunicorn", "taskboard.main:app", "--host", "0.0.0.0", "--port", "8000"]