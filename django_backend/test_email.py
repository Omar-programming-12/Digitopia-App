#!/usr/bin/env python
import os
import sys
import django
from pathlib import Path

# إضافة مسار المشروع
BASE_DIR = Path(__file__).resolve().parent
sys.path.append(str(BASE_DIR))

# إعداد Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'settings')
django.setup()

from django.core.mail import send_mail
from django.conf import settings

def test_email():
    print("=== اختبار إرسال الإيميل ===")
    print(f"EMAIL_BACKEND: {settings.EMAIL_BACKEND}")
    print(f"EMAIL_HOST: {settings.EMAIL_HOST}")
    print(f"EMAIL_PORT: {settings.EMAIL_PORT}")
    print(f"EMAIL_HOST_USER: {settings.EMAIL_HOST_USER}")
    print(f"EMAIL_USE_TLS: {settings.EMAIL_USE_TLS}")
    print(f"DEFAULT_FROM_EMAIL: {settings.DEFAULT_FROM_EMAIL}")
    
    try:
        result = send_mail(
            subject='اختبار إرسال الإيميل',
            message='هذا اختبار لإرسال الإيميل من Django',
            from_email=settings.DEFAULT_FROM_EMAIL,
            recipient_list=['test@example.com'],
            fail_silently=False,
        )
        print(f"✅ تم إرسال الإيميل بنجاح: {result}")
        return True
    except Exception as e:
        print(f"❌ فشل في إرسال الإيميل: {e}")
        print(f"نوع الخطأ: {type(e).__name__}")
        return False

if __name__ == '__main__':
    test_email()