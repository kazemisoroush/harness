---
name: Fix PR
description: Address the review findings on a GitHub PR, apply and verify the fixes, then update the PR.
argument-hint: <pr-number-or-url> [owner/repo]
tools:
  - Bash
  - Read
  - Grep
  - Glob
  - Edit
  - Write
  - AskUserQuestion
  - Skill
  - Task
---

- MANDATORY FIRST STEP: Invoke the `/project:load` skill with `$ARGUMENTS` using the Skill tool (skill: "project:load", args: "$ARGUMENTS"). This step must complete before anything else. The output determines which project and repository the PR is for. Do not attempt to detect the project yourself.

- You are not allowed to merge the PR on your own without being asked to do it.

- Fix the review findings on a pull request for the project returned by `/project:load`. GitHub repositories only (the fix loop uses `gh`).

- Determine the PR number from `$ARGUMENTS` (the first token). If no PR number is given, try the current branch's PR via `gh pr view --json number -q .number`; if that fails, stop and ask the user for the PR number.

- Determine the repo (`owner/name`): use the second token of `$ARGUMENTS` if provided, otherwise `gh repo view --json nameWithOwner -q .nameWithOwner` from the current directory.

- Before fixing, gather context:
  * Current branch name and tracked remote; check out the PR's head branch if you are not already on it.
  * `git status` to confirm there are no unrelated uncommitted changes; only changes that address the findings should be part of the PR.
  * Except for my personal repositories. They do not need Jira—don’t confirm please.

- Collect the findings to fix:
  * Inline review comments (`gh api repos/<owner>/<name>/pulls/<pr>/comments`), review summaries (`gh api repos/<owner>/<name>/pulls/<pr>/reviews`), and issue comments (`gh api repos/<owner>/<name>/issues/<pr>/comments`).
  * If there are no review findings yet, run the `/repo:review-pr` skill first to generate them, then collect again.

- Address each finding in code:
  * Keep the intent of the comment; fix the root cause, not just the symptom.
  * Follow the repository hard rules ([Quality Bar](../../QUALITY.md), [Hallucination Avoidance Guide](../../HALLUCINATION.md), [Code Rules](../../CODE.md)).
  * If a finding is wrong or you disagree, do not silently skip it—reply on the thread explaining why.

- Verify before pushing:
  * Run the project's checks (build, tests, linters) and make them green.
  * Confirm CI is expected to pass; do not push known-red changes.

- Resolve conflicts before updating the PR:
  * Stash any uncommitted changes, then rebase onto the target branch.
  * Resolve any conflicts, keeping the intent of both sides.
  * Force-push the rebased branch, then restore stashed changes.
  * Confirm the branch is clean and contains only the intended commits.

- Commit and push the fixes:
  * Use a descriptive commit message that references the review.
  * Push to the PR's head branch.

- Close the loop on the PR:
  * Reply to each addressed inline comment (and resolve the thread where possible), or post one summary comment mapping each finding to its fix.
  * Make sure PR Details are still relevant; if not, update them.
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

- Confirm CI is green and report a one-line summary per finding (what it was and how it was fixed) plus the PR URL.
