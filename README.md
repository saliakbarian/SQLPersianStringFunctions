# SQLPersianStringFunctions
Useful T-SQL Functions for handling Persian Strings
<p dir='rtl' align='right'>
توابع مفید به زبان T-SQL برای کار کردن با رشته‌ها به زبان فارسی
</p>

## fn_PrunePersianString
<p dir='rtl' align='right'>
  این تابع یک رشته فارسی را هرس می‌کند تا بتوان آن را با رشته مشابه دیگر مقایسه نمود.
</p>
<p dir='rtl' align='right'>
  عملکرد این تابع:
  <ul dir='rtl' align='right'>
    <li>حذف تمامی کاراکترها از رشته به جز حروف و ارقام فارسی، عربی و انگلیسی</li>
    <li>یکسان سازی کاراکترهای فارسی و عربی مشابه به فرم اصلی فارسی آن مانند «ک» و «ك»</li>
    <li>یکسان سازی کاراکترهای فارسی و عربی تقریباً مشابه مانند «آ» و «ا»</li>
    <li>یکسان سازی کاراکترهای رقمی از زبان فارسی و عربی به زبان انگلیسی</li>
  </ul>
</p>

## fn_StandardizePersianString
<p dir='rtl' align='right'>
این تابع یک رشته فارسی را به فرم استاندارد در می‌آورد تا بتوان آن را به شکل مناسبی نمایش داد.
</p>
<p dir='rtl' align='right'>
  عملکرد این تابع:
  <ul dir='rtl' align='right'>
    <li>تبدیل تمامی کاراکترهای جداکننده مانند فاصله، تب،... که پشت سر هم آمده باشند به یک کاراکتر فاصله ساده</li>
    <li>یکسان سازی کاراکترهای فارسی و عربی مشابه به فرم اصلی فارسی آن مانند «ک»، «ی» و «ه»</li>
    <li>یکسان سازی کاراکترهای رقمی از زبان انگلیسی و عربی به زبان فارسی</li>
  </ul>
</p>

## Samples
```
SELECT dbo.fn_StandardizePersianString(N'آتش            بس 2',default)
-- Output: آتش بس ۲
SELECT 'Same' WHERE dbo.fn_PrunePersianString(N'علی آباد',default)=dbo.fn_PrunePersianString(N'- علیاباد -',default)
-- Output: Same
```

