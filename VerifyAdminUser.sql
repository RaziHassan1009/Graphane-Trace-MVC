-- Verify Admin User Status
-- Database: Grephene
-- Server: MUZAMIL-WORLD\SQLEXPRESS

USE Grephene;
GO

-- Check if database exists
PRINT '===========================================';
PRINT 'Checking Admin User Status';
PRINT '===========================================';
PRINT '';

-- Check admin user
IF EXISTS (SELECT 1 FROM Users WHERE Username = 'admin')
BEGIN
    PRINT '✓ Admin user EXISTS';
    PRINT '';
    
    SELECT 
        'Admin User Details' as Info,
        UserId,
        Username, 
        UserType, 
        IsActive,
        LEN(PasswordHash) as PasswordHashLength,
        LEFT(PasswordHash, 20) + '...' as PasswordHashPreview,
        FirstName,
        LastName,
        Email,
        CreatedDate,
        LastLoginDate
    FROM Users 
    WHERE Username = 'admin';
    
    -- Check if active
    DECLARE @IsActive BIT;
    SELECT @IsActive = IsActive FROM Users WHERE Username = 'admin';
    
    IF @IsActive = 1
        PRINT '✓ Admin user is ACTIVE';
    ELSE
        PRINT '✗ Admin user is INACTIVE';
        
    -- Check password hash length (BCrypt should be 60 chars)
    DECLARE @HashLength INT;
    SELECT @HashLength = LEN(PasswordHash) FROM Users WHERE Username = 'admin';
    
    IF @HashLength = 60
        PRINT '✓ Password hash length is correct (60 chars)';
    ELSE
        PRINT '✗ Password hash length is INCORRECT (' + CAST(@HashLength AS VARCHAR) + ' chars)';
        
END
ELSE
BEGIN
    PRINT '✗ Admin user DOES NOT EXIST!';
    PRINT '';
    PRINT 'Showing all users:';
    SELECT Username, UserType, IsActive FROM Users;
END

PRINT '';
PRINT '===========================================';
GO
