@echo off
echo بدء خادم Django للإشعارات...
cd django_backend
python manage.py makemigrations
python manage.py migrate
python manage.py runserver 0.0.0.0:8000
pause