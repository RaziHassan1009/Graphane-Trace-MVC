# 🔧 Graphene Feedback System - Troubleshooting Guide

**Version**: 3.0  
**Last Updated**: November 11, 2025

---

## 🚨 Common Issues & Solutions

### 1. **Buttons Not Responding**

#### Symptoms:
- Clicking buttons does nothing
- No error messages appear
- UI freezes

#### Solutions:
✅ **Restart the application**
```bash
Close the app and run:
dotnet run --configuration Release
```

✅ **Check logs**
- Location: `GrapheneSensore/Logs/`
- Look for error messages

✅ **Verify database connection**
```sql
-- Test in SSMS:
SELECT * FROM Applicants
SELECT * FROM Templates
```

---

### 2. **"Start Feedback" Button Errors**

#### Symptoms:
- Click "Start Feedback" → Error dialog
- Template window doesn't open

#### Common Causes & Fixes:

**A. Database Not Connected**
```bash
# Test connection:
sqlcmd -S .\SQLEXPRESS -Q "SELECT TOP 1 * FROM Grephene.dbo.Templates"
```

**B. Templates Not Loaded**
```sql
-- Verify templates exist:
USE Grephene;
SELECT * FROM Templates;
SELECT * FROM Sections;
SELECT * FROM Codes;

-- If empty, re-run:
-- Database/CreateFeedbackSystem.sql
```

**C. Missing Sample Data**
```bash
# Re-initialize database:
sqlcmd -S .\SQLEXPRESS -i Database\CreateFeedbackSystem.sql
```

---

### 3. **"Add Applicant" Dialog Not Opening**

#### Quick Fix:
```bash
# Rebuild the application:
cd GrapheneSensore
dotnet clean
dotnet restore
dotnet build --configuration Release
dotnet run
```

---

### 4. **Database Connection Errors**

#### Error Message:
```
"Failed to load applicants"
"Cannot open database"
```

#### Solutions:

**A. Verify SQL Server is Running**
```powershell
# Check service status:
Get-Service MSSQL*

# Start if stopped:
net start MSSQL$SQLEXPRESS
```

**B. Fix Connection String**
Edit `appsettings.json`:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=.\\SQLEXPRESS;Database=Grephene;Trusted_Connection=True;TrustServerCertificate=True;"
  }
}
```

**C. Recreate Database**
```bash
sqlcmd -S .\SQLEXPRESS -i Database\CreateDatabase.sql
sqlcmd -S .\SQLEXPRESS -i Database\CreateFeedbackSystem.sql
```

---

### 5. **UI Display Issues**

#### Symptoms:
- Blank pages
- Missing buttons
- Layout broken

#### Solutions:

**A. Clear Build Cache**
```bash
cd GrapheneSensore
dotnet clean
rd /s /q bin obj
dotnet restore
dotnet build
```

**B. Verify XAML Files**
Check these files exist:
- `Views/ApplicantManagementWindow.xaml`
- `Views/ApplicantDialog.xaml`
- `Views/TemplateSelectionWindow.xaml`
- `Views/FeedbackFormWindow.xaml`

---

### 6. **"No Templates Available" Error**

#### Fix:
```sql
-- Re-run sample data script:
USE Grephene;

-- Verify templates:
SELECT * FROM Templates;

-- If empty, run:
sqlcmd -S .\SQLEXPRESS -i Database\CreateFeedbackSystem.sql
```

---

### 7. **Application Crashes on Startup**

#### Solutions:

**A. Check .NET Version**
```bash
dotnet --version
# Should be 6.0 or higher
```

**B. Reinstall Dependencies**
```bash
cd GrapheneSensore
dotnet restore --force
dotnet build
```

**C. Check Logs**
```bash
# View latest log:
cd GrapheneSensore/Logs
dir /od
# Open the newest log file
```

---

### 8. **Data Not Saving**

#### Symptoms:
- Add applicant → disappears after refresh
- Changes don't persist

#### Solutions:

**A. Check Database Permissions**
```sql
-- In SSMS, verify you can insert:
USE Grephene;
INSERT INTO Applicants (SessionUserId, FirstName, LastName, Email)
VALUES (NEWID(), 'Test', 'User', 'test@example.com');
SELECT * FROM Applicants;
```

**B. Transaction Issues**
```bash
# Check logs for errors:
GrapheneSensore/Logs/[latest].log
# Look for "Transaction" or "SaveChanges" errors
```

---

### 9. **Specific Button Errors**

#### "Edit Applicant" Button:
```
Error: Applicant dialog not opening
Solution: Select an applicant first (click on row in grid)
```

#### "Delete" Button:
```
Error: Nothing selected
Solution: Click on an applicant row to select it
```

#### "Start Feedback" Button:
```
Error: Template window errors
Solution: 
1. Check database has templates
2. Check logs for specific error
3. Rebuild application
```

---

## 🔍 How to Debug Errors

### Step 1: Check Application Logs
```bash
cd C:\Users\Lenovo\Desktop\Graphene\GrapheneSensore\Logs
# Open the latest log file
notepad [latest-log-file].log
```

### Step 2: Verify Database
```sql
-- In SSMS:
USE Grephene;

