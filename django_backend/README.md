# Django Backend for Digitopia App Notifications

## Setup
```bash
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

## API Endpoints
- POST /api/notifications/meal-added/ - إرسال إشعار وجبة جديدة
- POST /api/notifications/register-token/ - تسجيل FCM token
- POST /api/notifications/send/ - إرسال إشعار مخصص