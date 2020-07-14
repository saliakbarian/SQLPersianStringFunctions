-- Author: Saeed Aliakbarian
-- Created: 2018-07-22 (1397-04-31)
-- Last Update: 2020-07-14 (1399-04-24)
-- This function converts all consecutive spaces, tabs and other types of spaces into one simple space character.
-- + It also unifies different types of letters such as Aleft, Kaf & Ye to a standard one. 
-- + It also unifies English and Arabic numeric digits to Persian numeric digits.
-- + Any other character will remian untouched.
-- + The function result will be at most MaxLen characters long. If the limit is reached, function will stop and return the result.
-- The result is best used for displaying standard form of a persian string such as persian names.
-- For comparing similar persian strings ignoring spaces and symbols, use fn_PrunePersianString function.
CREATE FUNCTION [dbo].[fn_StandardizePersianString]
(
	@Input NVARCHAR(MAX),
	@MaxLen INT=50
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	IF @Input IS Null
		RETURN NULL
	SET @Input=LTRIM(RTRIM(@Input))

	DECLARE @i INT
	DECLARE @Output NVARCHAR(MAX)=N''
	DECLARE @C NVARCHAR(1)
	DECLARE @LastC NVARCHAR(1)=NULL
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
		IF @UC IN (0x0009,0x000A,0x000B,0x000C,0x000D,0x0020,0x0085,0x00A0,0x1680,0x2000,0x2001
							,0x2002,0x2003,0x2004,0x2005,0x2006,0x2007,0x2008,0x2009,0x200A,0x2028,
							0x2029,0x202F,0x205F,0x3000,0x180E,0x200B,0x200C,0x2060,0xFEFF)
			-- 0x200D -> Nonvisible space => will be removed from the string			
		BEGIN
			IF @LastC IS NULL OR @LastC=' '
				CONTINUE
			SET @C=' '
		END
		ELSE IF @UC BETWEEN 0x0030 AND 0x0039 -- English Digits
			SET @C=NCHAR(@UC+0x06C0) -- Persian Digits
		ELSE IF @UC BETWEEN 0x0660 AND 0x669 -- Arabic Digits
			SET @C=NCHAR(@UC+0x0090) -- Persian Digits
		ELSE IF @UC IN (0x0625, 0x0671)
			SET @C=NCHAR(0x0627) -- Simple ا (Alef)
		ELSE IF @UC IN (0x0620,0x0626,0x0649,0x064A,0x06D2)
			SET @C=NCHAR(0x06CC) -- Persian ی
		ELSE IF @UC IN (0x0643)
			SET @C=NCHAR(0x06A9) -- Persian ک
		ELSE IF @UC IN (0x06BE, 0x06C1, 0x0629)
			SET @C=NCHAR(0x0647) -- Simple ه
		SET @Output+=@C
		SET @LastC=@C
		SET @OutputLen+=1
	END

	RETURN RTRIM(@Output)
END
