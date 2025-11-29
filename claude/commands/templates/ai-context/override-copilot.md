## GitHub Copilot Specific Configuration

### Code Completion and Suggestions

#### Preferred Completion Patterns

- Conform to existing project code style
- Emphasize type safety (TypeScript, Python type hints, etc.)
- Secure coding patterns
- Performance-conscious implementation

#### Patterns to Avoid

- Using old APIs or deprecated methods
- Hardcoded sensitive information
- Inappropriate error handling
- Redundant code

### Comment-Based Completion

Effective comment writing:

```txt
# Good example: Specific and clear
# TODO: Implement user authentication API endpoint (using JWT)

# Bad example: Vague
# TODO: Add authentication
```

### Test Code Generation

- Prioritize unit test coverage
- Consider edge cases
- Use mocks and stubs appropriately
- Maintain test readability

---

## Project-Specific Recommendations

### Tech Stack Understanding

- Follow framework and library best practices
- Respect project dependencies
- Reflect configuration file settings (tsconfig.json, .eslintrc, etc.)

### Coding Conventions

- Conform to linter settings
- Follow formatter settings
- Naming convention consistency
- Unified import order

### Security

- Recommend input validation
- SQL injection prevention
- XSS prevention
- CSRF prevention

---

## Code Generation Guidelines

### Functions and Methods

1. Follow single responsibility principle
2. Use appropriate function names
3. Explicitly specify argument types (TypeScript, etc.)
4. Document with JSDoc/docstrings

### Classes and Modules

1. Proper encapsulation
2. Favor composition over inheritance
3. Utilize interfaces/abstract classes
4. Consider dependency injection

### Error Handling

1. Use appropriate exception types
2. Make error messages specific
3. Implement logging appropriately
4. Don't forget resource cleanup

---

## Completion for Code Quality Improvement

### Refactoring Suggestions

- Reduce code duplication
- Reduce complexity
- Improve readability
- Optimize performance

### Documentation Generation

- API documentation
- Provide usage examples
- Note precautions
- Record change history
