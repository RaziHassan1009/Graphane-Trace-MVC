# Contributing to Graphene Trace Sensore

Thank you for your interest in contributing to the Graphene Trace Sensore project. This document provides guidelines and standards for contributing to the codebase.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Git Workflow](#git-workflow)
- [Pull Request Process](#pull-request-process)
- [Testing Guidelines](#testing-guidelines)

## Code of Conduct

### Our Standards

- Be respectful and professional
- Focus on constructive feedback
- Prioritize patient safety and data security
- Maintain confidentiality of sensitive information

## Development Setup

### Prerequisites

1. Install .NET 6.0 SDK
2. Install SQL Server 2019+ or SQL Server Express
3. Install Visual Studio 2022 or VS Code with C# extension
4. Install SQL Server Management Studio (SSMS)

### Initial Setup

```bash
# Clone the repository
git clone <repository-url>
cd Graphene

# Restore dependencies
cd GrapheneSensore
dotnet restore

# Setup database
# Run Database/CreateDatabase.sql in SSMS

# Build the project
dotnet build

# Run the application
dotnet run
```

## Coding Standards

### C# Style Guide

#### Naming Conventions

```csharp
// Classes, Methods, Properties - PascalCase
public class UserService
{
    public async Task<User> GetUserAsync(Guid userId) { }
    public string FullName { get; set; }
}

// Private fields - _camelCase with underscore prefix
private readonly ILogger _logger;
private UserSession? _currentSession;

// Local variables, parameters - camelCase
public void ProcessData(int userId, string userName)
{
    var processedData = Transform(userId);
}

// Constants - PascalCase
public const int DefaultTimeout = 60;
```

#### File Organization

```csharp
// 1. Using statements (sorted alphabetically)
using System;
using System.Linq;
using System.Threading.Tasks;
using GrapheneSensore.Models;

// 2. Namespace
namespace GrapheneSensore.Services
{
    // 3. XML documentation
    /// <summary>
    /// Service for managing user authentication
    /// </summary>
    public class AuthenticationService
    {
        // 4. Fields
        private readonly ILogger _logger;
        
        // 5. Constructors
        public AuthenticationService(ILogger logger)
        {
            _logger = logger;
        }
        
        // 6. Properties
        public bool IsAuthenticated { get; private set; }
        
        // 7. Public methods
        public async Task<bool> LoginAsync(string username, string password)
        {
            // Implementation
        }
        
        // 8. Private methods
        private void ValidateCredentials(string username, string password)
        {
            // Implementation
        }
    }
}
```

### Documentation Standards

#### XML Documentation

All public APIs must have XML documentation:

```csharp
/// <summary>
/// Authenticates a user and creates a secure session
/// </summary>
/// <param name="username">The username for authentication</param>
/// <param name="password">The user's password</param>
/// <returns>
/// A tuple containing:
/// - success: true if authentication succeeded
/// - message: descriptive message about the result
/// - user: the authenticated user object, or null if failed
/// </returns>
/// <exception cref="ArgumentNullException">
/// Thrown when username or password is null
/// </exception>
public async Task<(bool success, string message, User? user)> LoginAsync(
    string username, 
    string password)
{
    // Implementation
}
```

#### Code Comments

```csharp
// Good: Explains WHY, not WHAT
// Use BCrypt work factor of 11 for optimal security/performance balance
var hash = BCrypt.HashPassword(password, 11);

// Bad: Explains obvious code
// Hash the password
var hash = BCrypt.HashPassword(password);
```

### Error Handling

#### Always use specific exception types

```csharp
// Good
try
{
    await SaveUserAsync(user);
}
catch (DbUpdateException ex)
{
    _logger.LogError("Database update failed", ex, "UserService");
    throw new InvalidOperationException("Failed to save user", ex);
}
catch (ArgumentNullException ex)
{
    _logger.LogError("Invalid argument", ex, "UserService");
    throw;
}

// Bad
catch (Exception ex)
{
    // Too broad
}
```

#### Validate inputs early

```csharp
public async Task<User> GetUserAsync(Guid userId)
{
    if (userId == Guid.Empty)
        throw new ArgumentException("User ID cannot be empty", nameof(userId));
    
    // Rest of implementation
}
```

### Async/Await Best Practices

```csharp
// Good: Use async all the way
public async Task<List<User>> GetUsersAsync()
{
    using var context = new SensoreDbContext();
    return await context.Users.ToListAsync();
}

// Bad: Blocking async code
public List<User> GetUsers()
{
    using var context = new SensoreDbContext();
    return context.Users.ToListAsync().Result; // Don't do this!
}

// Good: ConfigureAwait(false) for library code
public async Task<User> GetUserAsync(Guid userId)
{
    using var context = new SensoreDbContext();
    return await context.Users
        .FirstOrDefaultAsync(u => u.UserId == userId)
        .ConfigureAwait(false);
}
```

### Security Guidelines

#### Password Handling

```csharp
// Good: Use BCrypt with appropriate work factor
var hash = PasswordHelper.HashPassword(password);

// Good: Validate before hashing
var (isValid, message) = PasswordHelper.ValidatePassword(password);
if (!isValid)
    return (false, message);

// Bad: Never log passwords
_logger.LogInfo($"User logged in with password: {password}"); // NEVER!
```

#### SQL Injection Prevention

```csharp
// Good: Use parameterized queries (EF Core does this automatically)
var user = await context.Users
    .FirstOrDefaultAsync(u => u.Username == username);

// Bad: String concatenation (if using raw SQL)
var query = $"SELECT * FROM Users WHERE Username = '{username}'"; // NEVER!
```

#### Input Validation

```csharp
// Always validate and sanitize user input
public async Task<bool> CreateCommentAsync(string commentText)
{
    if (string.IsNullOrWhiteSpace(commentText))
        return false;
    
    // Sanitize input
    var sanitized = InputValidator.SanitizeInput(commentText);
    
    // Validate length
    if (sanitized.Length > 1000)
        return false;
    
    // Process sanitized input
    await SaveCommentAsync(sanitized);
    return true;
}
```

## Git Workflow

### Branch Naming

- `feature/description` - New features
- `bugfix/description` - Bug fixes
- `hotfix/description` - Critical production fixes
- `refactor/description` - Code refactoring
- `docs/description` - Documentation updates

### Commit Messages

Follow the Conventional Commits specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**

```
feat(auth): add session timeout functionality

Implement automatic session expiration after configured timeout period.
Sessions are now tracked with last activity time and expire after 60 minutes
of inactivity by default.

Closes #123
```

```
fix(security): replace Random with RandomNumberGenerator

Critical security fix: Replace insecure Random class with cryptographically
secure RandomNumberGenerator for password generation.

BREAKING CHANGE: Password generation now requires System.Security.Cryptography
```

## Pull Request Process

### Before Submitting

1. **Code Quality**
   - [ ] Code follows style guidelines
   - [ ] All public APIs have XML documentation
   - [ ] No compiler warnings
   - [ ] Code builds successfully

2. **Testing**
   - [ ] All existing tests pass
   - [ ] New tests added for new functionality
   - [ ] Manual testing completed

3. **Security**
   - [ ] No sensitive data in code
   - [ ] Input validation implemented
   - [ ] Security best practices followed

4. **Documentation**
   - [ ] README updated if needed
   - [ ] CHANGELOG updated
   - [ ] Code comments added where necessary

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
Describe testing performed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings
- [ ] Tests added/updated
- [ ] All tests pass
```

## Testing Guidelines

### Unit Tests

```csharp
[TestClass]
public class PasswordHelperTests
{
    [TestMethod]
    public void HashPassword_ValidPassword_ReturnsHash()
    {
        // Arrange
        var password = "Test@123";
        
        // Act
        var hash = PasswordHelper.HashPassword(password);
        
        // Assert
        Assert.IsNotNull(hash);
        Assert.IsTrue(hash.Length > 50);
        Assert.IsTrue(PasswordHelper.VerifyPassword(password, hash));
    }
    
    [TestMethod]
    [ExpectedException(typeof(ArgumentException))]
    public void HashPassword_NullPassword_ThrowsException()
    {
        // Act
        PasswordHelper.HashPassword(null);
    }
}
```

### Integration Tests

```csharp
[TestClass]
public class AuthenticationServiceTests
{
    private AuthenticationService _authService;
    
    [TestInitialize]
    public void Setup()
    {
        _authService = new AuthenticationService();
    }
    
    [TestMethod]
    public async Task LoginAsync_ValidCredentials_ReturnsSuccess()
    {
        // Arrange
        var username = "testuser";
        var password = "Test@123";
        
        // Act
        var (success, message, user) = await _authService.LoginAsync(username, password);
        
        // Assert
        Assert.IsTrue(success);
        Assert.IsNotNull(user);
        Assert.AreEqual(username, user.Username);
    }
}
```

## Questions?

If you have questions about contributing, please contact:
- Email: dev@graphenetrace.com
- Create an issue in the repository

---

Thank you for contributing to Graphene Trace Sensore!
