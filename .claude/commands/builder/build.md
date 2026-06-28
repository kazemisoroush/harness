---
name: Builder Build Command
description: Implement a planned feature end-to-end across the relevant repositories.
argument-hint: <complex-task>
tools:
  - Bash
  - Read
  - Grep
  - Glob
---

- Load [Session Starter](../../../CLAUDE.md) word-by-word for the relevant project into your context.

- Silently run /builder:plan first to produce the change plan if one is not already in context. Show plan output to the user and ask for their confirmation before moving on to actually complete the build task.

- Make sure all the cloned repositories are at the correct target branch before starting the task. Confirm that there is a proper default branch like `main` or `master` to create the PR against. If unsure stop immediately and ask user which branch to create the PR against. Give them options for branches.

- Test the local target branch against the remote target branch and make sure it is up-to-date.

- Complete the task with TDD and SOLID principles where applicable.

- For all changed repositories, make sure all the checks are passing according to the project documentation.

- Use the /repo:create-pr skill and explain the change to it to create a PR; show the create-pr skill's output to the user.

- Report: Follow [Quality Bar Rules](../../QUALITY.md) here.

```md
# Summary of Change: Simple one liner of what changed

# List of Repositories to be changed:
* Repo 1: {What? Why?}
* Repo 2: {What? Why?}

# TLDR
  Short and simple to understand version of the plan
```