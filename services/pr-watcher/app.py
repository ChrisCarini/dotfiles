"""Flask app exposing PR watch API and dashboard."""

from __future__ import annotations

import logging
import os
import re
from typing import Any
from urllib.parse import urlparse

from flask import Flask, abort, jsonify, render_template, request

from store import STATUS_COMPLETED, STATUS_FAILED, STATUS_WATCHING, Store
from watcher import Watcher

logging.basicConfig(
    level=os.environ.get("LOG_LEVEL", "INFO"),
    format="%(asctime)s %(levelname)s %(name)s: %(message)s",
)
log = logging.getLogger("pr-watcher")


def _parse_pr_url(url: str) -> tuple[str, str, int] | None:
    """Parse ``https://github.com/<owner>/<repo>/pull/<number>``."""
    try:
        parsed = urlparse(url)
    except ValueError:
        return None
    if parsed.netloc not in {"github.com", "www.github.com"}:
        return None
    parts = [p for p in parsed.path.split("/") if p]
    if len(parts) < 4 or parts[2] != "pull":
        return None
    try:
        return parts[0], parts[1], int(parts[3])
    except ValueError:
        return None


_NAME_RE = re.compile(r"^[A-Za-z0-9._-]+$")


def _validate_repo_part(value: str) -> str:
    if not value or not _NAME_RE.match(value):
        abort(400, description=f"Invalid repository identifier: {value!r}")
    return value


def create_app(store: Store | None = None, watcher: Watcher | None = None) -> Flask:
    app = Flask(__name__)
    db_path = os.environ.get("PR_WATCHER_DB", "/data/pr-watcher.sqlite3")
    os.makedirs(os.path.dirname(db_path), exist_ok=True) if os.path.dirname(db_path) else None
    app.store = store or Store(db_path)  # type: ignore[attr-defined]
    app.watcher = watcher or Watcher(app.store)  # type: ignore[attr-defined]
    if os.environ.get("PR_WATCHER_DISABLE_BACKGROUND") != "1":
        app.watcher.start()  # type: ignore[attr-defined]

    @app.get("/healthz")
    def healthz() -> Any:
        return {"status": "ok"}

    @app.post("/api/prs")
    def add_pr() -> Any:
        data = request.get_json(silent=True) or {}
        owner = data.get("owner")
        repo = data.get("repo")
        number = data.get("number")
        url = data.get("url")
        title = data.get("title")

        if url and not (owner and repo and number):
            parsed = _parse_pr_url(url)
            if not parsed:
                abort(400, description=f"Could not parse PR URL: {url!r}")
            owner, repo, number = parsed

        if not (owner and repo and number):
            abort(400, description="Provide either 'url' or all of 'owner', 'repo', 'number'.")

        owner = _validate_repo_part(str(owner))
        repo = _validate_repo_part(str(repo))
        try:
            number = int(number)
        except (TypeError, ValueError):
            abort(400, description="'number' must be an integer.")
        if number <= 0:
            abort(400, description="'number' must be positive.")

        if not url:
            url = f"https://github.com/{owner}/{repo}/pull/{number}"

        record = app.store.upsert_watch(owner, repo, number, title, url)  # type: ignore[attr-defined]
        log.info("Watching PR %s/%s#%s", owner, repo, number)
        return jsonify(record), 201

    @app.delete("/api/prs/<int:pr_id>")
    def remove_pr(pr_id: int) -> Any:
        app.store.delete(pr_id)  # type: ignore[attr-defined]
        return ("", 204)

    @app.get("/api/prs")
    def list_prs() -> Any:
        return jsonify(app.store.list_all())  # type: ignore[attr-defined]

    @app.get("/")
    def dashboard() -> Any:
        rows = app.store.list_all()  # type: ignore[attr-defined]
        groups = {STATUS_WATCHING: [], STATUS_FAILED: [], STATUS_COMPLETED: []}
        for r in rows:
            groups.setdefault(r["status"], []).append(r)
        return render_template("dashboard.html", groups=groups)

    return app


# Gunicorn entrypoint
app = create_app()
