# Project Guidelines (Common)

## Project Overview

- **Project Name**: [Your project name]
- **Purpose**: [Project purpose and goals]
- **Tech Stack**: [Technologies used]
- **Architecture**: [System architecture overview]
- **Target Users**: [Intended audience]
- **Development Principles**:
  - [Principle 1]
  - [Principle 2]
  - [Principle 3]

---

## Coding Conventions

### 1. Language and Style

#### General Principles

- Prioritize code readability
- Write appropriate comments (but avoid excessive commenting)
- Use consistent naming conventions
- Follow DRY principle (Don't Repeat Yourself)

#### Naming Conventions

- **Variables/Functions**: camelCase (JavaScript/TypeScript), snake_case (Python/Ruby)
- **Classes**: PascalCase
- **Constants**: UPPER_SNAKE_CASE
- **Files**: kebab-case or snake_case

### 2. Code Structure

#### Directory Structure

```txt
/src/                   # Source code
/tests/                 # Test code
/docs/                  # Documentation
/config/                # Configuration files
/scripts/               # Build and deploy scripts
```

#### File Naming Conventions

- Use clear, purpose-driven names
- Apply consistent patterns
- Organize with directories as needed

### 3. Comments and Documentation

- Add comments for complex logic
- Write documentation comments for public APIs and functions
- Include ticket numbers with TODO and FIXME comments
- Actively reflect code review feedback in comments

### 4. Error Handling

- Implement appropriate exception handling
- Make error messages specific and understandable
- Use appropriate log levels (DEBUG, INFO, WARN, ERROR)
- Always log critical errors

### 5. Testing and Coverage

- Always create unit tests
- Cover main flows with integration tests
- Maintain test code quality equal to production code
- Run automated tests in CI/CD pipeline

### 6. Security

- Always validate input
- Never hardcode sensitive information (use environment variables)
- Regularly check dependencies for vulnerabilities
- Implement proper authentication and authorization

---

## Dependency and Library Management

### Library Selection Criteria

- Prioritize actively maintained libraries
- Verify licenses
- Check for security vulnerabilities
- Consider community size and activity

### Version Management

- Follow semantic versioning
- Pin dependency versions appropriately
- Perform regular updates
- Watch for breaking changes

### Package Management

- Always commit lock files
- Remove unnecessary dependencies
- Properly separate devDependencies and dependencies

---

## Prohibitions and Precautions

1. **Security**
   - Never include sensitive information (API keys, passwords, tokens) in code
   - Use environment variables or dedicated secret management tools
   - Always review code with security risks

2. **Code Quality**
   - Don't ignore linter or formatter warnings
   - Prohibit merging directly to main branch without code review
   - Don't deploy untested code to production

3. **Copyright and Licenses**
   - Verify licenses when using external code
   - Provide appropriate attribution
   - Properly manage copyright notices

4. **Performance**
   - Reduce unnecessary processing
   - Implement appropriate caching strategies
   - Optimize database queries
   - Prevent resource leaks

5. **Documentation**
   - Keep README up to date
   - Auto-generate API documentation when possible
   - Update architecture diagrams when changed

---

## Development Workflow

### Branch Strategy

```txt
main          # Production environment
develop       # Development environment
feature/*     # Feature development
bugfix/*      # Bug fixes
hotfix/*      # Emergency fixes
```

### Commit Messages

```txt
[type]: Summary (within 50 characters)

Detailed description (if needed)

- Change 1
- Change 2

Refs: #issue-number
```

**type**:

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation update
- `style`: Code style change
- `refactor`: Refactoring
- `test`: Test addition/modification
- `chore`: Build and auxiliary tool related

### Pull Requests

- Clearly describe purpose and changes
- Assign appropriate reviewers
- Ensure all CI/CD checks pass
- Merge latest base branch before merging

---

## Development Commands

```bash
# Development environment setup
npm install          # or: yarn install, pip install -r requirements.txt

# Start development server
npm run dev          # or: npm start, yarn dev

# Build
npm run build

# Run tests
npm test             # or: npm run test, yarn test

# Lint
npm run lint         # Code quality check
npm run lint:fix     # Auto-fix

# Format
npm run format       # Code formatting

# Type check (TypeScript)
npm run type-check
```

---

## CI/CD

### Automated Checks

- Linting (ESLint, Pylint, etc.)
- Testing (unit, integration)
- Build verification
- Security scanning
- Coverage reports

### Deploy Flow

1. Create pull request
2. Automated checks in CI/CD pipeline
3. Code review
4. Merge approval
5. Automated deployment (staging → production)

---

## Change History

- [Date]: Initial version
- [Date]: Migrated to .ai-context/ common management system
