from django.db import models

class FCMToken(models.Model):
    user_id = models.CharField(max_length=100)
    token = models.TextField()
    platform = models.CharField(max_length=20, choices=[('android', 'Android'), ('ios', 'iOS')])
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    is_active = models.BooleanField(default=True)

    class Meta:
        unique_together = ['user_id', 'token']

class NotificationLog(models.Model):
    NOTIFICATION_TYPES = [
        ('new_meal', 'وجبة جديدة'),
        ('meal_update', 'تحديث وجبة'),
        ('chat_message', 'رسالة جديدة'),
        ('custom', 'مخصص'),
    ]
    
    notification_type = models.CharField(max_length=20, choices=NOTIFICATION_TYPES)
    title = models.CharField(max_length=200)
    body = models.TextField()
    data = models.JSONField(null=True, blank=True)
    sent_to_count = models.IntegerField(default=0)
    success_count = models.IntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)