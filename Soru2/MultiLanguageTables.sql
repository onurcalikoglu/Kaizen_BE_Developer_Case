-- =============================================
-- Author:		Onur ÇALIKOÐLU
-- Create date: 18.11.2022
-- Description:	Dil bazýnda ayýt edici olabilmesi için [LanguageCode] alaný eklendi.
--              Ýhtiyaç duyulan dataya ulaþmak için [LanguageCode] deðiþkeni ile istek yapýlabilir.

-- =============================================
IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'OnurCALIKOGLU')
BEGIN
    CREATE DATABASE OnurCALIKOGLU
END
GO

USE [OnurCALIKOGLU]
GO

CREATE TABLE [dbo].[News](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[LanguageCode] [varchar](2) NOT NULL,
	[Title] [nvarchar](256) NOT NULL,
	[Detail] [nvarchar](max) NOT NULL,
	[ImageUrls] [nvarchar](max) NULL,
	[Category] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_News] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Components](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[LanguageCode] [varchar](2) NOT NULL,
	[Title] [nvarchar](256) NOT NULL,
	[Detail] [nvarchar](max) NULL,
 CONSTRAINT [PK_Components] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


-- Sorgular için gerekli data'lar.

INSERT INTO [dbo].[News]
           ([Name]
           ,[LanguageCode]
           ,[Title]
           ,[Detail]
           ,[ImageUrls]
           ,[Category])
     VALUES
           ('News1','en','en-News1-Title','en-News1-Detail','en-News1-ImgUrl1, en-News1-ImgUrl2,…, en-News1-ImgUrln','Economy'),
           ('News2','en','en-News2-Title','en-News2-Detail','en-News2-ImgUrl1, en-News2-ImgUrl2,…, en-News2-ImgUrln','Education'),
		   ('News1','tr','tr-News1-Baþlýk','tr-News1-Detay','tr-News1-ImgUrl1, tr-News1-ImgUrl2,…, tr-News1-ImgUrln','Ekonomi'),
           ('News2','tr','tr-News2-Baþlýk','tr-News2-Detay','tr-News2-ImgUrl1, tr-News2-ImgUrl2,…, tr-News2-ImgUrln','Eðitim')
GO

INSERT INTO [dbo].[Components]
           ([Name]
           ,[LanguageCode]
           ,[Title]
           ,[Detail])
     VALUES
		   ('LoginButton','en','Login','Using for login.'),
		   ('LoginButton','tr','Giriþ Yap','Oturum açmak için kullanýlýyor.'),
		   ('RegisterButton','en','Register Now','For redirect to register page.'),
		   ('RegisterButton','tr','Kayýt Ol','Kayýt Ol sayfasýna yönlendirme için.')
GO
