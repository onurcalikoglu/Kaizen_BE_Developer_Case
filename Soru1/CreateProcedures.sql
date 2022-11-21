-- =============================================
-- Author:		Onur ÇALIKOÐLU
-- Create date: 18.11.2022
-- Description:	Kodlar bir önceki üretilen karaktere baðlý olarak belirlenen algoritma
--              ile üretilmiþtir.

-- ALGORÝTMA KURALLAR

-- Kural 1 - Önceki index 1 ise 10 ile 20 arasýnda rastgele bir index belirlenir.
-- Kural 2 - Önceki index 23 ise 5 ile 15 arasýnda rastgele bir index belirlenir.
-- Kural 3 - Önceki index tek ise önceki indexten küçük rastgele bir index belirlenir.
-- Kural 4 - Önceki index çift ise önceki indexten büyük rastgele bir index belirlenir.

-- 1 - Kodun ilk karakteri rastgele bir index deðeri belirlenir ve @Chars dizisindeki karþýlýðý @code deðiþkenine eklenir.
-- 2 - Her kod bir önceki kodun index deðerine baðlý olarak yukarýdaki kurallarla belirlenir ve @Chars dizisindeki karþýlýðý olan deðer @code deðiþkenine eklenir.
-- 3 - Kurallar ile ilk 7 karakter oluþturulduktan sonra ilk 7 karakterin index toplamýnýn @sunTotal deðiþenine atanýr.
-- 4 - @sunTotal deðerinin 23 ile modunun 1 fazlasýna karþýlýk gelen deðer @lastCharIndex deðiþkenine atanýr.
-- 5 - kodun son karakteri için @lastCharIndex deðerinin @Chars dizisindeki karþýlýðý @code deðiþkenine eklenir.

-- NOT : @Chars dizisinde istenen karakterler tahmin edilebilirliði önlemek için karmaþýk þekilde sýralanmýþtýr.
-- =============================================
IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'OnurCALIKOGLU')
BEGIN
    CREATE DATABASE OnurCALIKOGLU
END
GO

USE [OnurCALIKOGLU]
GO

CREATE procedure [dbo].[generate_codes]
as
begin
	DECLARE @cnt INT = 0;
	
	DECLARE @Codes TABLE (code varchar(8))
	DECLARE @Chars TABLE (id INT , char varchar(1))
	
	insert into @Chars values
			(1,'A'),(7,'C'),(12,'D'),(19,'E'),
			(2,'F'),(8,'G'),(14,'H'),(20,'K'),
			(3,'L'),(9,'M'),(15,'N'),(21,'P'),
			(4,'R'),(10,'T'),(16,'X'),(22,'Y'),
			(5,'Z'),(11,'2'),(17,'3'),(23,'4'),
			(6,'5'),(12,'7'),(18,'9');
	
	WHILE @cnt < 1000
	BEGIN
		DECLARE @beforeIndex int = 0;
		DECLARE @subTotal int = 0;
		SET @beforeIndex = ABS(CHECKSUM(NEWID()) % 23) + 1

		DECLARE @code varchar(8)= '';
		SET @code = CONCAT(@code,(select top 1 char from @Chars where id = @beforeIndex))
		SET @subTotal = @subTotal + @beforeIndex;
		DECLARE @selectedIndex int = 0;
		DECLARE @index int = 0;
		WHILE @index < 6
	   	BEGIN
		    IF (@beforeIndex = 1)
			BEGIN
				SET @beforeIndex = ABS(CHECKSUM(NEWID()) % 10) + 10
			END
			ELSE IF (@beforeIndex = 23)
			BEGIN
				SET @beforeIndex = ABS(CHECKSUM(NEWID()) % 10) + 5
			END
			ELSE IF (@beforeIndex % 2 = 1)
			BEGIN
				SET @beforeIndex = ABS(CHECKSUM(NEWID()) % (@beforeIndex - 1)) + 1
			END
			ELSE
			BEGIN
				SET @beforeIndex = ABS(CHECKSUM(NEWID()) % (23 - @beforeIndex)) + @beforeIndex + 1
			END

			SET @subTotal = @subTotal + @beforeIndex;
			SET @code = CONCAT(@code,(select top 1 char from @Chars where id = @beforeIndex))
			SET @index = @index + 1;
		END

		DECLARE @lastCharIndex int = (@subTotal % 23) + 1 
		SET @code = CONCAT(@code,(select top 1 char from @Chars where id = @lastCharIndex))

		IF ((Select Count(code) from @Codes where code = @code) = 0) and DATALENGTH(@code) = 8 
		BEGIN
			Insert into @Codes values(@code)
			SET @cnt = @cnt + 1;
		END
	END;
	
	select * from @Codes
