# Quick Start Guide

## For Developers - Get Running in 5 Minutes

### Prerequisites Check
```powershell
# Check .NET version
dotnet --version  # Should be 6.0 or higher

# Check SQL Server
Get-Service MSSQL*  # Should show running
```

### Step 1: Database Setup (2 minutes)
```sql
-- Open SQL Server Management Studio (SSMS)
-- Connect to your SQL Server instance
-- Execute: Database/CreateDatabase.sql
-- Verify: Database 'Grephene' appears in Object Explorer
```

### Step 2: Configure Connection (1 minute)
Edit `GrapheneSensore/appsettings.json`:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=YOUR_SERVER_NAME;Database=Grephene;Trusted_Connection=True;TrustServerCertificate=True;"
  }
}
```

Replace `YOUR_SERVER_NAME` with your SQL Server instance name.

### Step 3: Build & Run (2 minutes)
```powershell
cd GrapheneSensore
dotnet restore
dotnet build
dotnet run
```

### Step 4: Login
```
Username: admin
Password: Admin@123
```

⚠️ **IMPORTANT**: Change the admin password immediately after first login!

---

## Common Issues & Solutions

### Issue: "Cannot connect to database"
**Solution**:
```powershell
# 1. Check SQL Server is running
Get-Service MSSQL* | Start-Service

# 2. Verify connection string
# Check Server name in SSMS: Right-click server → Properties → View connection properties
```

### Issue: "Login failed"
**Solution**:
- Verify username: `admin` (lowercase)
- Verify password: `Admin@123` (case-sensitive)
- Check Logs folder for authentication errors

### Issue: "Build failed"
**Solution**:
```powershell
# Clean and rebuild
dotnet clean
dotnet restore
dotnet build
```

---

## Project Structure Quick Reference

```
GrapheneSensore/
├── Models/              # Data entities (User, Alert, etc.)
├── Services/            # Business logic (AuthenticationService, UserService, etc.)
├── Views/              # UI windows (LoginWindow, AdminWindow, etc.)
├── ViewModels/         # MVVM view models
├── Data/               # Database context (SensoreDbContext)
├── Helpers/            # Utilities (PasswordHelper, Converters)
├── Logging/            # Logger implementation
└── appsettings.json    # Configuration
```

---

## Key Files to Know

| File | Purpose |
|------|---------|
| `Services/AuthenticationService.cs` | User login, session management |
| `Services/UserService.cs` | User CRUD operations |
| `Data/SensoreDbContext.cs` | Database context and configuration |
| `Helpers/PasswordHelper.cs` | Password hashing and validation |
| `Logging/Logger.cs` | Application logging |
| `appsettings.json` | Application configuration |

---

## Development Workflow

### 1. Making Changes
```powershell
# Create feature branch
git checkout -b feature/your-feature-name

# Make changes
# Build and test
dotnet build
dotnet run

# Commit
git add .
git commit -m "feat: your feature description"
```

### 2. Adding New Features
1. Create model in `Models/` (if needed)
2. Update `SensoreDbContext.cs` (if database changes)
3. Create service in `Services/`
4. Create view model in `ViewModels/`
5. Create view in `Views/`
6. Test thoroughly

### 3. Debugging
```powershell
# Run in debug mode
dotnet run --configuration Debug

# Check logs
cd bin/Debug/net6.0-windows/Logs
# View latest log file
```

---

## Testing Checklist

Before committing code:
- [ ] Code builds without warnings
- [ ] Application starts successfully
- [ ] Login works with admin account
- [ ] No errors in Logs folder
- [ ] XML documentation added to new public methods
- [ ] Code follows naming conventions

---

## Useful Commands

```powershell
# Build
dotnet build

# Run
dotnet run

# Clean
dotnet clean

# Restore packages
dotnet restore

# Build release version
dotnet build --configuration Release

# Publish
dotnet publish --configuration Release --output ./publish
```

---

## Configuration Quick Reference

### Security Settings
```json
"Security": {
  "PasswordMinLength": 8,
  "RequireUppercase": true,
  "RequireDigit": true,
  "RequireSpecialChar": true,
  "SessionTimeoutMinutes": 60
}
```

### Application Settings
```json
"AppSettings": {
  "MatrixSize": 32,
  "PressureThreshold": 150,
  "MinAreaPixels": 10,
  "LowerThreshold": 20
}
```

---

## Need Help?

1. **Documentation**: Read `README.md`
2. **Contributing**: Read `CONTRIBUTING.md`
3. **Changes**: Check `CHANGELOG.md`
4. **Logs**: Check `Logs/` folder
5. **Issues**: Review `PROFESSIONAL_IMPROVEMENTS_SUMMARY.md`

---

## Next Steps

After getting the application running:

1. **Change Admin Password**
   - Login as admin
   - Navigate to settings
   - Change password to something secure

2. **Create Test Users**
   - Create a clinician account
   - Create a patient account
   - Test different user roles

3. **Import Sample Data**
   - Use CSV files from `Dataset/GTLB-Data/`
   - Test data visualization
   - Verify alerts are generated

4. **Explore Features**
   - Heat map visualization
   - Alert system
   - Comment functionality
   - Report generation

---

**Ready to develop?** Read `CONTRIBUTING.md` for detailed guidelines.

**Need more info?** Check `README.md` for comprehensive documentation.
