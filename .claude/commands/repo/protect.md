---
name: Protect Branch
description: Apply PR gates to a repo's default branch — require a PR, 1 approval, and passing checks; block direct/force pushes.
argument-hint: <repo-url-or-path> [reference-repo]
tools:
  - Bash
  - Read
  - Grep
  - Glob
  - AskUserQuestion
  - Skill
---

- MANDATORY FIRST STEP: Invoke the `/project:load` skill with `$ARGUMENTS` using the Skill tool (skill: "project:load", args: "$ARGUMENTS"). This step must complete before anything else. The output determines which project and repository to protect. Do not attempt to detect the project yourself.

- Protect the default branch of the repository returned by `/project:load`. GitHub repositories only (uses `gh`).

- Determine the target repo (`owner/name`) from the loaded project, and its default branch via `gh repo view <owner/repo> --json defaultBranchRef -q .defaultBranchRef.name` (usually `main`).

- Reference template: use `kazemisoroush/book` unless a second argument names another reference repo. Read its gates as the desired shape:
  * Ruleset: `gh api repos/<ref>/rulesets` then `gh api repos/<ref>/rulesets/<id>`.
  * Classic protection (for required check contexts): `gh api repos/<ref>/branches/<branch>/protection`.

- Determine the target repo's required status check contexts (the CI jobs that must pass):
  * List recent checks with their producing app, so each context can be pinned: `gh api repos/<owner>/<repo>/commits/<branch>/check-runs -q '.check_runs[] | {context: .name, integration_id: .app.id}'`.
  * If none are found, ask the user which checks to require (do not guess).

- Build a ruleset named `Protect main branch` (target `refs/heads/<branch>`, enforcement `active`) with these rules:
  * `pull_request` — `required_approving_review_count: 1`, `dismiss_stale_reviews_on_push: true` (no direct pushes; a PR with 1 approval is required).
  * `required_status_checks` — each detected check as `{context, integration_id}` (pin the producing app id so a same-named check from another source cannot satisfy the gate), with `strict_required_status_checks_policy: true`.
  * `non_fast_forward` (block force-pushes) and `deletion` (block branch deletion).

- Confirm with the user before applying (this changes repository settings). Show the target repo, branch, required approvals, required checks, and that direct/force pushes will be blocked. Wait for explicit go-ahead.

- Apply it: if a `Protect main branch` ruleset already exists, update it (`gh api --method PUT repos/<owner>/<repo>/rulesets/<id> --input <json>`); otherwise create it (`gh api --method POST repos/<owner>/<repo>/rulesets --input <json>`).

- Verify and report: re-read the ruleset, confirm enforcement is `active`, and report required approvals, required checks, and the blocked operations.
