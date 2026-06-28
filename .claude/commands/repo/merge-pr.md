---
name: Merge PR
description: Merge a green, approved GitHub PR (squash), then switch to main and pull latest.
argument-hint: <pr-number-or-url> [owner/repo]
tools:
  - Bash
  - Read
  - Grep
  - Glob
  - AskUserQuestion
  - Skill
---

- MANDATORY FIRST STEP: Invoke the `/project:load` skill with `$ARGUMENTS` using the Skill tool (skill: "project:load", args: "$ARGUMENTS"). This step must complete before anything else. The output determines which project and repository the PR is for. Do not attempt to detect the project yourself.

- You are not allowed to merge the PR on your own without being asked to do it.

- Merge a pull request for the project returned by `/project:load`. GitHub repositories only (the merge uses `gh`).

- Determine the PR number from `$ARGUMENTS` (the first token). If no PR number is given, try the current branch's PR via `gh pr view --json number -q .number`; if that fails, stop and ask the user for the PR number.

- Determine the repo (`owner/name`): use the second token of `$ARGUMENTS` if provided, otherwise `gh repo view --json nameWithOwner -q .nameWithOwner` from the current directory.

- Pre-merge gates — do NOT merge unless ALL pass (`gh pr view <pr> -R <owner/repo> --json state,isDraft,mergeable,mergeStateStatus,reviewDecision`): state OPEN and not draft; `mergeable` MERGEABLE and `mergeStateStatus` CLEAN; checks green (`gh pr checks <pr> -R <owner/repo>`); `reviewDecision` is `APPROVED` (stop on `CHANGES_REQUESTED`/`REVIEW_REQUIRED`; if `null`, flag the PR as unapproved when confirming).

- Confirm with the user before merging (a merge is hard to undo). Show the PR title, number, base, and check status; wait for explicit go-ahead.

- Merge with squash and delete the remote branch: `gh pr merge <pr> -R <owner/repo> --squash --delete-branch`.

- Switch to the default branch and pull latest: `git checkout main && git pull`.

- Report the merge commit SHA and the PR URL.
