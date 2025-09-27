from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/notifications/', include('notifications.urls')),
    path('api/auth/', include('auth_system.urls')),
]