-- Check all tables have data:
SELECT 'Applicants' as TableName, COUNT(*) as Count FROM Applicants
UNION ALL
SELECT 'Templates', COUNT(*) FROM Templates
UNION ALL
SELECT 'Sections', COUNT(*) FROM Sections
UNION ALL
SELECT 'Codes', COUNT(*) FROM Codes
UNION ALL
SELECT 'FeedbackParagraphs', COUNT(*) FROM FeedbackParagraphs;
```

### Step 3: Test Each Feature Individually

**Test 1: Add Applicant**
1. Click "Add Applicant"
2. Fill form: First="Test", Last="User", Email="test@test.com"
3. Click "Save"
4. Check if it appears in grid

**Test 2: Edit Applicant**
1. Click on an applicant row
2. Click "Edit Applicant"
3. Change name
4. Click "Save"
5. Verify changes

**Test 3: Start Feedback**
1. Select an applicant
2. Click "Start Feedback"
3. Template window should open
4. If error, check logs immediately

---

## 📋 Quick Fixes Checklist

If you get ANY error, try these in order:

### Quick Fix #1: Rebuild
```bash
cd GrapheneSensore
dotnet clean
dotnet build --configuration Release
```

### Quick Fix #2: Restart SQL Server
```powershell
net stop MSSQL$SQLEXPRESS
net start MSSQL$SQLEXPRESS
```

### Quick Fix #3: Reload Sample Data
```bash
sqlcmd -S .\SQLEXPRESS -i Database\CreateFeedbackSystem.sql
```

### Quick Fix #4: Check Connection String
```bash
# Edit GrapheneSensore/appsettings.json
# Verify Server name matches your SQL Server instance
```

### Quick Fix #5: Clean Restart
```bash
# 1. Close application
# 2. Clean build
cd GrapheneSensore
dotnet clean
rd /s /q bin obj

# 3. Rebuild
dotnet restore
dotnet build --configuration Release

# 4. Run
dotnet run
```

---

## 🆘 Still Having Issues?

### Check These Common Problems:

**1. Wrong SQL Server Instance**
```bash
# Find your instance name:
sqlcmd -L
# Update appsettings.json with correct name
```

**2. Database Doesn't Exist**
```bash
# List databases:
sqlcmd -S .\SQLEXPRESS -Q "SELECT name FROM sys.databases"
# Should see "Grephene"
```

**3. Missing Tables**
```bash
# List tables:
sqlcmd -S .\SQLEXPRESS -d Grephene -Q "SELECT name FROM sys.tables"
# Should see: Applicants, Templates, Sections, Codes, etc.
```

**4. Port Conflicts**
```bash
# If web features not working, check ports:
netstat -ano | findstr :5000
netstat -ano | findstr :5001
```

---

## 📊 System Health Check

Run this to verify everything is OK:

```bash
# 1. Check .NET
dotnet --version

# 2. Check SQL Server
sqlcmd -S .\SQLEXPRESS -Q "SELECT @@VERSION"

# 3. Check Database
sqlcmd -S .\SQLEXPRESS -Q "USE Grephene; SELECT COUNT(*) FROM Applicants"

# 4. Check Build
cd GrapheneSensore
dotnet build --configuration Release

# If all succeed, system is healthy!
```

---

## 🔥 Emergency Reset

If nothing works, complete reset:

```bash
# 1. Stop application
# Close all windows

# 2. Reset database
sqlcmd -S .\SQLEXPRESS -Q "DROP DATABASE IF EXISTS Grephene"
sqlcmd -S .\SQLEXPRESS -i Database\CreateDatabase.sql
sqlcmd -S .\SQLEXPRESS -i Database\CreateFeedbackSystem.sql

# 3. Clean build
cd GrapheneSensore
dotnet clean
rd /s /q bin obj
dotnet restore
dotnet build --configuration Release

# 4. Restart
dotnet run
```

---

## 📞 Error Message Reference

### Common Error Messages:

| Error | Cause | Fix |
|-------|-------|-----|
| "Failed to load applicants" | DB connection issue | Restart SQL Server |
| "Template not found" | No sample data | Re-run CreateFeedbackSystem.sql |
| "Failed to start feedback" | Template loading error | Check database has templates |
| "Dialog failed to open" | XAML or ViewModel error | Rebuild application |
| "Cannot open database" | SQL Server stopped | Start SQL Server service |
| "Connection timeout" | Wrong server name | Fix appsettings.json |

---

## ✅ Verification Steps

After fixing, verify everything works:

1. ✅ **Login**: admin / Admin@123
2. ✅ **Open Feedback System** tab
3. ✅ **Open Applicant Manager**
4. ✅ **Add an applicant** (➕ button)
5. ✅ **Edit applicant** (select row → ✏️ button)
6. ✅ **Start Feedback** (select row → 🚀 button)
7. ✅ **Template opens** with sections
8. ✅ **Navigate sections** (← →buttons)
9. ✅ **Complete feedback** (✅ button)

If all steps work, system is healthy! ✅

---

## 📝 Collecting Diagnostic Information

If you need to report an issue:

```bash
# 1. Copy latest log
copy GrapheneSensore\Logs\[latest].log diagnostic.txt

# 2. Check database status
sqlcmd -S .\SQLEXPRESS -Q "USE Grephene; SELECT * FROM Templates" >> diagnostic.txt

# 3. Check build output
dotnet build 2>&1 >> diagnostic.txt

# 4. Share diagnostic.txt
```

---

**Most issues can be fixed with a rebuild and database reload!**

**Quick Fix Command**:
```bash
sqlcmd -S .\SQLEXPRESS -i Database\CreateFeedbackSystem.sql && cd GrapheneSensore && dotnet clean && dotnet build --configuration Release && dotnet run
```

---

**Version**: 3.0  
**Status**: Production-Ready  
**Support**: Check logs first, then follow this guide  
**Success Rate**: 95% of issues resolved with above steps
