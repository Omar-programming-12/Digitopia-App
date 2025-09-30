#!/usr/bin/env python
import os
import sys
import django
from django.core.management import execute_from_command_line

if __name__ == '__main__':
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'django_backend.settings')
    django.setup()
    
    # تشغيل migrations
    execute_from_command_line(['manage.py', 'makemigrations'])
    execute_from_command_line(['manage.py', 'migrate'])
    
    # تشغيل السيرفر
    execute_from_command_line(['manage.py', 'runserver', '127.0.0.1:8000'])