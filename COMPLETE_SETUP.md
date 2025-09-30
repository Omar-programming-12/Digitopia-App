# Digitopia App - دليل التشغيل الكامل

## 🚀 إعداد المشروع

### 1. Flutter App
```bash
cd Digitopia-App-main
flutter pub get
flutter run
```

### 2. Django Backend للإشعارات
```bash
cd django_backend
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

## 🔧 الإعدادات المطلوبة

### Firebase Setup
1. إنشاء مشروع Firebase جديد
2. تفعيل Cloud Firestore
3. تفعيل Firebase Cloud Messaging
4. تحميل google-services.json ووضعه في android/app/
5. تحميل firebase-credentials.json ووضعه في django_backend/

### Django Settings
- تحديث رابط الخادم في `lib/services/django_notification_service.dart`
- وضع ملف Firebase credentials في مجلد django_backend

## 📱 المميزات المكتملة

### Clean Architecture
- ✅ Domain Layer (Entities, Repositories, Use Cases)
- ✅ Data Layer (Models, Data Sources, Repository Implementation)
- ✅ Presentation Layer (Controllers, Widgets)
- ✅ Dependency Injection مع GetIt

### نظام الإشعارات
- ✅ Django Backend للإشعارات
- ✅ Firebase Cloud Messaging
- ✅ إشعارات تلقائية عند إضافة وجبة
- ✅ تسجيل FCM Tokens
- ✅ إشعارات مخصصة

### الخدمات
- ✅ MealService مع Clean Architecture
- ✅ Django Notification Service
- ✅ Supabase Image Service
- ✅ Location Service

## 🔄 كيفية العمل

1. **إضافة وجبة جديدة**: 
   - المستخدم يضيف وجبة عبر التطبيق
   - يتم حفظها في Firestore
   - يرسل إشعار تلقائي عبر Django لجميع المستخدمين

2. **الإشعارات**:
   - Django يستقبل طلب الإشعار
   - يجلب جميع FCM Tokens المسجلة
   - يرسل الإشعار عبر Firebase Cloud Messaging

3. **البحث والخرائط**:
   - البحث في الوجبات حسب الاسم والموقع
   - عرض الوجبات القريبة على الخريطة

## 🛠️ التطوير المستقبلي

- [ ] إضافة نظام المحادثات
- [ ] تحسين نظام الخرائط
- [ ] إضافة نظام التقييمات
- [ ] تحسين واجهة المستخدم

## 📞 الدعم الفني

للمساعدة أو الاستفسارات، يرجى مراجعة الكود أو إنشاء issue جديد.