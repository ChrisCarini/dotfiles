"""Background poller that watches PRs and merges them when checks pass."""

from __future__ import annotations

import logging
import os
import threading
import time
from typing import Any

from github_client import GitHubError, enable_auto_merge, get_pr_node_id_and_status, mark_ready_for_review
from store import STATUS_COMPLETED, STATUS_FAILED, STATUS_WATCHING, Store

log = logging.getLogger(__name__)


class Watcher:
    """Polls GitHub for each watched PR and acts when all checks pass.

    Replicates the bash function logic: a PR must show all required checks
    passing on N consecutive polls (default 3) before we mark it ready for
    review and enable auto-merge.
    """

    def __init__(
        self,
        store: Store,
        *,
        poll_interval: float | None = None,
        required_consecutive_passes: int | None = None,
        merge_method: str | None = None,
    ) -> None:
        self.store = store
        self.poll_interval = poll_interval if poll_interval is not None else float(
            os.environ.get("PR_WATCHER_POLL_INTERVAL", "30")
        )
        self.required_consecutive_passes = required_consecutive_passes if required_consecutive_passes is not None else int(
            os.environ.get("PR_WATCHER_REQUIRED_PASSES", "3")
        )
        self.merge_method = (merge_method or os.environ.get("PR_WATCHER_MERGE_METHOD", "SQUASH")).upper()
        self._stop = threading.Event()
        self._thread: threading.Thread | None = None

    def start(self) -> None:
        if self._thread and self._thread.is_alive():
            return
        self._stop.clear()
        self._thread = threading.Thread(target=self._run, name="pr-watcher", daemon=True)
        self._thread.start()
        log.info(
            "Watcher started (interval=%ss, required_passes=%s, merge=%s)",
            self.poll_interval,
            self.required_consecutive_passes,
            self.merge_method,
        )

    def stop(self) -> None:
        self._stop.set()
        if self._thread:
            self._thread.join(timeout=5)

    def _run(self) -> None:
        while not self._stop.is_set():
            try:
                self._tick()
            except Exception:  # pragma: no cover - defensive
                log.exception("Unexpected error during watcher tick")
            self._stop.wait(self.poll_interval)

    def _tick(self) -> None:
        active = self.store.list_active()
        if not active:
            return
        log.debug("Polling %d active PR(s)", len(active))
        for pr in active:
            try:
                self._check_pr(pr)
            except GitHubError as exc:
                log.warning("GitHub error for %s/%s#%s: %s", pr["owner"], pr["repo"], pr["number"], exc)
                self.store.update_after_check(
                    pr["id"],
                    status=STATUS_WATCHING,
                    consecutive_ok=0,
                    message=f"GitHub error: {exc}",
                    rollup=None,
                )
            except Exception as exc:  # pragma: no cover - defensive
                log.exception("Failed to check PR %s/%s#%s", pr["owner"], pr["repo"], pr["number"])
                self.store.update_after_check(
                    pr["id"],
                    status=STATUS_WATCHING,
                    consecutive_ok=0,
                    message=f"Error: {exc}",
                    rollup=None,
                )

    def _check_pr(self, pr: dict[str, Any]) -> None:
        owner, repo, number = pr["owner"], pr["repo"], pr["number"]
        node_id, status, pr_state = get_pr_node_id_and_status(owner, repo, number)

        if pr_state == "MERGED":
            self.store.update_after_check(
                pr["id"],
                status=STATUS_COMPLETED,
                consecutive_ok=self.required_consecutive_passes,
                message="PR merged.",
                rollup=status.rollup,
            )
            return
        if pr_state == "CLOSED":
            self.store.update_after_check(
                pr["id"],
                status=STATUS_FAILED,
                consecutive_ok=0,
                message="PR was closed without merging.",
                rollup=status.rollup,
            )
            return

        consecutive = pr["consecutive_ok"] or 0
        if status.has_failure:
            self.store.update_after_check(
                pr["id"],
                status=STATUS_FAILED,
                consecutive_ok=0,
                message="One or more required checks failed.",
                rollup=status.rollup,
            )
            return

        if status.all_passing:
            consecutive += 1
            if consecutive >= self.required_consecutive_passes:
                # All checks have been green long enough - merge it.
                try:
                    mark_ready_for_review(node_id)
                except GitHubError as exc:
                    log.info("markReadyForReview for #%s: %s", number, exc)
                enable_auto_merge(node_id, self.merge_method)
                self.store.update_after_check(
                    pr["id"],
                    status=STATUS_COMPLETED,
                    consecutive_ok=consecutive,
                    message=f"All checks passed {consecutive}x; marked ready and auto-merge enabled.",
                    rollup=status.rollup,
                )
                log.info("PR %s/%s#%s queued for auto-merge.", owner, repo, number)
                return
            self.store.update_after_check(
                pr["id"],
                status=STATUS_WATCHING,
                consecutive_ok=consecutive,
                message=f"All checks green ({consecutive}/{self.required_consecutive_passes}).",
                rollup=status.rollup,
            )
            return

        # Still pending
        self.store.update_after_check(
            pr["id"],
            status=STATUS_WATCHING,
            consecutive_ok=0,
            message="Waiting for checks to complete.",
            rollup=status.rollup,
        )


# Convenience for tests
def now() -> float:  # pragma: no cover - trivial
    return time.time()
