## GitHub Copilot Behavioral Guidelines

### Inline Completion Behavior

- Generate completions that strictly follow project's existing patterns
- Infer context from surrounding code, open files, and recent edits
- Prioritize completions that match the immediate code context
- Avoid suggesting deprecated APIs or outdated patterns
- Complete based on comments when they provide clear intent

### Code Generation Principles

- Maintain consistency with existing code style in the file
- Respect type annotations and generate type-safe code
- Generate minimal, focused completions rather than verbose implementations
- Prefer idiomatic patterns over clever or complex solutions
- Match the abstraction level of surrounding code

### Context Sensitivity

- Learn from recent user edits and modifications to suggestions
- Adapt to project-specific naming conventions
- Recognize and follow established patterns in the codebase
- Consider import statements and dependencies when generating code
- Respect linter and formatter configurations

### Completion Constraints

- Do not suggest hardcoded credentials or sensitive data
- Avoid generating large blocks of boilerplate without clear intent
- Respect user's partial input and build upon it
- Generate completions that align with the project's language version