end
GO



-- =============================================
-- Author:		Onur ÇALIKOÐLU
-- Create date: 18.11.2022
-- Description:	Üretilen kodlarýn doðruluðunu kontrol etmek için
--              Üretim safhasýndaki iþlemlerin adým adým kontrolü gerçekleþtirilmektedir.
--              IsValid = 1 deðeri kod geçerli anlamýna gelmektedir.
-- =============================================
CREATE PROCEDURE [dbo].[check_code] 
	@Code varchar(8),
	@IsValid int out
AS
BEGIN
	DECLARE @Chars TABLE (id INT , char varchar(1))
	Insert into @Chars values
			(1,'A'),(7,'C'),(12,'D'),(19,'E'),
			(2,'F'),(8,'G'),(14,'H'),(20,'K'),
			(3,'L'),(9,'M'),(15,'N'),(21,'P'),
			(4,'R'),(10,'T'),(16,'X'),(22,'Y'),
			(5,'Z'),(11,'2'),(17,'3'),(23,'4'),
			(6,'5'),(12,'7'),(18,'9');

	DECLARE @value varchar(1) = SUBSTRING(@Code,1,1);
	DECLARE @beforeIndex INT = (Select top 1 id from @Chars where char = @value);
	DECLARE @selectedIndex INT;
	DECLARE @index INT = 2;
	DECLARE @subTotal INT = 0;
	
	SET @subTotal = @subTotal + @beforeIndex
	SET @IsValid = 1
	WHILE @index < 8
	BEGIN
		SET @value = SUBSTRING(@Code,@index,1);

		IF (Select COUNT(id) from @Chars where char = @value) = 0
		BEGIN
			SET @IsValid = 0;
		END

		SET @selectedIndex = (Select top 1 id from @Chars where char = @value)
		
		IF (@beforeIndex = 1 AND ((10 > @selectedIndex) OR (20 < @selectedIndex)))
		BEGIN
			SET @IsValid = 0;
		END
		ELSE IF (@beforeIndex = 23 AND ((5 > @selectedIndex) OR (15 < @selectedIndex)))
		BEGIN
			SET @IsValid = 0;
		END
		ELSE IF (((@beforeIndex % 2) = 1) AND (@beforeIndex <= @selectedIndex) AND 1 != @beforeIndex AND @beforeIndex != 23)
		BEGIN
			SET @IsValid = 0;
		END
		ELSE IF (((@beforeIndex % 2) = 0) AND (@beforeIndex >= @selectedIndex))
		BEGIN
			SET @IsValid = 0;
		END

		SET @index = @index + 1;
		SET @subTotal = @subTotal + @selectedIndex;
		SET @beforeIndex = @selectedIndex;
		
	END

	DECLARE @lastChar varchar(1) = SUBSTRING(@Code,8,1);
	DECLARE @lastCharIndex INT = (Select top 1 id from @Chars where char = @lastChar);
	DECLARE @controlIndex INT = ((@subTotal % 23) + 1);

	IF (@lastCharIndex != @controlIndex)
	BEGIN
		SET @IsValid = 0;
	END

	SELECT 'IsValid' = @IsValid;
END
GO

