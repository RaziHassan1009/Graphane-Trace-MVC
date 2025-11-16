# Quick Fix Guide - Graphene Sensore

## Common Issues and Solutions

### 1. Database Connection Errors

**Problem**: "Cannot connect to database" or "Login failed for user"

**Solution**:
1. Verify SQL Server is running:
   ```powershell
   Get-Service -Name "MSSQL$SQLEXPRESS" | Select-Object Status
   ```

2. If stopped, start it:
   ```powershell
   Start-Service -Name "MSSQL$SQLEXPRESS"
   ```

3. Check connection string in `GrapheneSensore\appsettings.json`:
   ```json
   "ConnectionStrings": {
     "DefaultConnection": "Server=MUZAMIL-WORLD\\SQLEXPRESS;Database=Grephene;Trusted_Connection=True;TrustServerCertificate=True;MultipleActiveResultSets=true;Connection Timeout=30;"
   }
   ```

4. Update the server name if different:
   - Open SQL Server Management Studio (SSMS)
   - Check the server name in the connection dialog
   - Update appsettings.json with correct server name

### 2. Build Errors

**Problem**: "Could not load file or assembly" or NuGet package errors

**Solution**:
1. Clean and restore packages:
   ```powershell
   cd GrapheneSensore
   dotnet clean
   dotnet restore
   dotnet build
   ```

2. If still failing, delete bin and obj folders:
   ```powershell
   Remove-Item -Recurse -Force .\bin, .\obj
   dotnet restore
   dotnet build
   ```

### 3. Login Issues

**Problem**: Cannot login with admin/Admin@123

**Solution**:
1. Reset admin password using the utility:
   ```powershell
   cd ResetAdminPassword
   dotnet run
   ```

2. Or run SQL directly:
   ```sql
   USE Grephene;
   DELETE FROM Users WHERE Username = 'admin';
   -- Then restart the application to recreate admin user
   ```

### 4. Application Crashes on Startup

**Problem**: Application closes immediately or shows error dialog

**Solution**:
1. Check the logs:
   - Open `GrapheneSensore\bin\Release\net6.0-windows\Logs\`
   - View the most recent log file

2. Common causes:
   - Missing database: Run `setup-database.bat`
   - Wrong .NET version: Ensure .NET 6.0 is installed
   - Missing dependencies: Run `dotnet restore`

### 5. Heat Map Not Displaying

**Problem**: Heat map shows "No Data Available"

**Solution**:
1. Import sample data:
   - Login as admin
   - Create a patient user
   - Use "Import Data" button
   - Select CSV file from `Dataset\GTLB-Data\` folder

2. Verify CSV format:
   - Filename: `{userId}_{YYYYMMDD}.csv`
   - 32 columns per row
   - Values between 0-255

### 6. SQL Server Not Found

**Problem**: "A network-related or instance-specific error"

**Solution**:
1. Enable TCP/IP protocol:
   - Open SQL Server Configuration Manager
   - Navigate to "SQL Server Network Configuration"
   - Enable TCP/IP protocol
   - Restart SQL Server service

2. Check Windows Firewall:
   - Ensure port 1433 is not blocked
   - Or disable firewall temporarily for testing

### 7. Permission Denied Errors

**Problem**: "Cannot create database" or "Permission denied"

**Solution**:
1. Run as Administrator:
   - Right-click on StartApplication.ps1
   - Select "Run with PowerShell as Administrator"

2. Grant SQL permissions:
   - Open SSMS as Administrator
   - Grant your Windows user db_owner role

### 8. Missing LiveCharts or Other NuGet Packages

**Problem**: "The type or namespace name 'LiveCharts' could not be found"

**Solution**:
```powershell
cd GrapheneSensore
dotnet add package LiveCharts.Wpf --version 0.9.7
dotnet add package Microsoft.EntityFrameworkCore.SqlServer --version 7.0.0
dotnet restore
```

## Performance Tips

### Optimize Database Queries
- Regularly clean old log files (keep last 30 days)
- Archive old pressure data (keep last 6 months)
- Run database maintenance:
  ```sql
  USE Grephene;
  EXEC sp_updatestats;
  ALTER INDEX ALL ON PressureMapData REBUILD;
  ```

### Reduce Memory Usage
- Adjust batch size in appsettings.json:
  ```json
  "DataImportBatchSize": 50  // Lower if running out of memory
  ```

### Improve UI Responsiveness
- Reduce chart update frequency
- Limit displayed alerts to recent 50
- Use date filters to load less data

## Validation Checklist

Before reporting an issue, verify:
- [ ] SQL Server Express is installed and running
- [ ] .NET 6.0 SDK is installed
- [ ] Connection string is correct
- [ ] Database 'Grephene' exists
- [ ] Admin user exists and is active
- [ ] No antivirus blocking the application
- [ ] Windows is up to date
- [ ] Sufficient disk space (>2GB free)
- [ ] Sufficient RAM (>4GB free)

## Getting Help

If issues persist:
1. Check log files in `GrapheneSensore\bin\[Debug|Release]\net6.0-windows\Logs\`
2. Review the TROUBLESHOOTING_GUIDE.md
3. Ensure all prerequisites are met
4. Try running on a clean Windows installation

## Quick Commands Reference

```powershell
# Check SQL Server status
Get-Service -Name "MSSQL$SQLEXPRESS"

# Start SQL Server
Start-Service -Name "MSSQL$SQLEXPRESS"

# Check .NET version
dotnet --version

# Clean build
cd GrapheneSensore
dotnet clean
dotnet restore
dotnet build --configuration Release

# Run application
dotnet run --configuration Release

# Reset database (WARNING: Deletes all data)
sqlcmd -S "MUZAMIL-WORLD\SQLEXPRESS" -i Database\CreateDatabase.sql -E

# View logs
Get-Content .\GrapheneSensore\bin\Release\net6.0-windows\Logs\graphene-sensore-*.log -Tail 50
```

## Emergency Recovery

If everything fails:
1. Backup your CSV data files
2. Drop and recreate database:
   ```sql
   USE master;
   DROP DATABASE Grephene;
   ```
3. Run `setup-database.bat`
4. Restart application
5. Re-import data

---
Last Updated: November 15, 2025
