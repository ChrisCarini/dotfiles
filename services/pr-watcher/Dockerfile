FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PR_WATCHER_DB=/data/pr-watcher.sqlite3

WORKDIR /app

RUN groupadd --system app && useradd --system --gid app --home /app app \
    && mkdir -p /data && chown app:app /data

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY github_client.py store.py watcher.py app.py ./
COPY templates ./templates

USER app
VOLUME ["/data"]
EXPOSE 8080

# Single gunicorn worker so we keep one in-process Watcher thread / SQLite writer.
CMD ["gunicorn", "--workers", "1", "--threads", "4", "--bind", "0.0.0.0:8080", "--access-logfile", "-", "app:app"]
