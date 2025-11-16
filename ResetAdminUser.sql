-- =========================================================
-- Reset Admin User Script
-- Database: Grephene
-- Server: MUZAMIL-WORLD\SQLEXPRESS
-- =========================================================
-- This script will delete and recreate the admin user.
-- After running this, the application will automatically
-- set the correct password hash on next startup.
-- =========================================================

USE Grephene;
GO

-- Step 1: Remove existing admin user if exists
PRINT 'Removing existing admin user...';
DELETE FROM Users WHERE Username = 'admin';
GO

-- Step 2: The application will automatically create admin user on next startup
-- with username: admin and password: Admin@123
PRINT 'Admin user removed. The application will recreate it on next startup.';
PRINT '';
PRINT 'Next steps:';
PRINT '1. Start the GrapheneSensore application';
PRINT '2. The app will automatically create admin user';
PRINT '3. Login with:';
PRINT '   Username: admin';
PRINT '   Password: Admin@123';
GO
