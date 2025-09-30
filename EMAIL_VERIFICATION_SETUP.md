# إعداد نظام التحقق من البريد الإلكتروني - Email Verification

## الخطوات المطلوبة خارج الكود:

### 1. إعداد خدمة البريد الإلكتروني (Gmail):

#### أ) إنشاء حساب Gmail أو استخدام حساب موجود
- اذهب إلى [Gmail](https://gmail.com)
- سجل دخول أو أنشئ حساب جديد

#### ب) تفعيل المصادقة الثنائية:
1. اذهب إلى [Google Account Settings](https://myaccount.google.com)
2. اختر "Security" من القائمة الجانبية
3. فعل "2-Step Verification"

#### ج) إنشاء App Password:
1. في نفس صفحة Security
2. اختر "App passwords"
3. اختر "Mail" كنوع التطبيق
4. اختر "Other" واكتب "Django Email Service"
5. انسخ كلمة المرور المُنشأة (16 رقم)

### 2. تحديث ملف .env:

```env
# Email Configuration
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=your-16-digit-app-password
EMAIL_USE_TLS=True
DEFAULT_FROM_EMAIL=your-email@gmail.com
```

**استبدل:**
- `your-email@gmail.com` ببريدك الإلكتروني الفعلي
- `your-16-digit-app-password` بكلمة مرور التطبيق التي حصلت عليها

### 3. تشغيل Django Server:

```bash
cd django_backend
pip install -r requirements.txt
python manage.py makemigrations
python manage.py migrate
python manage.py runserver
```

### 4. اختبار النظام:

#### أ) من Flutter App:
1. افتح التطبيق
2. اذهب إلى شاشة تسجيل الدخول
3. أدخل بريد إلكتروني صحيح
4. اضغط على "التحقق من البريد الإلكتروني"
5. ستظهر شاشة OTP
6. تحقق من بريدك الإلكتروني واكتب الرمز المكون من 6 أرقام

#### ب) من Django Admin:
1. اذهب إلى `http://127.0.0.1:8000/admin/`
2. سجل دخول كمدير
3. تحقق من جدول "Email verifications" لرؤية السجلات

### 5. API Endpoints:

#### إرسال OTP:
```
POST http://127.0.0.1:8000/api/auth/send-otp/
Content-Type: application/json

{
    "email": "user@example.com"
}
```

#### التحقق من OTP:
```
POST http://127.0.0.1:8000/api/auth/verify-otp/
Content-Type: application/json

{
    "email": "user@example.com",
    "otp_code": "123456"
}
```

## المميزات المُضافة:

### في Django Backend:
- ✅ نموذج EmailVerification لحفظ رموز OTP
- ✅ خدمة إرسال البريد الإلكتروني
- ✅ API endpoints للإرسال والتحقق
- ✅ انتهاء صلاحية الرمز بعد 10 دقائق
- ✅ حد أقصى 3 محاولات للتحقق
- ✅ حذف الرموز القديمة عند إنشاء رمز جديد

### في Flutter App:
- ✅ شاشة OTP مع 6 حقول منفصلة
- ✅ عداد تنازلي لإعادة الإرسال (60 ثانية)
- ✅ التنقل التلقائي بين الحقول
- ✅ التحقق التلقائي عند إدخال الرقم الأخير
- ✅ رسائل خطأ واضحة
- ✅ إمكانية إعادة إرسال الرمز

## استكشاف الأخطاء:

### خطأ في إرسال البريد:
- تأكد من صحة بيانات Gmail في ملف .env
- تأكد من تفعيل App Password
- تحقق من اتصال الإنترنت

### خطأ في قاعدة البيانات:
```bash
python manage.py makemigrations auth_system
python manage.py migrate
```

### خطأ في Flutter:
```bash
flutter pub get
flutter clean
flutter run
```