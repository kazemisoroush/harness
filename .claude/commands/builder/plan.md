---
name: Builder Plan Command
description: Produce a change plan for a feature across relevant platforms and repositories.
argument-hint: <complex-task>
tools:
  - Bash
  - Read
  - Grep
  - Glob
---

- Load [Session Starter](../../../CLAUDE.md) word-by-word for the relevant project into your context.

- Silently use /load command to load the entire context about project into Claude context.

- Read the task and understand which [Projects](../../../docs/projects/*) this task is about.

- Report: Follow [Quality Bar Rules](../../QUALITY.md) here.

```md
# Summary of Change: Detail of the plan

# List of Repositories to be changed:
* Repo 1: {Why?}
* Repo 2: {Why?}

# TLDR
  Short and simple to understand version of the plan
```