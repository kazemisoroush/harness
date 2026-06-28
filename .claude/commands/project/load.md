---
name: Load Command
description: Loads context around a particular Macquarie Platform
argument-hint: <platform-name>
tools:
  - Bash
  - Read
  - Grep
  - Glob
  - AskUserQuestion
---

Load [Session Starter](../../../CLAUDE.md) word-by-word for the relevant project into your context.

The first argument `$ARGUMENTS` is the platform name.

- If `$ARGUMENTS` is empty or not provided, scan [Projects List](../../docs/projects/*) for all available `.md` files, then use the `AskUserQuestion` tool with `multiSelect: false` to present them as a single-select list. Each option label should be the project name (derived from the filename without extension). Wait for user selection before proceeding.

- Extract project name from the argument or the user's selection and find the [Project Session Starter File](../../docs/projects/*)

- Do not just load the platform home page if there is any. You should search MCP integrations for relevant pages and information and copy them word-by-word to the context.

- If the platform name is not amongst the list, you should stop immediately and tell user that the platform is not supported by this Harness repository and they should add it to the list before they can proceed.

- Once user confirmed and selected a supported platform you should refer to the Markdown file and copy word-by-word all the data presented there into the Claude context. Including:
  * All repositories cloned
  
- Report all repositories back to the caller.
