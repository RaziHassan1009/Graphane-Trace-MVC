# Changelog

All notable changes to the Graphene Trace Sensore project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2024-11-09

### Added
- **Enhanced Security**
  - Session management with automatic timeout and activity tracking
  - Cryptographically secure random password generation using `RandomNumberGenerator`
  - UserSession model for tracking login sessions
  - Session expiration and automatic logout
  - Enhanced authentication service with session validation

- **Improved Logging**
  - Structured logging with log levels (Debug, Info, Warning, Error, Critical)
  - Support for custom properties in log entries
  - Better exception formatting with inner exception details
  - Thread-safe logging with proper disposal pattern
  - UTC timestamps for consistency

- **Code Quality**
  - Comprehensive XML documentation on all public APIs
  - Input validation on all authentication methods
  - Generic error messages to prevent username enumeration
  - Proper async/await patterns throughout
  - Enhanced error handling with specific error messages

### Changed
- **Authentication Service**
  - Refactored to use session-based authentication
  - Added activity tracking for session renewal
  - Improved error messages for better UX
  - Enhanced password change validation

- **Logger**
  - Converted to sealed class with IDisposable pattern
  - Added structured logging capabilities
  - Improved log entry formatting
  - Better error handling in log cleanup

### Removed
- Removed 26+ redundant documentation files
- Removed obsolete SQL password fix scripts
- Cleaned up unnecessary markdown files

### Security
- Fixed critical vulnerability: Replaced `Random` with `RandomNumberGenerator` for password generation
- Added session timeout enforcement
- Implemented automatic session expiration
- Enhanced input validation across all services

## [1.0.0] - 2024-11-01

### Added
- Initial release of Graphene Trace Sensore
- Multi-tier user authentication (Admin, Clinician, Patient)
- Real-time pressure mapping with 32x32 sensor matrix
- Heat map visualization
- Alert system with multiple severity levels
- Comment and feedback system
- Report generation
- CSV data import functionality
- BCrypt password hashing
- Entity Framework Core integration
- SQL Server database support

### Features
- Role-based access control
- Patient-clinician assignment
- Pressure data analytics
- Alert acknowledgment workflow
- Timeline scrubber for historical data
- Metrics calculation (Peak Pressure, Contact Area, Risk Index)

---

## Version History

- **2.0.0** - Professional refactoring and security enhancements
- **1.0.0** - Initial production release
