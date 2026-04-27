"""
GitHub API client for the PR watcher service.

Replicates the behaviour of the bash function
``mark_pr_ready_and_auto_merge_on_checks_complete`` using the GitHub
GraphQL/REST APIs directly (so we don't need the ``gh`` CLI inside the
container).
"""

from __future__ import annotations

import logging
import os
from dataclasses import dataclass
from typing import Any

import requests

log = logging.getLogger(__name__)

GITHUB_API = "https://api.github.com"
GITHUB_GRAPHQL = "https://api.github.com/graphql"


class GitHubError(RuntimeError):
    """Raised when the GitHub API returns an error."""


@dataclass
class CheckStatus:
    """Aggregated status of all required checks for a PR."""

    all_passing: bool
    has_failure: bool
    rollup: list[dict[str, Any]]


def _token() -> str:
    token = os.environ.get("GITHUB_TOKEN")
    if not token:
        raise GitHubError("GITHUB_TOKEN environment variable is not set")
    return token


def _headers() -> dict[str, str]:
    return {
        "Authorization": f"Bearer {_token()}",
        "Accept": "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
    }


def _graphql(query: str, variables: dict[str, Any]) -> dict[str, Any]:
    resp = requests.post(
        GITHUB_GRAPHQL,
        json={"query": query, "variables": variables},
        headers=_headers(),
        timeout=30,
    )
    resp.raise_for_status()
    payload = resp.json()
    if "errors" in payload:
        raise GitHubError(f"GraphQL error: {payload['errors']}")
    return payload["data"]


# Names of checks that the original bash function explicitly ignores.
# We treat their status as "doesn't block merging".
_IGNORED_CHECK_NAMES = {"Owner Approval", "Code Ownership"}
_IGNORED_FAILURE_CHECKS = {"SonarQube Code Analysis"}


def get_pr_node_id_and_status(owner: str, repo: str, number: int) -> tuple[str, CheckStatus, str]:
    """Return ``(pr_node_id, CheckStatus, pr_state)`` for a PR.

    ``pr_state`` is one of ``OPEN``, ``CLOSED`` or ``MERGED``.
    """
    query = """
    query($owner:String!, $repo:String!, $number:Int!) {
      repository(owner:$owner, name:$repo) {
        pullRequest(number:$number) {
          id
          state
          isDraft
          commits(last:1) {
            nodes {
              commit {
                statusCheckRollup {
                  contexts(first:100) {
                    nodes {
                      __typename
                      ... on CheckRun {
                        name
                        status
                        conclusion
                      }
                      ... on StatusContext {
                        context
                        state
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    """
    data = _graphql(query, {"owner": owner, "repo": repo, "number": number})
    pr = data["repository"]["pullRequest"]
    if pr is None:
        raise GitHubError(f"PR {owner}/{repo}#{number} not found")

    contexts: list[dict[str, Any]] = []
    commits = pr["commits"]["nodes"]
    if commits and commits[0]["commit"]["statusCheckRollup"]:
        contexts = commits[0]["commit"]["statusCheckRollup"]["contexts"]["nodes"]

    rollup: list[dict[str, Any]] = []
    all_passing = True
    has_failure = False
    for ctx in contexts:
        if ctx["__typename"] == "CheckRun":
            name = ctx["name"]
            status = ctx["status"]  # QUEUED, IN_PROGRESS, COMPLETED ...
            conclusion = ctx["conclusion"]  # SUCCESS, FAILURE, NEUTRAL, SKIPPED, ...
        else:  # StatusContext
            name = ctx["context"]
            status = "COMPLETED"
            state = ctx["state"]  # EXPECTED, ERROR, FAILURE, PENDING, SUCCESS
            conclusion = {
                "SUCCESS": "SUCCESS",
                "FAILURE": "FAILURE",
                "ERROR": "FAILURE",
                "PENDING": None,
                "EXPECTED": None,
            }.get(state)

        rollup.append({"name": name, "status": status, "conclusion": conclusion})

        if name in _IGNORED_CHECK_NAMES:
            continue
        if conclusion in ("SUCCESS", "NEUTRAL", "SKIPPED"):
            continue
        if (
            name in _IGNORED_FAILURE_CHECKS
            and status == "COMPLETED"
            and conclusion == "FAILURE"
        ):
            # Mirror the bash filter that ignores SonarQube failures.
            continue
        if status == "COMPLETED" and conclusion in ("FAILURE", "TIMED_OUT", "CANCELLED", "ACTION_REQUIRED"):
            has_failure = True
            all_passing = False
        else:
            # Still running / queued / unknown - not yet passing.
            all_passing = False

    return pr["id"], CheckStatus(all_passing=all_passing, has_failure=has_failure, rollup=rollup), pr["state"]


def mark_ready_for_review(pr_node_id: str) -> None:
    mutation = """
    mutation($id:ID!) {
      markPullRequestReadyForReview(input:{pullRequestId:$id}) {
        pullRequest { id isDraft }
      }
    }
    """
    _graphql(mutation, {"id": pr_node_id})


def enable_auto_merge(pr_node_id: str, method: str = "SQUASH") -> None:
    mutation = """
    mutation($id:ID!, $method:PullRequestMergeMethod!) {
      enablePullRequestAutoMerge(input:{pullRequestId:$id, mergeMethod:$method}) {
        pullRequest { id }
      }
    }
    """
    _graphql(mutation, {"id": pr_node_id, "method": method})
