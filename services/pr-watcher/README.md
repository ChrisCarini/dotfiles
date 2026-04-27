# PR Watcher

A small Python/Flask service that watches GitHub pull requests, waits for
all required checks to pass on three consecutive polls, then marks the PR
ready for review and enables auto-merge (squash). It exposes a tiny HTML
dashboard showing every watched PR and whether it is currently being
watched, has failed, or has completed.

This replaces the local-blocking
`mark_pr_ready_and_auto_merge_on_checks_complete` bash function in
[`system/.functions`](../../system/.functions): the function now just
submits the PR to this service and returns immediately.

## Endpoints

| Method | Path             | Description                                     |
| ------ | ---------------- | ----------------------------------------------- |
| GET    | `/`              | Dashboard (auto-refreshes every 15s).           |
| GET    | `/healthz`       | Health check.                                   |
| GET    | `/api/prs`       | List all PRs (JSON).                            |
| POST   | `/api/prs`       | Submit a PR. Body: `{"url": "..."}` or `{"owner","repo","number"}`. |
| DELETE | `/api/prs/<id>`  | Stop watching a PR.                             |

## Configuration

Environment variables:

| Var                          | Default                       | Description                                                |
| ---------------------------- | ----------------------------- | ---------------------------------------------------------- |
| `GITHUB_TOKEN`               | — (required)                  | GitHub PAT with `repo` scope.                              |
| `PR_WATCHER_POLL_INTERVAL`   | `30`                          | Seconds between polls.                                     |
| `PR_WATCHER_REQUIRED_PASSES` | `3`                           | Consecutive successful polls required before merging.      |
| `PR_WATCHER_MERGE_METHOD`    | `SQUASH`                      | `SQUASH`, `MERGE`, or `REBASE`.                            |
| `PR_WATCHER_DB`              | `/data/pr-watcher.sqlite3`    | SQLite path.                                               |
| `LOG_LEVEL`                  | `INFO`                        | Python logging level.                                      |

## Run with Docker

```sh
export GITHUB_TOKEN=ghp_xxx
docker compose up -d --build
open http://localhost:8080
```

## Submit a PR from the shell

The bash function does this for you, but you can also do it by hand:

```sh
curl -X POST http://localhost:8080/api/prs \
    -H 'content-type: application/json' \
    -d '{"url": "https://github.com/ChrisCarini/dotfiles/pull/123"}'
```

## Behaviour

For each watched PR the background poller:

1. Reads the latest commit's `statusCheckRollup` via the GitHub GraphQL API.
2. Ignores `Owner Approval` and `Code Ownership` checks (matching the
   original bash function), and treats `SonarQube Code Analysis` failures
   as non-blocking.
3. If any other required check has failed, marks the PR **failed**.
4. If all required checks succeed `PR_WATCHER_REQUIRED_PASSES` times in a
   row, marks the PR ready for review and enables auto-merge, then marks
   the entry **completed**.
5. If the PR is closed without merging, marks it **failed**; if it gets
   merged, marks it **completed**.
