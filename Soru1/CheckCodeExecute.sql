USE [OnurCALIKOGLU]
GO

DECLARE @RC int

-- IsValid = 1 => Kod Do�ru
-- IsValid = 0 => Kod Yanl��

-- @Code de�i�kenine kontrol edilecek kod atanarak do�rulu�u kontrol edilir.
DECLARE @Code varchar(8) = 'HK4CFGD9'
DECLARE @IsValid int

EXECUTE @RC = [dbo].[check_code] 
   @Code
  ,@IsValid OUTPUT
GO


