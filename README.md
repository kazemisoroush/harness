# Harness

Personal AI harness that manages development across all my projects from one place.

## What this is

- A single point of contact AI for all my work.
- A devcontainer plus a `.claude/` config with shared rules, commands, and agents.
- A `projects/` folder that holds local clones of every project the harness manages.

## Projects

Local clones live under `projects/` and are not tracked by this repo. Current projects:

- `book`
- `vault`
- `janus-electric`
- `discovery-os`

## Commands

- `/project:load <name>` loads full context for a project.
- `/builder:plan` plans a task across the relevant projects.
- `/builder:build` completes a planned task.
- `/repo:create-pr`, `/repo:update-pr`, `/repo:review-pr`, `/repo:fix-pr`, `/repo:merge-pr`, and `/repo:protect` manage pull requests on a repository.

## Hard Rules

- [Quality Bar](.claude/QUALITY.md)
- [Hallucination Avoidance Guide](.claude/HALLUCINATION.md)
- [Code Rules](.claude/CODE.md)

## Prerequisites

- VS Code with the Dev Containers extension, or GitHub Codespaces.
- All MCP servers authorised, configured in `.mcp.json`.
- The `gh` CLI for repository interactions.
