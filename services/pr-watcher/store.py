"""SQLite-backed persistence for watched PRs."""

from __future__ import annotations

import json
import sqlite3
import threading
import time
from contextlib import contextmanager
from typing import Any, Iterator

# Status values
STATUS_WATCHING = "watching"
STATUS_FAILED = "failed"
STATUS_COMPLETED = "completed"


_SCHEMA = """
CREATE TABLE IF NOT EXISTS prs (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    owner           TEXT NOT NULL,
    repo            TEXT NOT NULL,
    number          INTEGER NOT NULL,
    title           TEXT,
    url             TEXT,
    status          TEXT NOT NULL,
    consecutive_ok  INTEGER NOT NULL DEFAULT 0,
    last_checked    REAL,
    last_message    TEXT,
    rollup_json     TEXT,
    created_at      REAL NOT NULL,
    updated_at      REAL NOT NULL,
    UNIQUE(owner, repo, number)
);
"""


class Store:
    """Thread-safe SQLite wrapper."""

    def __init__(self, path: str) -> None:
        self._path = path
        self._lock = threading.Lock()
        with self._connect() as conn:
            conn.executescript(_SCHEMA)

    @contextmanager
    def _connect(self) -> Iterator[sqlite3.Connection]:
        conn = sqlite3.connect(self._path, timeout=30)
        conn.row_factory = sqlite3.Row
        try:
            yield conn
            conn.commit()
        finally:
            conn.close()

    # --- write operations ---------------------------------------------------

    def upsert_watch(self, owner: str, repo: str, number: int, title: str | None, url: str | None) -> dict[str, Any]:
        now = time.time()
        with self._lock, self._connect() as conn:
            conn.execute(
                """
                INSERT INTO prs (owner, repo, number, title, url, status, consecutive_ok, created_at, updated_at)
                VALUES (?, ?, ?, ?, ?, ?, 0, ?, ?)
                ON CONFLICT(owner, repo, number) DO UPDATE SET
                    title = COALESCE(excluded.title, prs.title),
                    url = COALESCE(excluded.url, prs.url),
                    status = ?,
                    consecutive_ok = 0,
                    updated_at = ?
                """,
                (owner, repo, number, title, url, STATUS_WATCHING, now, now, STATUS_WATCHING, now),
            )
            row = conn.execute(
                "SELECT * FROM prs WHERE owner=? AND repo=? AND number=?",
                (owner, repo, number),
            ).fetchone()
            return dict(row)

    def update_after_check(
        self,
        pr_id: int,
        *,
        status: str,
        consecutive_ok: int,
        message: str,
        rollup: list[dict[str, Any]] | None,
    ) -> None:
        now = time.time()
        with self._lock, self._connect() as conn:
            conn.execute(
                """
                UPDATE prs SET
                    status = ?,
                    consecutive_ok = ?,
                    last_checked = ?,
                    last_message = ?,
                    rollup_json = ?,
                    updated_at = ?
                WHERE id = ?
                """,
                (
                    status,
                    consecutive_ok,
                    now,
                    message,
                    json.dumps(rollup) if rollup is not None else None,
                    now,
                    pr_id,
                ),
            )

    def delete(self, pr_id: int) -> None:
        with self._lock, self._connect() as conn:
            conn.execute("DELETE FROM prs WHERE id=?", (pr_id,))

    # --- read operations ----------------------------------------------------

    def list_active(self) -> list[dict[str, Any]]:
        with self._connect() as conn:
            rows = conn.execute(
                "SELECT * FROM prs WHERE status=? ORDER BY created_at ASC",
                (STATUS_WATCHING,),
            ).fetchall()
            return [dict(r) for r in rows]

    def list_all(self) -> list[dict[str, Any]]:
        with self._connect() as conn:
            rows = conn.execute(
                "SELECT * FROM prs ORDER BY updated_at DESC"
            ).fetchall()
            return [dict(r) for r in rows]
