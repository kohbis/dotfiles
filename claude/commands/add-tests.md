---
description: "Add effective tests focusing on behavior verification, not coverage metrics."
---

# Add Tests

Add effective tests that verify behavior, not just increase coverage:

1. Analyze existing code to identify untested areas:
   - Core business logic
   - Edge cases and error handling
   - Integration points between modules

2. Prioritize tests by impact:
   - HIGH: Critical paths, payment, auth, data mutation
   - MEDIUM: User-facing features, API endpoints
   - LOW: Utilities, helpers, formatters

3. Write tests that document behavior:
   - Test WHAT the code does, not HOW it does it
   - Use descriptive test names as specifications
   - One assertion per test when possible

4. Focus on meaningful scenarios:
   - Happy path: Expected normal usage
   - Edge cases: Boundary values, empty inputs
   - Error cases: Invalid inputs, failure modes

5. Avoid:
   - Testing implementation details
   - Excessive mocking that hides real bugs
   - Tests that break on refactoring

6. Run tests to verify they pass and fail appropriately

Write tests that catch bugs, not tests that chase coverage!
