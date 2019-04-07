-- Author: Saeed Aliakbarian
-- Created: 2018-05-09 (1397-02-19)
-- Last Update: 2019-04-07 (1398-01-18)
-- This function removes all spaces, tabs and other extra characters except for English, Persian and Arabic characters.
-- + It also unifies different types of letters such as Aleft, Kaf & Ye to a standard one.
-- + It also unifies Persian and Arabic numeric digits to English numeric digits.
-- + The function result will be at most MaxLen characters long. If the limit is reached, function will stop and return the result.
-- The result is best used for comparing Persian strings where above differences are to be ignored
-- For standardizing Persian strings, i.e. keeping them proper for displaying, use fn_StandardizePersianString function.
CREATE FUNCTION [dbo].[fn_PrunePersianString]
(
	@Input NVARCHAR(MAX),
	@MaxLen INT=50
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	IF @Input IS NULL
		RETURN NULL

	DECLARE @i INT
	DECLARE @Output NVARCHAR(MAX)=N''
	DECLARE @C NVARCHAR(1)
	DECLARE @UC INT
	DECLARE @InputLen INT
	DECLARE @OutputLen INT=0

	SET @InputLen=LEN(@Input)
	SET @i=0
	WHILE @i<@InputLen AND @OutputLen<@MaxLen 
	BEGIN
		SET @i=@i+1
		SET @C=SUBSTRING(@Input,@i,1)
		SET @UC=UNICODE(@C)
		IF @UC IN (
				0x060C, -- Arabic Comma
				0x061B, -- Arabic Semicolon
				0x061F, -- Arabic Question Mark
				0x0621, -- Arabic Hamza (ء)
				0x0640, -- Arabic Tatweel (ـ)
				0x064B, -- Arabic FATHATAN
				0x064C, -- Arabic DAMMATAN
				0x064D, -- Arabic KASRATAN
				0x064E, -- Arabic FATHA
				0x064F, -- Arabic DAMMA
				0x0650, -- Arabic KASRA
				0x0651, -- Arabic SHADDA
				0x0652, -- Arabic SUKUN
				0x0653, -- Persian Mad
				0x0654, -- Persian Hamza Bala
				0x0655, -- Persian Hamza Paein
				0x066A, -- Persian Percent
				0x066B, -- Persian Momayez
				0x066C, -- Persian 1000 Separator
				0x0670, -- Alef Maghsooreh
				0x06C0 -- Ordoo Hamza Heh
				)
			CONTINUE
		ELSE IF @UC BETWEEN 0x06F0 AND 0x6F9 -- Arabic Digits
			SET @C=NCHAR(@UC-1728) -- English Digits
		ELSE IF @UC BETWEEN 0x0660 AND 0x669 -- Persian Digits
			SET @C=NCHAR(@UC-1584) -- English Digits
		ELSE IF @UC IN (0x0622,0x0623,0x0625, 0x0671)
			SET @C=NCHAR(0x0627) -- Simple ا (Alef)
		ELSE IF @UC IN (0x0620,0x0626,0x0649,0x064A,0x06D2)
			SET @C=NCHAR(0x06CC) -- Persian ی
		ELSE IF @UC IN (0x0643)
			SET @C=NCHAR(0x06A9) -- Persian ک
		ELSE IF @UC IN (0x06BE, 0x06C1, 0x0629)
			SET @C=NCHAR(0x0647) -- Simple ه
		ELSE IF @UC IN (0x0624)
			SET @C=NCHAR(0x0648) -- Simple و
		ELSE IF @UC NOT BETWEEN 0x0622 AND 0x06F9 -- All Persian and Arabic Letters
				AND @UC NOT BETWEEN 0x41 AND 0x5A -- English Capital Letters
				AND @UC NOT BETWEEN 0x61 AND 0x7A -- English Non-Capital Letters
				AND @UC NOT BETWEEN 0x30 AND 0x39 -- English Digits
			CONTINUE
		SET @Output=@Output+@C
		SET @OutputLen=@OutputLen+1
	END

	RETURN @Output
END
