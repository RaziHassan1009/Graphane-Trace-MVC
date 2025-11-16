# Graphene Trace - Sensore Pressure Mapping System

[![.NET](https://img.shields.io/badge/.NET-6.0-blue.svg)](https://dotnet.microsoft.com/)
[![License](https://img.shields.io/badge/License-Proprietary-red.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows-lightgrey.svg)](https://www.microsoft.com/windows)

## Overview

**Graphene Trace Sensore** is an enterprise-grade pressure ulcer prevention and monitoring system designed for healthcare environments. It provides continuous, automated monitoring using e-textile pressure mapping sensors with intelligent alert analysis and comprehensive data visualization.

### Core Capabilities

- **Multi-Tier Authentication** - Role-based access control (Admin, Clinician, Patient)
- **Real-Time Monitoring** - 32x32 sensor matrix with live heat map visualization
- **Intelligent Alerts** - Automated detection of high-pressure regions and risk patterns
- **Advanced Analytics** - Peak pressure index, contact area analysis, and risk scoring
- **Collaborative Workflow** - Comment system with threaded clinician responses
- **Comprehensive Reporting** - Statistical summaries and comparative analysis

## Architecture

### Technology Stack

| Component | Technology |
|-----------|-----------|
| Framework | .NET 6.0 WPF (Windows Presentation Foundation) |
| Database | SQL Server 2019+ / SQL Server Express |
| ORM | Entity Framework Core 7.0 |
| Authentication | BCrypt.Net (Adaptive Hashing) |
| Visualization | LiveCharts.Wpf |
| Configuration | Microsoft.Extensions.Configuration |
| Logging | Custom structured file-based logger |

### Security Features

- BCrypt password hashing with configurable work factor
- Session management with automatic timeout
- Role-based authorization
- Input validation and sanitization
- Cryptographically secure random generation
- SQL injection prevention via parameterized queries
- Audit logging for security events

## System Requirements

### Minimum Requirements
- **OS**: Windows 10 (1809+) or Windows Server 2019+
- **Runtime**: .NET 6.0 Runtime or SDK
- **Database**: SQL Server 2019 Express or higher
- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: 2GB free disk space
- **Display**: 1920x1080 resolution recommended

### Development Requirements
- Visual Studio 2022 or VS Code with C# extension
- SQL Server Management Studio (SSMS) 18.0+
- .NET 6.0 SDK

## Quick Start

### 1. Database Setup

```sql
-- Connect to your SQL Server instance
-- Execute the database creation script
USE master;
GO
-- Run: Database/CreateDatabase.sql
```

The script will:
- Create the `Grephene` database
- Initialize all required tables with proper indexes
- Set up foreign key relationships
- Create the default admin user

### 2. Application Configuration

Edit `GrapheneSensore/appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=YOUR_SERVER;Database=Grephene;Trusted_Connection=True;TrustServerCertificate=True;"
  }
}
```

### 3. Build and Run

```bash
cd GrapheneSensore
dotnet restore
dotnet build --configuration Release
dotnet run
```

### 4. Default Credentials

```
Username: admin
Password: Admin@123
```

**Important**: Change the default admin password immediately after first login.

## Project Structure

```
Graphene/
├── Database/
│   └── CreateDatabase.sql              # Database schema and initialization
├── Dataset/
│   └── GTLB-Data/                      # Sample pressure data (CSV format)
└── GrapheneSensore/                    # Main application
    ├── Configuration/                  # App configuration management
    ├── Constants/                      # Application constants
    ├── Controls/                       # Custom WPF controls
    ├── Data/                          # Entity Framework DbContext
    ├── Helpers/                       # Utility classes and converters
    ├── Logging/                       # Structured logging system
    ├── Models/                        # Domain models and entities
    ├── Services/                      # Business logic layer
    ├── Styles/                        # WPF styling resources
    ├── Utilities/                     # Helper utilities
    ├── Validation/                    # Input validation
    ├── ViewModels/                    # MVVM view models
    ├── Views/                         # WPF windows and dialogs
    └── appsettings.json              # Application configuration
```

## User Roles

### Administrator
- Full system access and user management
- CSV data import and batch processing
- System-wide statistics and monitoring
- Alert management across all patients
- Clinician-patient assignment

### Clinician
- Access to assigned patients only
- Pressure data review and analysis
- Alert acknowledgment and response
- Comment and feedback management
- Report generation for care planning

### Patient
- Personal data access only
- Real-time pressure visualization
- Historical data review via timeline
- Metrics monitoring
- Feedback submission

## Data Management

### CSV Import Format

Pressure data files must follow this specification:

- **Filename**: `{userId}_{YYYYMMDD}.csv`
- **Matrix Size**: 32x32 (1024 values per frame)
- **Value Range**: 1-255 (1 = no pressure, 255 = maximum)
- **Frame Sequence**: Continuous rows (32 rows = 1 frame)

Example:
```
1c0fd777_20251011.csv
├── Frame 1: Rows 1-32
├── Frame 2: Rows 33-64
└── Frame N: Rows (N*32-31) to (N*32)
```

### Database Schema

**Core Tables**:
- `Users` - User accounts and authentication
- `PressureMapData` - Sensor readings and calculated metrics
- `Alerts` - System-generated alerts
- `Comments` - User feedback and clinician responses
- `MetricsSummary` - Pre-aggregated hourly statistics
- `Reports` - Generated report metadata
- `SessionLogs` - User session tracking

## Security Best Practices

### Password Policy
- Minimum 8 characters
- At least one uppercase letter
- At least one lowercase letter
- At least one digit
- At least one special character

### Session Management
- Configurable timeout (default: 60 minutes)
- Automatic session expiration
- Activity-based session renewal

### Data Protection
- Passwords hashed with BCrypt (work factor: 11)
- No plain-text password storage
- Parameterized SQL queries
- Input sanitization on all user inputs

## Configuration

### Application Settings (`appsettings.json`)

```json
{
  "AppSettings": {
    "MatrixSize": 32,
    "PressureThreshold": 150,
    "MinAreaPixels": 10,
    "LowerThreshold": 20,
    "PlaybackIntervalMs": 500,
    "MaxAlertDisplay": 50,
    "DataImportBatchSize": 100
  },
  "Security": {
    "PasswordMinLength": 8,
    "RequireUppercase": true,
    "RequireDigit": true,
    "RequireSpecialChar": true,
    "SessionTimeoutMinutes": 60
  },
  "Performance": {
    "EnableCaching": true,
    "CacheDurationMinutes": 5,
    "MaxConcurrentImports": 3
  }
}
```

## Metrics and Alerts

### Calculated Metrics

**Peak Pressure Index**
- Maximum pressure in contiguous regions > 10 pixels
- Flood-fill algorithm for region detection
- Alert threshold: 150+ units

**Contact Area Percentage**
- Percentage of active sensors (pressure > 20)
- Indicates weight distribution quality
- Low values may indicate positioning issues

**Risk Index**
- Composite score (0-10 scale)
- Based on pressure levels, contact area, and trends
- Higher values indicate increased risk

### Alert Types

| Type | Trigger | Severity |
|------|---------|----------|
| HighPressure | Peak > 150 | High/Critical |
| ExtendedPressure | Sustained high pressure | Medium/High |
| LowContactArea | Contact < 50% | Low/Medium |
| PressureSpike | Sudden increase | Medium |

## Troubleshooting

### Database Connection Errors

```
Error: Cannot connect to database
Solution: 
1. Verify SQL Server service is running
2. Check connection string in appsettings.json
3. Ensure Windows Authentication or SQL Auth is configured
4. Verify firewall allows SQL Server port (default: 1433)
```

### Login Issues

```
Error: Invalid credentials
Solution:
1. Verify username and password
2. Check user IsActive status in database
3. Review Logs folder for authentication errors
4. Use admin account to reset user password
```

### Data Import Failures

```
Error: CSV import failed
Solution:
1. Verify CSV format (32 columns per row)
2. Check filename format: {userId}_{YYYYMMDD}.csv
3. Ensure user exists in Users table
4. Verify file encoding (UTF-8 recommended)
```

## Development Guide

### Adding New Features

1. **Create Model** (if needed) in `Models/`
2. **Update DbContext** in `Data/SensoreDbContext.cs`
3. **Create Service** in `Services/`
4. **Add ViewModel** in `ViewModels/`
5. **Design View** in `Views/`
6. **Update Documentation**

### Code Standards

- Follow C# naming conventions
- Use async/await for I/O operations
- Add XML documentation to public APIs
- Implement proper error handling
- Write unit tests for business logic
- Use dependency injection where appropriate

### Testing

```bash
# Run all tests
dotnet test

# Run with coverage
dotnet test /p:CollectCoverage=true
```

## License

**Proprietary Software**  
 2024 Graphene Trace Ltd. All rights reserved.

This software is proprietary and confidential. Unauthorized copying, distribution, or use is strictly prohibited.

## Support

**Technical Support**  
Email: support@graphenetrace.com  
Location: Chelmsford, United Kingdom

**Business Inquiries**  
Website: www.graphenetrace.com

---

**Version**: 2.0.0  
**Last Updated**: November 2024  
**Maintained by**: Graphene Trace Development Team
