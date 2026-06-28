---
name: Create PR
description: Create a pull request.
argument-hint: <repo-url-or-path> [title]
tools:
  - Bash
  - Read
  - Grep
  - Glob
  - AskUserQuestion
  - Skill
---

- MANDATORY FIRST STEP: Invoke the `/project:load` skill with `$ARGUMENTS` using the Skill tool (skill: "project:load", args: "$ARGUMENTS"). This step must complete before anything else. The output determines which project and repository the PR is for. Do not attempt to detect the project yourself.

- Create a pull request for the project returned by `/project:load`.

- You are not allowed to merge the PR on your own without being asked to do it.

- Before creating the PR, gather context:
  * Current branch name and tracked remote.
  * `git status` to confirm there are no uncommitted changes that should be part of the PR.
  * Except for my personal repositories. They do not need Jira—don’t confirm please.

- Resolve conflicts before creating the PR:
  * Stash any uncommitted changes, then rebase onto the target branch.
  * Resolve any conflicts, keeping the intent of both sides.
  * Force-push the rebased branch, then restore stashed changes.
  * Confirm the branch is clean and contains only the intended commits.

- PR Details:
  * PR Source Branch: `{feat|fix}/short-description`.
  * PR Title: `{feat|fix}/short-description`.
  * Reviewers: Default reviewers of the repository if any.
  * PR Description:

```
## What?
One sentence description of what this PR is.

## Why?
One sentence description of why this PR is important.

## References
Itemised list of all references, links, Confluence pages, Notion pages, Jira tickets, possibly other PRs, and etc.

## Review Checklist
[ ] Item 1
[ ] Item 2
```

- Create the PR according to the repository.

- Post-PR review (only after the PR exists, and only for GitHub repositories):
  * Invoke the `/repo:review-pr` skill with `<pr-number> <owner/repo>` using the Skill tool (skill: "repo:review-pr"). It spawns the single-responsibility reviewers and posts inline comments.
  * Show the user the per-reviewer summary it returns.
