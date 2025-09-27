# إعداد خدمة الإيميل

## الخطوات المطلوبة:

### 1. إنشاء حساب Gmail للتطبيق
- أنشئ حساب Gmail جديد مثل: `digitopia.app.2024@gmail.com`
- أو استخدم حسابك الحالي

### 2. تفعيل App Password
1. اذهب إلى [Google Account Settings](https://myaccount.google.com/)
2. اختر "Security" من القائمة الجانبية
3. فعّل "2-Step Verification" إذا لم يكن مفعلاً
4. ابحث عن "App passwords" واضغط عليه
5. اختر "Mail" و "Other (Custom name)"
6. اكتب "Digitopia App" كاسم
7. انسخ كلمة المرور المُنتجة (16 حرف)

### 3. تحديث الكود
في ملف `email_service.dart` السطر 35:
```dart
final smtpServer = gmail('your_email@gmail.com', 'your_16_digit_app_password');
```

استبدل:
- `your_email@gmail.com` بإيميلك
- `your_16_digit_app_password` بكلمة المرور المُنتجة

### 4. البديل المؤقت
إذا كنت تريد اختبار النظام بدون إيميل حقيقي، يمكنك:
1. تشغيل التطبيق كما هو
2. ستظهر رسالة في console تحتوي على OTP
3. استخدم هذا الرمز في شاشة التحقق

### 5. خدمات بديلة
يمكنك استخدام:
- **EmailJS**: خدمة مجانية لإرسال الإيميلات
- **SendGrid**: خدمة احترافية
- **Firebase Functions**: مع Nodemailer

## ملاحظات مهمة:
- لا تشارك كلمة مرور التطبيق مع أحد
- احفظها في متغير بيئة في الإنتاج
- تأكد من تفعيل "Less secure app access" إذا لزم الأمر