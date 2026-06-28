# General Code Rules
- Always divide tests into 3 parts separated with comments. // Arrange // Act // Assert.

- Remove unnecessary and unused tests on your way of developing new things.

- Never remove the existing inline comment unless explicitly asked to do so. At the same time avoid adding new inline comments when developing.

- All doc-blocks should be at most 1 short sentence.

- Do not keep history in comments while changing the code.

- Variable re-assignment is generally bad practice

# Golang Rules
- Always wrap returned errors with `fmt.Errorf` and `%w`, enforced by the `wrapcheck` linter. Make sure `wrapcheck` is available in linter rules.

- Always prefer testify `require.NoError(...)`/`assert.*` over manual `if err != nil { t.Error... }` checks in tests.

- Define every interface with a `//go:generate go tool mockgen` directive and regenerate all mocks via `make mock`.

- Package name should reflect the functionality not the tool.

- Avoid having interface and implementation class in the same file. Generally we should have each struct in separate file.

# JavaScript Rules

# Correctness Rules
- Null undefined handling should be complete all the time

- Logic errors and missing error handling that changes behaviour

- Off-by-one

- Null/undefined handling

- Inverted or wrong conditionals

- Broken control flow

- Incorrect API/library usage

- Race conditions

- Resource leaks
