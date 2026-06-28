---
name: Review PR
description: Spawn single-responsibility review sub-agents on a GitHub PR (correctness + security), which post inline comments via gh.
argument-hint: <pr-number> [owner/repo]
tools:
  - Bash
  - Read
  - Grep
  - Glob
  - Task
---

Spawn the single-responsibility PR reviewers on a GitHub pull request. GitHub repositories only (the reviewers use `gh`).

- You are not allowed to merge the PR on your own without being asked to do it.

- Determine the PR number from `$ARGUMENTS` (the first token). If no PR number is given, try the current branch's PR via `gh pr view --json number -q .number`; if that fails, stop and ask the user for the PR number.

- Determine the repo (`owner/name`): use the second token of `$ARGUMENTS` if provided, otherwise `gh repo view --json nameWithOwner -q .nameWithOwner` from the current directory.

- Spawn these reviewers IN PARALLEL using the Task tool — one Task call each, in the same message:
  * `pr-correctness-reviewer` — correctness/logic bugs only.
  * `pr-security-reviewer` — security issues only.

- Pass each reviewer the PR number and the repo (`owner/name`) so it can read the diff and post inline comments via `gh`.

- Do NOT review the code yourself — delegate. Each reviewer does exactly one thing.

- When both finish, show the user a one-line summary per reviewer (findings count + the PR URL). Do not repeat their inline comments.
