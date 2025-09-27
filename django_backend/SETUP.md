# Django Backend Setup Instructions

## 1. تثبيت المتطلبات
```bash
cd django_backend
pip install -r requirements.txt
```

## 2. إعداد Firebase
- احصل على ملف firebase-credentials.json من Firebase Console
- ضعه في مجلد django_backend
- تأكد من تفعيل Firebase Cloud Messaging

## 3. تشغيل الخادم
```bash
python manage.py migrate
python manage.py runserver
```

## 4. اختبار الـ API
```bash
# تسجيل FCM Token
curl -X POST http://localhost:8000/api/notifications/register-token/ \
  -H "Content-Type: application/json" \
  -d '{"user_id": "test_user", "token": "fcm_token_here", "platform": "android"}'

# إرسال إشعار وجبة
curl -X POST http://localhost:8000/api/notifications/meal-added/ \
  -H "Content-Type: application/json" \
  -d '{"user_name": "أحمد", "meal_name": "كبسة", "location": "الرياض", "notification_type": "new_meal", "title": "وجبة جديدة!", "body": "أحمد أضاف كبسة في الرياض"}'
```

## الـ Endpoints المتاحة:
- POST /api/notifications/register-token/ - تسجيل FCM token
- POST /api/notifications/meal-added/ - إشعار وجبة جديدة  
- POST /api/notifications/send/ - إشعار مخصص