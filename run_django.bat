@echo off
cd django_backend
python manage.py makemigrations
python manage.py migrate
python manage.py runserver 8000