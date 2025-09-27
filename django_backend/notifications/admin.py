from django.contrib import admin
from .models import NotificationLog

@admin.register(NotificationLog)
class NotificationLogAdmin(admin.ModelAdmin):
    list_display = ['title', 'notification_type', 'sent_to_count', 'success_count', 'created_at']
    list_filter = ['notification_type', 'created_at']
    search_fields = ['title', 'body']
    readonly_fields = ['created_at']