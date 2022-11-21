USE [OnurCALIKOGLU]
GO

DECLARE @RC int

-- IsValid = 1 => Kod Doðru
-- IsValid = 0 => Kod Yanlýþ

-- @Code deðiþkenine kontrol edilecek kod atanarak doðruluðu kontrol edilir.
DECLARE @Code varchar(8) = 'HK4CFGD9'
DECLARE @IsValid int

EXECUTE @RC = [dbo].[check_code] 
   @Code
  ,@IsValid OUTPUT
GO


