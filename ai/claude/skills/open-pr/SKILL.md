---
name: open-pr
description: Opens a pull request (PR) on GitHub. Use when the user requests to open a PR (pull request), draft or otherwise.
---

When opening a PR on GitHub, default to opening the PR as a draft unless specified otherwise by the user.

Always use the following body format for the PR:

```
# Problem & Solution Overview

<INSERT_COMMIT_MESSAGE_HERE>

# Testing Done

- [ ] CI passes
- [ ] `mint build` passes locally
```

Replace `<INSERT_COMMIT_MESSAGE_HERE>` with the commit message.

**Only** if a Jira ticket is identified (a string matching `\w+-\d+` at the beginning of the first line of the commit message; e.g. `TOOLS-123`), add the following section and replace `TODO_123` with the Jira ticket. **If no Jira ticket is found, omit the entire Jira Info section.**

```
# Jira Info

BUG=TODO_123
```

After the Jira Info section (or after Testing Done if no Jira section), use the `/workflow-tracker:pr-summary` skill to gather Claude Code usage stats. Include the output as a collapsible section in the PR body:

```
# AI Details

<details>
<summary>Claude Code Usage Stats</summary>

<INSERT_PR_SUMMARY_OUTPUT_HERE>

</details>
```

Replace `<INSERT_PR_SUMMARY_OUTPUT_HERE>` with the output from the `workflow-tracker:pr-summary` skill.

Finally, add the below to the very end of the PR:

```
<div align="center"><i>
<img src="https://raw.githubusercontent.com/lobehub/lobe-icons/refs/heads/master/packages/static-svg/icons/claude-color.svg"/>
Generated with <a href="https://claude.com/claude-code">Claude Code</a>
<img src="https://raw.githubusercontent.com/lobehub/lobe-icons/refs/heads/master/packages/static-svg/icons/claude-color.svg"/>
</i></div>
```
