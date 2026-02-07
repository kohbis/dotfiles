---
name: write-tests
description: Add effective tests focused on behavior verification, prioritization by risk, and validation through real test runs. Trigger when user says "write tests", "add tests", "unit tests", "test this", or requests testing for specific code, modules, or features.
---

# Write Tests

## Workflow

1. Determine testing conventions:
   - Check project config files (AGENTS.md, CLAUDE.md, README, Makefile, etc.) for test framework and patterns
   - Look at existing tests for naming conventions, file placement, and style
   - If not found, ask the user

2. Analyze existing code to identify untested areas:
   - Core business logic
   - Edge cases and error handling
   - Integration points between modules

3. Prioritize tests by impact:
   - HIGH: Critical paths, payment, auth, data mutation
   - MEDIUM: User-facing features, API endpoints
   - LOW: Utilities, helpers, formatters

4. Write tests that document behavior:
   - Test WHAT the code does, not HOW it does it
   - Use descriptive test names as specifications
   - One assertion per test when possible

5. Focus on meaningful scenarios:
   - Happy path: Expected normal usage
   - Edge cases: Boundary values, empty inputs
   - Error cases: Invalid inputs, failure modes

6. Avoid:
   - Testing implementation details
   - Excessive mocking that hides real bugs
   - Tests that break on refactoring

7. Run tests to verify they pass and fail appropriately.

## Hard Rule

Write tests that catch bugs, not tests that chase coverage.
