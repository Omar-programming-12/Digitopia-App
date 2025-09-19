# Digitopia App

تطبيق مشاركة الوجبات المحلية

## المميزات
- مشاركة الوجبات مع الجيران
- البحث عن الوجبات القريبة
- نظام الدردشة
- الخرائط والمواقع
- الإشعارات

## التقنيات المستخدمة
- Flutter
- Firebase (Firestore, Storage, Messaging)
- Supabase
- Provider للحالة
- SharedPreferences

## التشغيل
```bash
flutter pub get
flutter run
```

## البنية
```
lib/
├── constants/     # الثوابت والألوان
├── models/        # نماذج البيانات
├── screens/       # شاشات التطبيق
├── services/      # الخدمات
├── utils/         # الأدوات المساعدة
└── widgets/       # الويدجت المخصصة
```