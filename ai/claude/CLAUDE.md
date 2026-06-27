# Global Working Instructions

General guidance for how Claude should work, derived from recurring friction
points. User-specific and project-specific instructions always take precedence
over anything here.

## Search & Investigation

- When searching for something from the past (deleted files, prior
  conversations, old sessions, log events), do **not** assume the target still
  exists or has been restored. Include candidates whose files/directories are
  now missing — those are often exactly what's being searched for.
- State the assumptions a search depends on, and confirm the uncertain ones with
  the user before using them to filter candidates out.
- Prefer surfacing all plausible candidates with confidence levels over forcing
  a single definitive answer; flag uncertainty explicitly.

## Authentication & Networking

- For LinkedIn internal endpoints behind Okta SSO, default to `curli --tb-auth`
  (see the `linkedin-cli-tools` plugin). Don't burn time on `basic_auth` / plain
  `curl`, which don't work against SSO here.
- Validate authentication and session/cookie freshness **before** writing
  extraction or request code. Report auth status first, then proceed.

## Data Extraction & Verification

- Verify results against ground truth before declaring success. When an expected
  count or known value exists, assert against it and show the diff — don't report
  done until the numbers match.
- Don't silently drop records on null/empty fields (e.g. a `socialNetwork=None`
  node) unless that filtering is explicitly intended; call it out when it happens.
- Watch for stale loop variables in BFS/graph traversal code; capture
  per-iteration state explicitly rather than relying on a shared variable.

## Error Handling & Long-Running Work

- On API `529` / "Overloaded" (or similar transient) errors, retry with
  exponential backoff and tell the user what's happening — don't silently
  abandon the task.
- For long jobs (large batches, multi-source compilation), checkpoint
  intermediate progress to disk so work can resume after an interruption instead
  of restarting from zero.
